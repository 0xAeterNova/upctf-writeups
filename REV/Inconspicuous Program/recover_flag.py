#!/usr/bin/env python3
from pathlib import Path
import struct

blob = Path("inconspicuous").read_bytes()

ENC_OFF = 0x2060
LEN_OFF = 0x2194

enc_len = struct.unpack_from("<I", blob, LEN_OFF)[0]
enc = blob[ENC_OFF:ENC_OFF + enc_len]

for length in range(0, 0x40):
    key = (length + 0x10) & 0xff
    dec = bytes(b ^ key for b in enc)

    if b"upCTF{" not in dec:
        continue

    start = dec.index(b"upCTF{")
    end = dec.index(b"}", start) + 1
    flag = dec[start:end].decode()

    password = []
    for i in range(len(dec) - 1):
        if dec[i] == 0x3C:  # cmp al, imm8
            password.append(dec[i + 1])

    print(f"[+] candidate length: {length}")
    print(f"[+] xor key: 0x{key:02x}")
    print(f"[+] password: {bytes(password).decode()}")
    print(f"[+] flag: {flag}")
