import fs from 'node:fs';
import path from 'node:path';
import { spawnSync } from 'node:child_process';

type MapSourceConfig = {
  repository?: string;
  ref?: string;
  path?: string;
  url: string;
};

type ExtraMapConfig = {
  name?: string;
  source: MapSourceConfig;
  output: {
    path: string;
  };
};

type DunWorldMapConfig = {
  source: MapSourceConfig;
  output?: {
    path?: string;
  };
  extra_maps?: ExtraMapConfig[];
  replacements?: Record<string, string>;
};

export const DUN_WORLD_GENERATED_MAP =
  '_maps/map_files/dun_world/dun_world_new.dmm';

const CONFIG_PATH = 'modular_abel/config/dun_world_map.json';
const DOWNLOAD_TIMEOUT_MS = 120000;

export async function prepareDunWorldMap() {
  const config = readConfig();
  const replacements = config.replacements || {};
  await generateMap({
    name: 'Dun World',
    source: config.source,
    outputPath: config.output?.path || DUN_WORLD_GENERATED_MAP,
    replacements,
  });

  for (const extraMap of config.extra_maps || []) {
    await generateMap({
      name: extraMap.name || extraMap.output.path,
      source: extraMap.source,
      outputPath: extraMap.output.path,
      replacements,
    });
  }
}

if (import.meta.main) {
  await prepareDunWorldMap();
}

function readConfig(): DunWorldMapConfig {
  const configText = fs.readFileSync(CONFIG_PATH, 'utf-8');
  const config = JSON.parse(configText) as DunWorldMapConfig;

  if (!config.source?.url) {
    throw new Error(`${CONFIG_PATH} must define source.url`);
  }
  for (const extraMap of config.extra_maps || []) {
    if (!extraMap.source?.url) {
      throw new Error(`${CONFIG_PATH} extra_maps entries must define source.url`);
    }
    if (!extraMap.output?.path) {
      throw new Error(
        `${CONFIG_PATH} extra_maps entries must define output.path`,
      );
    }
  }

  return config;
}

async function generateMap(options: {
  name: string;
  source: MapSourceConfig;
  outputPath: string;
  replacements: Record<string, string>;
}) {
  const sourceText = await loadSourceText(options.source, options.name);
  const structurallyAdjustedText =
    applySourcePathStructuralAdjustments(sourceText);
  const { text, replacementCount, configuredReplacementCount } =
    applyPathReplacements(structurallyAdjustedText, options.replacements);
  const adjustedText = applyDmmVarAdjustments(text);

  fs.mkdirSync(path.dirname(options.outputPath), { recursive: true });
  const temporaryOutputPath = `${options.outputPath}.tmp`;
  fs.writeFileSync(temporaryOutputPath, adjustedText);
  fs.renameSync(temporaryOutputPath, options.outputPath);

  if (configuredReplacementCount === 0) {
    console.log(
      `modular_abel: no ${options.name} path replacements configured yet; generated map is currently a raw copy.`,
    );
    return;
  }

  console.log(
    `modular_abel: generated ${options.outputPath} with ${replacementCount} path replacements.`,
  );
}

async function loadSourceText(
  source: MapSourceConfig,
  mapName: string,
): Promise<string> {
  console.log(`modular_abel: downloading ${mapName} source map from ${source.url}.`);
  return downloadText(source.url);
}

async function downloadText(url: string): Promise<string> {
  const controller = new AbortController();
  const timeout = setTimeout(() => controller.abort(), DOWNLOAD_TIMEOUT_MS);

  try {
    const response = await fetch(url, { signal: controller.signal });
    if (!response.ok) {
      throw new Error(`Failed to download ${url}: HTTP ${response.status}`);
    }
    return await response.text();
  } catch (error) {
    console.log(
      `modular_abel: Bun download failed (${String(error)}); retrying the same URL with curl.`,
    );
    return downloadTextWithCurl(url);
  } finally {
    clearTimeout(timeout);
  }
}

function downloadTextWithCurl(url: string): string {
  const downloadDirectory = 'tmp/modular_abel';
  const downloadPath = path.join(downloadDirectory, path.basename(url));

  fs.mkdirSync(downloadDirectory, { recursive: true });

  const result = spawnSync(
    process.platform === 'win32' ? 'curl.exe' : 'curl',
    ['-L', '--fail', '--silent', '--show-error', '--output', downloadPath, url],
    { encoding: 'utf-8' },
  );

  if (result.status !== 0) {
    throw new Error(
      `curl failed to download ${url}: ${result.stderr || result.stdout}`,
    );
  }

  return fs.readFileSync(downloadPath, 'utf-8');
}

function applyPathReplacements(
  sourceText: string,
  replacements: Record<string, string>,
) {
  const entries = Object.entries(replacements)
    .filter(([from, to]) => from.length > 0 && to.length > 0)
    .sort(([left], [right]) => right.length - left.length);

  let text = sourceText;
  let replacementCount = 0;

  for (const [from, to] of entries) {
    const pattern = new RegExp(`${escapeRegExp(from)}(?![A-Za-z0-9_/])`, 'g');
    const occurrences = countPatternOccurrences(text, pattern);
    if (occurrences === 0) {
      continue;
    }
    replacementCount += occurrences;
    text = text.replace(pattern, to);
  }

  return {
    text,
    replacementCount,
    configuredReplacementCount: entries.length,
  };
}

function applySourcePathStructuralAdjustments(sourceText: string): string {
  const directionalPaths: Record<string, { basePath: string; dir: number }> = {
    '/obj/structure/fluff/railing/border/north': {
      basePath: '/obj/structure/fluff/railing/border',
      dir: 1,
    },
    '/obj/structure/fluff/railing/border/east': {
      basePath: '/obj/structure/fluff/railing/border',
      dir: 4,
    },
    '/obj/structure/fluff/railing/border/west': {
      basePath: '/obj/structure/fluff/railing/border',
      dir: 8,
    },
    '/obj/structure/fluff/railing/wood/north': {
      basePath: '/obj/structure/fluff/railing/wood',
      dir: 1,
    },
    '/obj/structure/fluff/railing/wood/east': {
      basePath: '/obj/structure/fluff/railing/wood',
      dir: 4,
    },
    '/obj/structure/fluff/railing/wood/west': {
      basePath: '/obj/structure/fluff/railing/wood',
      dir: 8,
    },
  };

  return sourceText
    .split(/\r?\n/)
    .flatMap((line) => {
      const match = line.match(
        /^(\s*)(\/obj\/structure\/fluff\/railing\/(?:border|wood)\/(?:north|east|west))([,{])$/,
      );
      if (!match) {
        return line;
      }

      const [, indent, sourcePath, terminator] = match;
      const adjustment = directionalPaths[sourcePath];
      if (!adjustment) {
        return line;
      }

      if (terminator === '{') {
        return [
          `${indent}${adjustment.basePath}{`,
          `${indent}\tdir = ${adjustment.dir};`,
        ];
      }

      return [
        `${indent}${adjustment.basePath}{`,
        `${indent}\tdir = ${adjustment.dir}`,
        `${indent}\t},`,
      ];
    })
    .join('\n');
}

function applyDmmVarAdjustments(sourceText: string): string {
  const removedVarPattern =
    /^\s*(?:broadcaster_tag|gid|keycontrol|location_tag|scom_tag|specific_location)\s*=\s*".*";?\s*$/;
  const removedNumberVarPattern =
    /^\s*(?:lockdifficulty|lock_strength|mammonsiphoned|obj_integrity|order)\s*=\s*-?\d+(?:\.\d+)?;?\s*$/;
  const removedFlagVarPattern =
    /^\s*(?:keylock|masterkey|smooth)\s*=\s*[01];?\s*$/;

  return sourceText
    .split(/\r?\n/)
    .flatMap((line) => {
      const lockedMatch = line.match(/^(\s*)locked\s*=\s*([01]);?\s*$/);
      if (lockedMatch) {
        if (lockedMatch[2] === '1') {
          return `${lockedMatch[1]}lock = /datum/lock/key/locked;`;
        }
        return [];
      }

      if (
        line === '' ||
        removedVarPattern.test(line) ||
        removedNumberVarPattern.test(line) ||
        removedFlagVarPattern.test(line)
      ) {
        return [];
      }

      return line;
    })
    .join('\n');
}

function countPatternOccurrences(text: string, pattern: RegExp): number {
  let count = 0;

  for (const _match of text.matchAll(pattern)) {
    count += 1;
  }

  return count;
}

function escapeRegExp(text: string): string {
  return text.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}
