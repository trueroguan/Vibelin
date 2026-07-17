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

        missing = [n for n in state_names if n not in by_name]
        if missing:
            raise SystemExit(f'states not found in {src_path}: {missing}')

        for name in state_names:
            start_idx, cells, st = by_name[name]
            for c in range(cells):
                cell_idx = start_idx + c
                row, col = divmod(cell_idx, columns)
                box = (col * w, row * h, col * w + w, row * h + h)
                out_cells.append(img.crop(box))
            out_states.append({'name': name, 'dirs': st['dirs'], 'frames': st['frames'], 'delay': st['delay']})

    total = len(out_cells)
    out_img = Image.new('RGBA', (width * total, height), (0, 0, 0, 0))
    for i, cell in enumerate(out_cells):
        out_img.paste(cell, (i * width, 0))

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
        print('indented state names one per line, repeated per source.')
        sys.exit(1)
    merge(sys.argv[1], load_spec(sys.argv[2]))
