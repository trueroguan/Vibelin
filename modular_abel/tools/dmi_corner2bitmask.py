import sys
import io
from dmi_extract import parse_description, build_description, ztxt_chunk, png_chunk, read_chunks
from PIL import Image

N, S, E, W = 1, 2, 4, 8
NE, SE, SW, NW = 16, 32, 64, 128

TARGET_JUNCTIONS = sorted({
    (j & (N | S | E | W))
    | (NE if (j & N and j & E and j & NE) else 0)
    | (SE if (j & S and j & E and j & SE) else 0)
    | (SW if (j & S and j & W and j & SW) else 0)
    | (NW if (j & N and j & W and j & NW) else 0)
    for j in range(256)
})


def quadrant_suffix(q, j):
    if q == 1:
        a, b, d = j & N, j & W, j & NW
        edge_a, edge_b, corner = '1-n', '1-w', '1-nw'
        full, inner = '1-f', '1-i'
    elif q == 2:
        a, b, d = j & N, j & E, j & NE
        edge_a, edge_b, corner = '2-n', '2-e', '2-ne'
        full, inner = '2-f', '2-i'
    elif q == 3:
        a, b, d = j & S, j & W, j & SW
        edge_a, edge_b, corner = '3-s', '3-w', '3-sw'
        full, inner = '3-f', '3-i'
    else:
        a, b, d = j & S, j & E, j & SE
        edge_a, edge_b, corner = '4-s', '4-e', '4-se'
        full, inner = '4-f', '4-i'
    if a and b and d:
        return full
    if a and b:
        return inner
    if not a and b:
        return edge_a
    if a and not b:
        return edge_b
    return corner


def convert(src_path, dest_path, prefix, base_state):
    w, h, states = parse_description(src_path)
    img = Image.open(src_path).convert('RGBA')
    columns = img.width // w

    cells = {}
    idx = 0
    for st in states:
        count = st['dirs'] * st['frames']
        row, col = divmod(idx, columns)
        cells[st['name']] = img.crop((col * w, row * h, col * w + w, row * h + h))
        idx += count

    hw, hh = w // 2, h // 2
    boxes = {1: (0, 0, hw, hh), 2: (hw, 0, w, hh), 3: (0, hh, hw, h), 4: (hw, hh, w, h)}

    out_states = []
    out_cells = []
    if base_state in cells:
        out_states.append({'name': prefix, 'dirs': 1, 'frames': 1, 'delay': None})
        out_cells.append(cells[base_state])

    for j in TARGET_JUNCTIONS:
        canvas = Image.new('RGBA', (w, h), (0, 0, 0, 0))
        for q in (1, 2, 3, 4):
            src_name = quadrant_suffix(q, j)
            if src_name not in cells:
                raise SystemExit(f'{src_path}: missing corner state {src_name}')
            box = boxes[q]
            canvas.paste(cells[src_name].crop(box), box)
        out_states.append({'name': f'{prefix}-{j}', 'dirs': 1, 'frames': 1, 'delay': None})
        out_cells.append(canvas)

    total = len(out_cells)
    out_img = Image.new('RGBA', (w * total, h), (0, 0, 0, 0))
    for i, cell in enumerate(out_cells):
        out_img.paste(cell, (i * w, 0))

    buf = io.BytesIO()
    out_img.save(buf, format='PNG')
    png_bytes = buf.getvalue()
    sig = png_bytes[:8]
    chunks = read_chunks(png_bytes)
    desc_text = build_description(w, h, out_states)
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
    print(f'{dest_path}: {len(out_states)} state(s) ({len(TARGET_JUNCTIONS)} junctions), prefix "{prefix}"')


if __name__ == '__main__':
    if len(sys.argv) != 5:
        print('usage: python dmi_corner2bitmask.py <src.dmi> <dest.dmi> <prefix> <base_state>')
        print('converts a roguetown corner-quadrant wall sheet (states 1-i/2-n/.../4-f)')
        print('into a 47-junction SMOOTH_BITMASK sheet named <prefix>-<junction>,')
        print('with <base_state> copied in as the map-editor preview state <prefix>.')
        sys.exit(1)
    convert(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4])
