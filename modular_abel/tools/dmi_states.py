import sys
import zlib


def dmi_states(path):
    with open(path, 'rb') as f:
        data = f.read()
    pos = 8
    desc = None
    while pos < len(data):
        length = int.from_bytes(data[pos:pos + 4], 'big')
        ctype = data[pos + 4:pos + 8]
        chunk = data[pos + 8:pos + 8 + length]
        if ctype == b'zTXt':
            keyword, rest = chunk.split(b'\x00', 1)
            if keyword == b'Description':
                desc = zlib.decompress(rest[1:]).decode('utf-8', 'replace')
                break
        pos += 12 + length
    if desc is None:
        return []
    states = []
    for line in desc.splitlines():
        line = line.strip()
        if line.startswith('state = '):
            states.append(line[len('state = '):].strip('"'))
    return states


if __name__ == '__main__':
    if len(sys.argv) == 2:
        for s in dmi_states(sys.argv[1]):
            print(s)
    else:
        a = set(dmi_states(sys.argv[1]))
        b = set(dmi_states(sys.argv[2]))
        print('only in', sys.argv[2] + ':')
        for s in sorted(b - a):
            print(' ', s)
