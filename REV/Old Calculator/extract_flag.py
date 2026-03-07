# extract_flag.py
from pathlib import Path

data = Path("PROG.8xp").read_bytes()

# Encoded 18-byte target: starts right after the asm marker + jp stub
enc = data[0x4F:0x4F + 0x12]

def step(a):
    carry = a & 1
    a >>= 1
    if carry:
        a ^= 0xB8
    return a & 0xFF

def key_to_char(a):
    if 0x8E <= a < 0x98:
        return chr(a - 0x8E + ord('0'))
    if 0x9A <= a < 0xB4:
        return chr(a - 0x9A + ord('A'))
    raise ValueError(f"unexpected keycode: {a:#x}")

c = 0xA5
out = []
for b in enc:
    c = step(c)
    out.append(b ^ c)

code = ''.join(key_to_char(x) for x in out)
print(code)
print(f"upCTF{{{code}}}")
