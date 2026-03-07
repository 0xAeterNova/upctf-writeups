#!/usr/bin/env python3
import os
import re
import socket
import sys
from typing import Optional

HOST = os.environ.get('HOST', '46.225.117.62')
PORT = int(os.environ.get('PORT', '30003'))
TARGET = b"xSTF is the best portuguese CTF team :P"
BLOCK = 16
FLAG_RE = re.compile(rb"upCTF\{[^\n\r]*\}")


def bxor(a: bytes, b: bytes) -> bytes:
    return bytes(x ^ y for x, y in zip(a, b))


class CapsuleClient:
    def __init__(self, host: str, port: int):
        self.host = host
        self.port = port
        self.sock = socket.create_connection((host, port), timeout=10)
        self.file = self.sock.makefile('rwb', buffering=0)
        self._sync()

    def _sync(self) -> None:
        self.sock.settimeout(2)
        data = b''
        try:
            while True:
                chunk = self.sock.recv(4096)
                if not chunk:
                    break
                data += chunk
                if b'>' in data:
                    break
        except Exception:
            pass
        finally:
            self.sock.settimeout(10)
        if data:
            sys.stderr.buffer.write(data)

    def query(self, raw: bytes) -> bytes:
        self.file.write(raw.hex().encode() + b'\n')
        out = b''
        while True:
            ch = self.file.read(1)
            if not ch:
                break
            out += ch
            if out.endswith(b'\n>') or out.endswith(b'\n> '):
                break
        if out.endswith(b'\n> '):
            out = out[:-3]
        elif out.endswith(b'\n>'):
            out = out[:-2]
        return out.strip()

    def close(self) -> None:
        try:
            self.file.close()
        finally:
            self.sock.close()



def is_valid_padding(resp: bytes) -> bool:
    return (
        b'Padding is incorrect.' not in resp
        and b'PKCS#7 padding is incorrect.' not in resp
        and b'Incomplete Block' not in resp
        and b'boundary in CBC mode' not in resp
    )



def recover_intermediate(client: CapsuleClient, c: bytes) -> bytes:
    inter = [0] * BLOCK
    prefix = bytearray(os.urandom(BLOCK))

    for pos in range(BLOCK - 1, -1, -1):
        pad = BLOCK - pos

        for j in range(BLOCK - 1, pos, -1):
            prefix[j] = inter[j] ^ pad

        found: Optional[int] = None
        for g in range(256):
            prefix[pos] = g
            resp = client.query(bytes(prefix) + c)
            if is_valid_padding(resp):
                if pos == BLOCK - 1:
                    test = bytearray(prefix)
                    test[BLOCK - 2] ^= 1
                    resp2 = client.query(bytes(test) + c)
                    if not is_valid_padding(resp2):
                        continue
                found = g ^ pad
                break

        if found is None:
            raise RuntimeError(f'failed to recover byte at offset {pos}')

        inter[pos] = found
        print(f'[*] recovered I[{pos}] = 0x{found:02x}', file=sys.stderr)

    return bytes(inter)



def build_payload(client: CapsuleClient) -> bytes:
    padlen = BLOCK - (len(TARGET) % BLOCK)
    padded = TARGET + bytes([padlen]) * padlen
    blocks = [padded[i:i + BLOCK] for i in range(0, len(padded), BLOCK)]

    c3 = os.urandom(BLOCK)
    print('[*] recovering D(C3)...', file=sys.stderr)
    i3 = recover_intermediate(client, c3)
    c2 = bxor(i3, blocks[2])

    print('[*] recovering D(C2)...', file=sys.stderr)
    i2 = recover_intermediate(client, c2)
    c1 = bxor(i2, blocks[1])

    print('[*] recovering D(C1)...', file=sys.stderr)
    i1 = recover_intermediate(client, c1)
    iv = bxor(i1, blocks[0])

    return iv + c1 + c2 + c3



def main() -> int:
    client = CapsuleClient(HOST, PORT)
    try:
        payload = build_payload(client)
        print(f'[*] forged payload = {payload.hex()}', file=sys.stderr)
        resp = client.query(payload)
        sys.stdout.buffer.write(resp + b'\n')
        m = FLAG_RE.search(resp)
        if m:
            print(m.group(0).decode())
            return 0
        return 1
    finally:
        client.close()


if __name__ == '__main__':
    raise SystemExit(main())
