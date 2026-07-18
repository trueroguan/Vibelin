import os
import re
import sys

ROOTS = ['code', 'modular_abel']
declared = set()

for root_dir in ROOTS:
    for root, dirs, files in os.walk(root_dir):
        for fn in files:
            if not fn.endswith('.dm'):
                continue
            with open(os.path.join(root, fn), encoding='utf-8', errors='replace') as f:
                for line in f:
                    if not line.startswith('/'):
                        continue
                    if line.startswith('//'):
                        continue
                    m = re.match(r'^(/[\w/]+)', line)
                    if not m:
                        continue
                    path = m.group(1)
                    parts = path.split('/')
                    for i in range(2, len(parts) + 1):
                        declared.add('/'.join(parts[:i]))

print(f"declared (with ancestors): {len(declared)}")

bad = {}
for map_path in sys.argv[1:]:
    with open(map_path, encoding='utf-8', errors='replace') as f:
        for line_no, line in enumerate(f, 1):
            if line.startswith('('):
                break
            m = re.match(r'^(/[\w/]+)[,{)]', line)
            if not m:
                continue
            p = m.group(1)
            if p not in declared:
                bad.setdefault(p, (map_path, line_no))

if bad:
    print(f"MISSING TYPES: {len(bad)}")
    for p, (mp, ln) in sorted(bad.items()):
        print(f"  {p}  (first: {mp}:{ln})")
    sys.exit(1)
print("all map paths resolve")
