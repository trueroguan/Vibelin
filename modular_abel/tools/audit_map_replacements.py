"""Report dun_world map replacements that still fall back to a generic parent.

The replacement table in modular_abel/dun_world/config/map.json maps Azure type paths onto
Vanderlin ones. Where no equivalent existed at the time, the entry was pointed at an ancestor
instead - the object still spawns, but as a plain parent, so an iron vein becomes bare rock and a
noble dress becomes a nondescript piece of clothing. Every content merge can turn some of those
fallbacks into real ports, so re-run this afterwards and repoint whatever it finds.

Run from the repository root:
    python modular_abel/tools/audit_map_replacements.py

Candidates are suggestions, not answers - a shared trailing segment is a hint, and every proposal
needs a look at the actual type before it goes into map.json.
"""
import json
import os
import re
import sys
from collections import defaultdict

ROOTS = ['code', 'modular_abel']
CONFIG = os.path.join('modular_abel', 'dun_world', 'config', 'map.json')
GENERATED_MAP = os.path.join('_maps', 'map_files', 'dun_world', 'dun_world_new.dmm')


def declared_type_paths():
    """Every type path in the compile, including the ancestors DM creates implicitly."""
    declared = set()
    for root_dir in ROOTS:
        for root, _dirs, files in os.walk(root_dir):
            for fn in files:
                if not fn.endswith('.dm'):
                    continue
                with open(os.path.join(root, fn), encoding='utf-8', errors='replace') as f:
                    for line in f:
                        if not line.startswith('/') or line.startswith('//'):
                            continue
                        m = re.match(r'^(/[\w/]+)', line)
                        if not m:
                            continue
                        parts = m.group(1).split('/')
                        for i in range(2, len(parts) + 1):
                            declared.add('/'.join(parts[:i]))
    return declared


def map_usage():
    """How many prototypes in the generated map use each path, to rank findings by blast radius."""
    usage = defaultdict(int)
    if not os.path.exists(GENERATED_MAP):
        return usage
    with open(GENERATED_MAP, encoding='utf-8', errors='replace') as f:
        for line in f:
            if line.startswith('('):
                break
            m = re.match(r'^(/[\w/]+)[,{)]', line)
            if m:
                usage[m.group(1)] += 1
    return usage


def main():
    if not os.path.exists(CONFIG):
        sys.exit(f"run this from the repository root - {CONFIG} not found from {os.getcwd()}")

    with open(CONFIG, encoding='utf-8') as f:
        replacements = json.load(f)['replacements']
    declared = declared_type_paths()
    usage = map_usage()

    by_prefix = defaultdict(list)
    for path in declared:
        parts = path.split('/')
        for i in range(2, len(parts)):
            by_prefix['/'.join(parts[:i])].append(path)

    findings = []
    for source, target in replacements.items():
        if not source.startswith(target + '/'):
            continue  # a real port, not a fallback
        source_tail = [p for p in source[len(target):].split('/') if p]
        candidates = []
        for candidate in by_prefix.get(target, []):
            if candidate in (target, source):
                continue
            candidate_tail = [p for p in candidate[len(target):].split('/') if p]
            if not candidate_tail or candidate_tail[-1] != source_tail[-1]:
                continue
            candidates.append((len(set(candidate_tail) & set(source_tail)), candidate))
        if source in declared:
            candidates.append((99, source))  # the Azure path itself now exists
        if not candidates:
            continue
        candidates.sort(key=lambda c: (-c[0], len(c[1])))
        findings.append((usage.get(target, 0), source, target, [c for _s, c in candidates[:3]]))

    findings.sort(reverse=True)
    if not findings:
        print('no fallback replacement has a better target in the current type tree')
        return

    print(f'{len(findings)} fallback replacement(s) may now have a real target:\n')
    for used, source, target, candidates in findings:
        print(f'{source}')
        print(f'    falls back to {target}  ({used} prototype(s) on the generated map)')
        for candidate in candidates:
            print(f'    candidate: {candidate}')
        print()


main()
