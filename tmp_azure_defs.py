import os
import re
import sys

PATHS = [
    "/obj/structure/table/wood/poker",
    "/obj/structure/table/cooling",
    "/obj/structure/chair/arrestchair",
    "/obj/structure/chair/frankenstein",
    "/obj/structure/chair/frankenstein/zizo",
    "/obj/structure/chair/freedomchair",
    "/obj/structure/chair/bench/couch",
    "/obj/structure/chair/bench/couch/r",
    "/obj/structure/chair/bench/couchamagenta",
    "/obj/structure/chair/bench/couchamagenta/r",
    "/obj/structure/roguewindow",
    "/obj/structure/roguewindow/harem2",
    "/obj/structure/roguewindow/harem3",
    "/obj/structure/stone_rack",
    "/obj/structure/fluff/walldeco/alarm",
    "/obj/structure/fluff/walldeco/artificerflag",
    "/obj/structure/fluff/walldeco/barbersign",
    "/obj/structure/fluff/walldeco/barbersignreverse",
    "/obj/structure/fluff/walldeco/flower",
    "/obj/structure/fluff/walldeco/mageguild2",
    "/obj/structure/fluff/walldeco/rpainting",
    "/obj/structure/fluff/walldeco/psybanner",
    "/obj/structure/fluff/walldeco/psybanner/astrata",
    "/obj/structure/fluff/walldeco/psybanner/astrata/red",
    "/obj/structure/fluff/walldeco/psybanner/tennite",
    "/obj/structure/fluff/walldeco/psybanner/tennite/red",
    "/obj/structure/fluff/walldeco/psybanner/zizo",
    "/obj/structure/fluff/walldeco/psybanner/zizo/red",
    "/obj/structure/fluff/walldeco/stone/bronze",
    "/obj/structure/fluff/walldeco/stone/stone2",
    "/obj/structure/fluff/walldeco/stone/stone3",
    "/obj/structure/fluff/walldeco/stone/stone4",
    "/obj/structure/fluff/walldeco/stone/stone5",
    "/obj/structure/fluff/walldeco/stone/stone6",
    "/turf/closed/wall/mineral/rogue/pipe",
    "/turf/closed/wall/mineral/rogue/pipe/corners",
    "/turf/closed/wall/mineral/rogue/pipe/corners/one",
    "/turf/closed/wall/mineral/rogue/pipe/corners/four",
    "/turf/closed/wall/mineral/rogue/pipe/corners/eight",
    "/turf/closed/wall/mineral/rogue/pipe/joint",
    "/turf/closed/wall/mineral/rogue/pipe/joint/one",
    "/turf/closed/wall/mineral/rogue/pipe/joint/four",
    "/turf/closed/wall/mineral/rogue/pipe/joint/eight",
    "/turf/closed/wall/mineral/rogue/pipe/line",
    "/turf/closed/wall/mineral/rogue/pipe/line/four",
    "/turf/closed/wall/mineral/rogue/decostone/mossy",
    "/turf/closed/wall/mineral/rogue/decostone/mossy/cand",
    "/turf/closed/wall/mineral/rogue/decostone/mossy/end",
    "/turf/closed/wall/mineral/rogue/decostone/mossy/long",
    "/turf/closed/wall/mineral/rogue/decostone/mossy/red",
    "/turf/closed/wall/mineral/rogue/decostone/mossy/red/cand",
    "/turf/closed/wall/mineral/rogue/decostone/mossy/red/long",
    "/turf/closed/wall/mineral/rogue/decostone/end",
    "/turf/closed/wall/mineral/rogue/decostone/end/east",
    "/turf/closed/wall/mineral/rogue/decostone/end/north",
    "/turf/closed/wall/mineral/rogue/decostone/end/west",
    "/turf/closed/wall/mineral/rogue/decostone/long",
    "/turf/closed/wall/mineral/rogue/decostone/long/east_west",
    "/turf/closed/wall/mineral/rogue/stone/blue_moss",
    "/turf/closed/wall/mineral/rogue/stone/red_moss",
    "/turf/closed/wall/mineral/rogue/stone/window/blue_moss",
    "/turf/closed/wall/mineral/rogue/wooddark/end",
    "/turf/closed/wall/mineral/rogue/wooddark/end/east",
    "/turf/closed/wall/mineral/rogue/wooddark/end/north",
    "/turf/closed/wall/mineral/rogue/wooddark/end/west",
]

VARS = re.compile(
    r'^\t(icon|icon_state|name|dir|desc|color|opacity|density)\s*=\s*(.+)$'
)

wanted = set(PATHS)
found = {}

for root, dirs, files in os.walk(sys.argv[1]):
    dirs[:] = [d for d in dirs if d not in ('.git',)]
    for fn in files:
        if not fn.endswith('.dm'):
            continue
        full = os.path.join(root, fn)
        try:
            with open(full, encoding='utf-8', errors='replace') as f:
                lines = f.read().splitlines()
        except OSError:
            continue
        current = None
        for line in lines:
            if line and not line[0] in ' \t/':
                current = None
            if line.startswith('/') and not line.startswith('//'):
                path = line.strip()
                current = path if path in wanted else None
                if current and current not in found:
                    found[current] = {'file': os.path.relpath(full, sys.argv[1])}
                continue
            if current and current in found:
                m = VARS.match(line)
                if m:
                    found[current][m.group(1)] = m.group(2).strip()

for p in PATHS:
    info = found.get(p)
    if not info:
        print(f"{p} -> NOT FOUND")
        continue
    bits = ', '.join(f"{k}={v}" for k, v in info.items() if k != 'file')
    print(f"{p} [{info['file']}] {bits}")
