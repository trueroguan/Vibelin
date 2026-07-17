import sys
import zlib
import struct
from PIL import Image


def read_chunks(data):
    pos = 8
    chunks = []
    while pos < len(data):
        length = int.from_bytes(data[pos:pos + 4], 'big')
        ctype = data[pos + 4:pos + 8]
        chunk = data[pos + 8:pos + 8 + length]
        chunks.append((ctype, chunk))
        pos += 12 + length
    return chunks


def parse_description(path):
    with open(path, 'rb') as f:
        data = f.read()
    desc = None
    for ctype, chunk in read_chunks(data):
        if ctype == b'zTXt':
            keyword, rest = chunk.split(b'\x00', 1)
            if keyword == b'Description':
                desc = zlib.decompress(rest[1:]).decode('utf-8', 'replace')
                break
    if desc is None:
        raise ValueError(f'{path}: no BYOND Description chunk found')

    width = height = None
    states = []
    cur = None
    for line in desc.splitlines():
        line = line.strip()
        if line.startswith('width = '):
            width = int(line[len('width = '):])
        elif line.startswith('height = '):
            height = int(line[len('height = '):])
        elif line.startswith('state = '):
            if cur is not None:
                states.append(cur)
            cur = {'name': line[len('state = '):].strip('"'), 'dirs': 1, 'frames': 1, 'delay': None}
        elif line == '# END DMI':
            if cur is not None:
                states.append(cur)
                cur = None
        elif cur is not None:
            if line.startswith('dirs = '):
                cur['dirs'] = int(line[len('dirs = '):])
            elif line.startswith('frames = '):
                cur['frames'] = int(line[len('frames = '):])
            elif line.startswith('delay = '):
                cur['delay'] = line[len('delay = '):]
    if cur is not None:
        states.append(cur)
    if width is None or height is None:
        raise ValueError(f'{path}: missing width/height in Description')
    return width, height, states


def build_description(width, height, states):
    lines = ['# BEGIN DMI', 'version = 4.0', f'\twidth = {width}', f'\theight = {height}']
    for st in states:
        lines.append(f'state = "{st["name"]}"')
        lines.append('\tdirs = %d' % st['dirs'])
        lines.append('\tframes = %d' % st['frames'])
        if st['delay']:
            lines.append(f'\tdelay = {st["delay"]}')
    lines.append('# END DMI')
    lines.append('')
    return '\n'.join(lines)


def ztxt_chunk(text):
    keyword = b'Description'
    compressed = zlib.compress(text.encode('utf-8'))
    data = keyword + b'\x00' + b'\x00' + compressed
    return png_chunk(b'zTXt', data)


def png_chunk(ctype, data):
    length = struct.pack('>I', len(data))
    crc = struct.pack('>I', zlib.crc32(ctype + data) & 0xffffffff)
    return length + ctype + data + crc


def extract(src_path, dest_path, state_names):
    width, height, states = parse_description(src_path)
    by_name = {}
    order = []
    idx = 0
    for st in states:
        cells = st['dirs'] * st['frames']
        by_name[st['name']] = (idx, cells, st)
        idx += cells
        order.append(st['name'])

    img = Image.open(src_path).convert('RGBA')
    columns = img.width // width

    missing = [n for n in state_names if n not in by_name]
    if missing:
        raise SystemExit(f'states not found in {src_path}: {missing}\navailable: {order}')

    out_states = []
    out_cells = []
    for name in state_names:
        start_idx, cells, st = by_name[name]
        for c in range(cells):
            cell_idx = start_idx + c
            row, col = divmod(cell_idx, columns)
            box = (col * width, row * height, col * width + width, row * height + height)
            out_cells.append(img.crop(box))
        out_states.append({'name': name, 'dirs': st['dirs'], 'frames': st['frames'], 'delay': st['delay']})

    total = len(out_cells)
    out_img = Image.new('RGBA', (width * total, height), (0, 0, 0, 0))
    for i, cell in enumerate(out_cells):
        out_img.paste(cell, (i * width, 0))

    import io
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

    print(f'{dest_path}: wrote {len(out_states)} state(s), {total} cell(s), {width}x{height}')


if __name__ == '__main__':
    if len(sys.argv) < 4:
        print('usage: python dmi_extract.py <source.dmi> <dest.dmi> state_a state_b ...')
        sys.exit(1)
    extract(sys.argv[1], sys.argv[2], sys.argv[3:])
