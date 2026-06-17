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

const CONFIG_PATH = 'modular_abel/dun_world/config/map.json';
const DOWNLOAD_TIMEOUT_MS = 120000;

const REMOVED_VAR_PATTERNS = [
  /^(?:broadcaster_tag|gid|keycontrol|location_tag|scom_tag|specific_location)\s*=\s*".*"$/,
  /^(?:lockdifficulty|lock_strength|mammonsiphoned|obj_integrity|order)\s*=\s*-?\d+(?:\.\d+)?$/,
  /^(?:keylock|masterkey|smooth)\s*=\s*[01]$/,
];

const TURF_REMOVED_VAR_PATTERN = /^(?:icon|icon_state)\s*=/;

const CLOSED_TURF_REMOVED_PATHS = [
  '/obj/structure/door',
  '/obj/structure/stairs',
  '/obj/structure/window',
];

export async function prepareDunWorldMap() {
  const config = readConfig();
  const replacements = config.replacements || {};
  await generateMap({
    name: 'Azure Peak',
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
    '/obj/structure/fluff/railing/corner': {
      basePath: '/obj/structure/fluff/railing/corner/dun_world',
      dir: 9,
    },
    '/obj/structure/fluff/railing/corner/north_east': {
      basePath: '/obj/structure/fluff/railing/corner/dun_world',
      dir: 5,
    },
    '/obj/structure/fluff/railing/corner/south_east': {
      basePath: '/obj/structure/fluff/railing/corner/dun_world',
      dir: 6,
    },
    '/obj/structure/fluff/railing/corner/south_west': {
      basePath: '/obj/structure/fluff/railing/corner/dun_world',
      dir: 10,
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
    '/turf/closed/wall/mineral/rogue/decostone/end/north': {
      basePath: '/turf/closed/wall/mineral/rogue/decostone/end',
      dir: 1,
    },
    '/turf/closed/wall/mineral/rogue/decostone/end/east': {
      basePath: '/turf/closed/wall/mineral/rogue/decostone/end',
      dir: 4,
    },
    '/turf/closed/wall/mineral/rogue/decostone/end/west': {
      basePath: '/turf/closed/wall/mineral/rogue/decostone/end',
      dir: 8,
    },
    '/turf/closed/wall/mineral/rogue/decostone/long/east_west': {
      basePath: '/turf/closed/wall/mineral/rogue/decostone/long',
      dir: 1,
    },
    '/turf/closed/wall/mineral/rogue/wooddark/end/north': {
      basePath: '/turf/closed/wall/mineral/rogue/wooddark/end',
      dir: 1,
    },
    '/turf/closed/wall/mineral/rogue/wooddark/end/east': {
      basePath: '/turf/closed/wall/mineral/rogue/wooddark/end',
      dir: 4,
    },
    '/turf/closed/wall/mineral/rogue/wooddark/end/west': {
      basePath: '/turf/closed/wall/mineral/rogue/wooddark/end',
      dir: 8,
    },
  };

  return sourceText
    .split(/\r?\n/)
    .flatMap((line) => {
      const match = line.match(/^(\s*)(\/[\w/]+)([,{])$/);
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

type PopEntry = {
  path: string;
  vars: string[][];
};

function applyDmmVarAdjustments(sourceText: string): string {
  const lines = sourceText.split(/\r?\n/);
  const output: string[] = [];
  let index = 0;

  while (index < lines.length) {
    const line = lines[index];
    if (!/^"[^"]*" = \($/.test(line)) {
      output.push(line);
      index += 1;
      continue;
    }

    const [entries, nextIndex] = parsePopEntries(lines, index + 1);
    index = nextIndex;
    output.push(line, ...emitPopEntries(adjustPopEntries(entries)));
  }

  return output.join('\n');
}

function parsePopEntries(
  lines: string[],
  startIndex: number,
): [PopEntry[], number] {
  const entries: PopEntry[] = [];
  let index = startIndex;
  let popClosed = false;

  while (!popClosed) {
    const entryLine = lines[index];
    if (entryLine === undefined) {
      throw new Error('Unterminated prototype pop in source map.');
    }
    index += 1;

    if (entryLine.endsWith('{')) {
      const entry: PopEntry = { path: entryLine.slice(0, -1), vars: [] };
      while (true) {
        const varLine = lines[index];
        if (varLine === undefined) {
          throw new Error(`Unterminated var block for ${entry.path}.`);
        }
        index += 1;

        const blockClose = varLine.match(/^\s*\}([,)])$/);
        if (blockClose) {
          popClosed = blockClose[1] === ')';
          break;
        }

        const varLines = [varLine];
        while (isInsideMultilineString(varLines)) {
          const continuation = lines[index];
          if (continuation === undefined) {
            throw new Error(`Unterminated multiline string for ${entry.path}.`);
          }
          index += 1;
          varLines.push(continuation);
        }

        const lastLine = varLines[varLines.length - 1];
        varLines[varLines.length - 1] = lastLine.replace(/;$/, '');
        entry.vars.push(varLines);
      }
      entries.push(entry);
    } else {
      popClosed = entryLine.endsWith(')');
      entries.push({ path: entryLine.slice(0, -1), vars: [] });
    }
  }

  return [entries, index];
}

function isInsideMultilineString(varLines: string[]): boolean {
  const text = varLines.join('\n');
  const opens = text.split('{"').length - 1;
  const closes = text.split('"}').length - 1;
  return opens > closes;
}

function normalizeDunWorldLockid(lockid: string): string {
  if (/^manor_knight/.test(lockid) || /^guest_knight/.test(lockid) || lockid === 'knight') return 'at_arms';
  if (/^squire_room/.test(lockid)) return 'at_arms';
  if (lockid === 'captain_bedroom' || lockid === 'sergeant' || lockid === 'armory') return 'garrison';
  if (/^manor_councillor/.test(lockid) || /^servant_room/.test(lockid)) return 'manor';
  if (lockid === 'heir' || lockid === 'heir1' || lockid === 'heir2' || lockid === 'royal' || lockid === 'baroness') return 'manor';
  if (/^church_bedroom/.test(lockid) || lockid === 'zhurch') return 'church';
  if (/^merc_bunk/.test(lockid) || lockid === 'merc') return 'mercenary';
  if (lockid === 'bath1' || lockid === 'bath2' || lockid === 'bath3') return 'bathhouse';
  if (lockid === 'crafterguild' || lockid === 'craftermaster' || lockid === 'townie_smith_extra') return 'artificer';
  if (lockid === 'towner_blacksmith') return 'blacksmith';
  if (/^stable_master/.test(lockid) || lockid === 'stablemaster' || lockid === 'keeper' || lockid === 'keeper2' || lockid === 'farm') return 'soilson';
  if (/^stall/.test(lockid) || lockid === 'shop') return 'merchant';
  if (lockid === 'warden') return 'dungeon';
  if (/^room/.test(lockid) || /^fancy/.test(lockid) || /^locker/.test(lockid)) return 'tavern';
  return lockid;
}

function adjustPopEntries(entries: PopEntry[]): PopEntry[] {
  const hasClosedTurf = entries.some(
    (entry) =>
      entry.path === '/turf/closed' || entry.path.startsWith('/turf/closed/'),
  );

  const adjusted: PopEntry[] = [];
  for (const entry of entries) {
    if (
      hasClosedTurf &&
      CLOSED_TURF_REMOVED_PATHS.some(
        (banned) =>
          entry.path === banned || entry.path.startsWith(`${banned}/`),
      )
    ) {
      continue;
    }

    const isTurf = entry.path.startsWith('/turf/');
    const isDoor = entry.path.startsWith('/obj/structure/door');

    let lockidValue: string | null = null;
    for (const varLines of entry.vars) {
      const lockidMatch = varLines[0].trim().match(/^lockid\s*=\s*"([^"]+)"$/);
      if (lockidMatch) {
        lockidValue = lockidMatch[1];
        break;
      }
    }

    const vars = entry.vars.flatMap((varLines) => {
      const varText = varLines[0].trim();

      const lockidMatch = varText.match(/^lockid\s*=\s*"([^"]+)"$/);
      if (lockidMatch) {
        return [[`\tlockids = list("${normalizeDunWorldLockid(lockidMatch[1])}")`]];
      }

      const lockedMatch = varText.match(/^locked\s*=\s*([01])$/);
      if (lockedMatch) {
        if (lockedMatch[1] !== '1') {
          return [];
        }
        const lockPath =
          isDoor && !lockidValue
            ? '/datum/lock/locked'
            : '/datum/lock/key/locked';
        return [[`\tlock = ${lockPath}`]];
      }

      if (REMOVED_VAR_PATTERNS.some((pattern) => pattern.test(varText))) {
        return [];
      }

      if (isTurf && TURF_REMOVED_VAR_PATTERN.test(varText)) {
        return [];
      }

      return [varLines];
    });

    adjusted.push({ path: entry.path, vars });
  }

  return adjusted;
}

function emitPopEntries(entries: PopEntry[]): string[] {
  const lines: string[] = [];

  entries.forEach((entry, entryIndex) => {
    const terminator = entryIndex === entries.length - 1 ? ')' : ',';

    if (entry.vars.length === 0) {
      lines.push(`${entry.path}${terminator}`);
      return;
    }

    lines.push(`${entry.path}{`);
    entry.vars.forEach((varLines, varIndex) => {
      const emitted = [...varLines];
      if (varIndex < entry.vars.length - 1) {
        emitted[emitted.length - 1] = `${emitted[emitted.length - 1]};`;
      }
      lines.push(...emitted);
    });
    lines.push(`\t}${terminator}`);
  });

  return lines;
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
