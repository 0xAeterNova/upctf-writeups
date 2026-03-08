# LH | RH — Write-Up

Category: Crypto  
Challenge: LH | RH  
Flag Format: `upCTF{}`

## Description

> The math behind this one is pretty and not so difficult! (`p = L|R` and `q = R|L`)

## Files

- `handout.py`

## TL;DR

This challenge was RSA, but the primes were not random at all. The hint in the description was the whole vulnerability: if I split a prime into two decimal halves as `L | R`, then the other prime was just the swapped version `R | L`.

That gave the modulus a very specific base-`10^143` structure. Instead of trying to factor a huge RSA modulus normally, I rewrote it in terms of those two halves and recovered them directly from the decimal blocks of `n`.

Once I had `L` and `R`, I rebuilt `p` and `q`, computed `d`, decrypted `c`, and got the flag.

* * *

## Initial Analysis

I started by reading `handout.py`.

```python
from Crypto.Util.number import *

flag = open('flag.txt', 'rb').read()
m = bytes_to_long(flag)

e = 0x10001

L = getPrime(143 * 4)
R = getPrime(143 * 4)

p = int(str(L) + str(R))
q = int(str(R) + str(L))

n = p * q
c = pow(m, e, n)

print(f'{n = }')
print(f'{e = }')
print(f'{c = }')
```

The important part was here:

```python
p = int(str(L) + str(R))
q = int(str(R) + str(L))
```

So this was not just “RSA with large primes”. The two primes were decimal concatenations of the same two values in opposite order.

If I define:

```text
B = 10^143
p = L * B + R
q = R * B + L
```

then the entire problem becomes structured algebra instead of generic factorization.

That was the intended weakness.

* * *

## Why the Structure Leaks the Factors

Using:

```text
p = L * B + R
q = R * B + L
```

I can expand the modulus:

```text
n = p * q
  = (L * B + R)(R * B + L)
  = LR * B^2 + (L^2 + R^2) * B + LR
```

At this point I introduced two helper values:

```text
t = L * R
u = L^2 + R^2
```

So now:

```text
n = t * B^2 + u * B + t
```

That already shows a symmetry: the low block and high block are both tied to the same product `t`.

The only annoying part is that `t` and `u` themselves are bigger than one base-`B` limb, so there can be carries when I split `n` into base-`B` chunks.

That is still easy to handle.

* * *

## Splitting the Modulus into Base-`10^143` Blocks

I wrote:

```text
n = N3 * B^3 + N2 * B^2 + N1 * B + N0
```

where each `Ni` is the corresponding block of `n` in base `B = 10^143`.

Now write:

```text
t = t1 * B + t0
u = u1 * B + u0
```

Substituting into:

```text
n = t * B^2 + u * B + t
```

gives:

```text
n = t1 * B^3 + (t0 + u1) * B^2 + (u0 + t1) * B + t0
```

Because of carries, the correct system is:

```text
t0 = N0
u0 + t1 = N1 + c1 * B
t0 + u1 + c1 = N2 + c2 * B
t1 + c2 = N3
```

with tiny carries `c1` and `c2`.

So instead of solving some giant impossible problem, I only needed to brute-force a couple of small carry values and check which one made the algebra consistent.

* * *

## Recovering `L` and `R`

Once I recovered `t = L * R` and `u = L^2 + R^2`, the rest was straightforward.

I used:

```text
(L + R)^2 = L^2 + 2LR + R^2 = u + 2t
(L - R)^2 = L^2 - 2LR + R^2 = u - 2t
```

So I computed:

```text
A^2 = u + 2t = (L + R)^2
D^2 = u - 2t = (L - R)^2
```

Then:

```text
L = (A + D) / 2
R = (A - D) / 2
```

After that I rebuilt the factors:

```text
p = L * B + R
q = R * B + L
```

and verified:

```text
p * q == n
```

That was the full factorization.

* * *

## Decrypting the Ciphertext

With `p` and `q` known, standard RSA finished the challenge:

```text
phi = (p - 1)(q - 1)
d = e^{-1} mod phi
m = c^d mod n
```

Then I converted `m` back to bytes and got the flag.

* * *

## Solve Script

This is the script I used to solve it.

```python
from math import isqrt

n = 13184777495081008136378701349850014746828643066078107459934895054885104642211158887687363814851481880536739392765231880911914473779382677713817869943051361672810349968815079826008147134282184038528606008903819389465003037971715429698635686502083228479158527194657308756285498668205015510210856933773632225424038806710198000445915830912691957546385857601215816162731398099364433431385564877501465481250464329970426956154629887038690532877247607885092909054430992070325775056580096677878409305289037435079906658919023437746158537338999806571810766980982205678495423068406683
e = 65537
c = 2495775681430782992362729479625745975452355744176335567477436185288072507322197414455082980603105950811079969359022065544386855789086367219752934247461840328294670145676669898544198555268488325770400741479499745546596113268440443979671562814955995222612911610171957602085975945183334365734071644232961413114059132813194282507921431908516772243706734149144798491044997348454739610191338901834287944798241073116954989258720378999841400983436377762960200739531431493883077810036013077582843786006467028277252503510122737756053076230600350568886788079832668863643974698548661

B = 10**143

def long_to_bytes(x: int) -> bytes:
    if x == 0:
        return b"\x00"
    out = bytearray()
    while x:
        out.append(x & 0xff)
        x >>= 8
    return bytes(out[::-1])

# split n into base-B limbs
N0 = n % B
N1 = (n // B) % B
N2 = (n // B**2) % B
N3 = n // B**3

solution = None

for c1 in range(3):
    for c2 in range(4):
        t1 = N3 - c2
        if t1 < 0:
            continue

        t0 = N0
        u0 = N1 - t1 + c1 * B
        u1 = N2 - t0 - c1 + c2 * B

        if not (0 <= u0 < B and 0 <= u1 < B):
            continue

        t = t1 * B + t0
        u = u1 * B + u0

        # (L + R)^2 and (L - R)^2
        A2 = u + 2 * t
        D2 = u - 2 * t

        A = isqrt(A2)
        D = isqrt(D2)

        if A * A != A2:
            continue
        if D * D != D2:
            continue

        L = (A + D) // 2
        R = (A - D) // 2

        p = L * B + R
        q = R * B + L

        if p * q == n:
            solution = (L, R, p, q)
            break
    if solution:
        break

if solution is None:
    raise ValueError("failed to recover factors")

L, R, p, q = solution
phi = (p - 1) * (q - 1)
d = pow(e, -1, phi)
m = pow(c, d, n)
pt = long_to_bytes(m)

print(f"L = {L}")
print(f"R = {R}")
print(f"p = {p}")
print(f"q = {q}")
print(pt.decode())
```

* * *

## Sanity Checks

I always like having a few checks before calling it solved.

### 1. Factor check

This had to hold:

```python
assert p * q == n
```

### 2. Rotation check

The decimal halves had to match the challenge construction exactly:

```python
assert str(p) == str(L) + str(R)
assert str(q) == str(R) + str(L)
```

### 3. RSA check

After decrypting, the plaintext had to be readable and match the flag format:

```python
assert pt.startswith(b"upCTF{") and pt.endswith(b"}")
```

Once all three passed, the solve was solid.

* * *

## Final Flag

```text
upCTF{H0p3_y0u_d1dnt_us3_41_1_sw3ar_th1s_1s_n1ce...If you are CR7 and you solved this, I love you}
```

* * *

## Closing Thoughts

I liked this challenge a lot because it looked like normal RSA at first, but the decimal concatenation made the modulus highly structured.

The nice part was that I did not need any heavy number theory or lattice tricks. Once I modeled the concatenation in base `10^143`, the factorization reduced to a small carry search and two square roots.

So the whole challenge really came down to one idea:

if the primes are built from the same pieces in a predictable way, RSA stops being hard for the exact same reason it is usually hard.

This was a clean one.

