import pathlib
import sys

sys.path.insert(0, '.')

import yaml

from tools.maplint.source import dmm, lint

lints = {}
for f in pathlib.Path('tools/maplint/lints').glob('*.yml'):
    lints[str(f)] = lint.Lint(yaml.safe_load(f.read_text(encoding='utf-8-sig')))
print(f"loaded {len(lints)} lints")

failed = False
for m in [
    '_maps/map_files/dun_world/dun_world_new.dmm',
    '_maps/map_files/otherz/wretch_coast_new.dmm',
]:
    with open(m, 'r') as fh:
        data = dmm.parse_dmm(fh)
    problems = []
    for name, l in lints.items():
        problems.extend(l.run(data))
    print(m, 'problems:', len(problems))
    for p in problems[:40]:
        print(f"  line {p.line_number}: {p}")
    if problems:
        failed = True

sys.exit(1 if failed else 0)
