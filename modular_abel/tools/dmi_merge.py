import sys
import io
from dmi_extract import parse_description, build_description, ztxt_chunk, png_chunk, read_chunks
from PIL import Image


def load_spec(spec_path):
    groups = []
    cur_src = None
    cur_states = []
    with open(spec_path, encoding='utf-8') as f:
        for line in f:
            line = line.rstrip('\n')
            if not line.strip():
                continue
            if line.startswith('\t') or line.startswith(' '):
                cur_states.append(line.strip())
            else:
                if cur_src is not None:
                    groups.append((cur_src, cur_states))
                cur_src = line.strip()
                cur_states = []
    if cur_src is not None:
        groups.append((cur_src, cur_states))
    return groups


def expand_entries(entries, source_state_names):
    import re
    resolved = []
    for entry in entries:
        if entry == '*':
            for name in source_state_names:
                resolved.append((name, name))
        elif '->' in entry:
            base, newbase = [p.strip() for p in entry.split('->', 1)]
            pattern = re.compile(r'^(l_|r_)?' + re.escape(base) + r'(_.+)?$')
            matched = False
            for name in source_state_names:
                m = pattern.match(name)
                if m:
                    matched = True
                    new_name = (m.group(1) or '') + newbase + (m.group(2) or '')
                    resolved.append((name, new_name))
            if not matched:
                raise SystemExit(f'rename base not found in source: {base}')
        else:
            resolved.append((entry, entry))
    return resolved


def merge(dest_path, groups):
    width = height = None
    out_states = []
    out_cells = []

    for src_path, state_names in groups:
        w, h, states = parse_description(src_path)
        if width is None:
            width, height = w, h
        elif (w, h) != (width, height):
            raise SystemExit(f'{src_path}: {w}x{h} does not match established {width}x{height} - split into a separate merge')

        by_name = {}
        idx = 0
        for st in states:
            cells = st['dirs'] * st['frames']
            by_name[st['name']] = (idx, cells, st)
            idx += cells

        img = Image.open(src_path).convert('RGBA')
        columns = img.width // w

        resolved = expand_entries(state_names, list(by_name))
        missing = [n for n, _ in resolved if n not in by_name]
        if missing:
            raise SystemExit(f'states not found in {src_path}: {missing}')

        for name, out_name in resolved:
            start_idx, cells, st = by_name[name]
            for c in range(cells):
                cell_idx = start_idx + c
                row, col = divmod(cell_idx, columns)
                box = (col * w, row * h, col * w + w, row * h + h)
                out_cells.append(img.crop(box))
            out_states.append({'name': out_name, 'dirs': st['dirs'], 'frames': st['frames'], 'delay': st['delay']})

    total = len(out_cells)
    out_cols = min(total, 32)
    out_rows = (total + out_cols - 1) // out_cols
    out_img = Image.new('RGBA', (width * out_cols, height * out_rows), (0, 0, 0, 0))
    for i, cell in enumerate(out_cells):
        row, col = divmod(i, out_cols)
        out_img.paste(cell, (col * width, row * height))

    buf = io.BytesIO()
    out_img.save(buf, format='PNG')
    png_bytes = buf.getvalue()

    sig = png_bytes[:8]
    chunks = read_chunks(png_bytes)
    desc_text = build_description(width, height, out_states)
    new_chunks = []
    inserted = False
    for ctype, chunk in chunks:
        if ctype in (b'tEXt', b'zTXt', b'iTXt'):
            continue
        new_chunks.append((ctype, chunk))
        if ctype == b'IHDR' and not inserted:
            new_chunks.append((b'zTXt', None))
            inserted = True

    out = bytearray(sig)
    for ctype, chunk in new_chunks:
        if chunk is None:
            out += ztxt_chunk(desc_text)
        else:
            out += png_chunk(ctype, chunk)

    with open(dest_path, 'wb') as f:
        f.write(out)

    print(f'{dest_path}: merged {len(out_states)} state(s) from {len(groups)} source(s), {total} cell(s), {width}x{height}')


if __name__ == '__main__':
    if len(sys.argv) != 3:
        print('usage: python dmi_merge.py <dest.dmi> <spec.txt>')
        print('spec.txt format: a source .dmi path on its own line, followed by')
        print('indented entries one per line, repeated per source. Entry forms:')
        print('  state            exact state, kept as-is')
        print('  *                every state in the source, kept as-is')
        print('  base -> newbase  every state matching (l_|r_)?base(_suffix)?')
        print('                   with the base segment substituted')
        sys.exit(1)
    merge(sys.argv[1], load_spec(sys.argv[2]))
