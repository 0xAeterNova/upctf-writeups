#!/usr/bin/env python3
import collections
import math

with open("passwords.txt", "r", encoding="utf-8") as f:
    lines = f.read().splitlines()

print(f"[+] lines: {len(lines)}")

tokens = []
for line in lines:
    token = "".join(c for c in line if not c.isupper())
    if len(token) != 25:
        raise ValueError(f"unexpected token length: {len(token)}")
    tokens.append(token)

print(f"[+] extracted tokens: {len(tokens)}")
print(f"[+] token length: {len(tokens[0])}")

alphabet = "abcdefghijklmnopqrstuvwxyz0123456789_"
expected = len(tokens) / len(alphabet)
sigma = math.sqrt(len(tokens) * (1 / len(alphabet)) * (1 - 1 / len(alphabet)))

secret = []
print("\n[+] per-column winners:")
for i in range(25):
    ctr = collections.Counter(t[i] for t in tokens)
    ch, cnt = ctr.most_common(1)[0]
    z = (cnt - expected) / sigma
    secret.append(ch)
    print(f"col {i:02d}: {ctr.most_common(3)}   z={z:.2f}")

result = "".join(secret)
print("\n[+] recovered message:")
print(result)
print(f"\n[+] flag: upCTF{{{result}}}")
