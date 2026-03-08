#!/usr/bin/env python3
import hmac
import hashlib

ALPH = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567"

def derive_suffix(prefix10: str) -> str:
    mac = hmac.new(b"IMNOTTHEKEY", prefix10.encode(), hashlib.sha256).digest()
    x = 0
    for b in mac[:7]:
        x = (x << 8) | b
    x >>= 6

    out = [""] * 10
    for i in range(9, -1, -1):
        out[i] = ALPH[x & 31]
        x >>= 5
    return "".join(out)

def inverse_permute(q: str) -> str:
    p = ["?"] * 20
    p[0]  = q[11]
    p[1]  = q[10]
    p[2]  = q[13]
    p[3]  = q[12]
    p[4]  = q[15]
    p[5]  = q[14]
    p[6]  = q[17]
    p[7]  = q[16]
    p[8]  = q[19]
    p[9]  = q[18]
    p[10] = q[1]
    p[11] = q[0]
    p[12] = q[3]
    p[13] = q[2]
    p[14] = q[5]
    p[15] = q[4]
    p[16] = q[7]
    p[17] = q[6]
    p[18] = q[9]
    p[19] = q[8]
    return "".join(p)

def hyphenate(s: str) -> str:
    return "-".join(s[i:i+5] for i in range(0, 20, 5))

prefix = "0123456789"
suffix = derive_suffix(prefix).lower()
q = prefix + suffix
p = inverse_permute(q)
key = hyphenate(p)

print("prefix :", prefix)
print("suffix :", suffix)
print("key    :", key)
