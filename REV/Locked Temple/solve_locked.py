from itertools import product

# Decoded bytes from .data[0x4020:0x4028] after 0x1bc0 runs
decoded = [0x71, 0x27, 0x9A, 0x1E, 0x77, 0x6D, 0x9F, 0x71]

def rol4(x):
    x &= 0xff
    return ((x << 4) & 0xff) | (x >> 4)

def check(seq):
    # first plate
    a = decoded[0] ^ 0x55
    if seq[0] != (a & 3):
        return False

    # remaining 7 plates
    for i in range(1, 8):
        v = (11 * i) ^ 0x55 ^ decoded[i]
        if seq[i - 1] & 1:
            v = rol4(v)
        if seq[i] != (v & 3):
            return False
    return True

solutions = [s for s in product(range(4), repeat=8) if check(s)]
print(solutions)
