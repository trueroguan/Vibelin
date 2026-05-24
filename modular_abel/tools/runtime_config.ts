import fs from 'node:fs';
import path from 'node:path';

const UPSTREAM_CONFIG_DIR = 'config';
const MODULAR_MAPS_FRAGMENT = 'modular_abel/config/maps.dun_world.txt';

export const MODULAR_RUNTIME_CONFIG_DIR = 'tmp/modular_abel/config';

type RuntimeConfigOptions = {
  outputDir?: string;
  allowInPlace?: boolean;
};

export function prepareRuntimeConfig(options: RuntimeConfigOptions = {}) {
  const outputDir = normalizePath(
    options.outputDir || MODULAR_RUNTIME_CONFIG_DIR,
  );
  const writesUpstreamConfig =
    path.resolve(outputDir) === path.resolve(UPSTREAM_CONFIG_DIR);

  if (writesUpstreamConfig && !options.allowInPlace) {
    throw new Error(
      'Refusing to write config/maps.txt in place without allowInPlace.',
    );
  }

  if (!writesUpstreamConfig) {
    fs.rmSync(outputDir, { recursive: true, force: true });
    fs.mkdirSync(path.dirname(outputDir), { recursive: true });
    fs.cpSync(UPSTREAM_CONFIG_DIR, outputDir, { recursive: true });
  }

  const mapsPath = path.join(outputDir, 'maps.txt');
  appendModularMapBlock(mapsPath);

  console.log(`modular_abel: prepared runtime config at ${outputDir}.`);
  return outputDir;
}

function appendModularMapBlock(mapsPath: string) {
  let mapsText = fs.readFileSync(mapsPath, 'utf-8');

  if (/^\s*map\s+dun_world\s*$/im.test(mapsText)) {
    return;
  }

  const fragment = fs.readFileSync(MODULAR_MAPS_FRAGMENT, 'utf-8').trim();
  mapsText = `${mapsText.trimEnd()}\n\n# modular_abel downstream maps\n${fragment}\n`;
  fs.writeFileSync(mapsPath, mapsText);
}

function normalizePath(filePath: string) {
  return filePath.replace(/\\/g, '/');
}

function parseArgs(args: string[]) {
  let outputDir = MODULAR_RUNTIME_CONFIG_DIR;
  let allowInPlace = false;

  for (let i = 0; i < args.length; i++) {
    const arg = args[i];
    if (arg === '--output-dir') {
      const value = args[++i];
      if (!value) {
        throw new Error('Missing value for --output-dir');
      }
      outputDir = value;
    } else if (arg === '--in-place') {
      outputDir = UPSTREAM_CONFIG_DIR;
      allowInPlace = true;
    } else {
      throw new Error(`Unknown argument: ${arg}`);
    }
  }

  return { outputDir, allowInPlace };
}

if (import.meta.main) {
  try {
    prepareRuntimeConfig(parseArgs(process.argv.slice(2)));
  } catch (error) {
    console.error(error);
    process.exit(1);
  }
}
