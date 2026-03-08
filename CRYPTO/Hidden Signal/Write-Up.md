# Hidden Signal - Crypto Write-Up

## Challenge Information
- **Category:** Crypto
- **Difficulty:** Easy
- **Challenge Name:** Hidden Signal
- **Flag Format:** `upCTF{}`

## Challenge Description
> A leaked password database. The data looks random. It isn't. Find the signal.

---

## Files Provided

```text
passwords.txt
```

---

## TL;DR

This challenge was not about cracking passwords at all. The trick was that every line in `passwords.txt` hid a **25-character lowercase / digit / underscore token** inside a giant wall of uppercase noise.

Once I stripped the uppercase letters away from all **4000** lines, I got **4000 samples** of a 25-character hidden string. Then I counted character frequencies **column by column**. The most common character in each position stood out way above random chance, and the recovered message was:

```text
m4rk0v_w4s_h3r3_4ll_4l0ng
```

So the final flag was:

```text
upCTF{m4rk0v_w4s_h3r3_4ll_4l0ng}
```

---

## Initial Recon

I started by looking directly at the provided file.

```bash
ls -lah
file passwords.txt
head -n 3 passwords.txt
```

At first glance it looked useless. Each line was extremely long and mostly full of uppercase letters, so it really did look like random leaked-password garbage.

To avoid guessing, I inspected the structure directly.

```python
with open("passwords.txt", "r", encoding="utf-8") as f:
    lines = f.read().splitlines()

print("lines =", len(lines))
print("first line length =", len(lines[0]))
print(lines[0][:120])
```

What mattered immediately:

- the file had **4000 lines**
- each line was very long
- the visible noise was mostly **A-Z**
- but there were also occasional lowercase letters, digits, and underscores mixed in

That pattern did not look accidental.

---

## The First Real Signal

The fastest discriminator here was simple: keep only the characters that are **not uppercase**.

I tested that on all rows.

```python
tokens = ["".join(c for c in line if not c.isupper()) for line in lines]
print(set(map(len, tokens)))
print(tokens[:5])
```

That gave me two very important results:

1. every extracted token had length **25**
2. every token only used characters from:

```text
[a-z0-9_]
```

A few examples looked like this:

```text
6dky0pzw_n7m38syf0z5n_rny
m53y90mq4c_7cro_ngvgxpckm
ojtbn1ewq15mx7932lqqitpv1
```

At that point the challenge stopped looking like password recovery and started looking like a **hidden statistical channel**.

---

## Why Frequency Analysis Fits

If those 25-character tokens were truly random over the alphabet `[a-z0-9_]`, then for any fixed position I would expect the character distribution to be close to uniform.

The alphabet size is:

```text
26 lowercase + 10 digits + 1 underscore = 37
```

With **4000 samples**, the expected count for any one character in any one column is roughly:

```text
4000 / 37 ≈ 108.1
```

So if one character in a column is showing up **far** more often than that, then that is the hidden signal.

---

## Recovering the Message

I counted character frequencies for each of the 25 positions independently.

```python
from collections import Counter

for i in range(25):
    ctr = Counter(t[i] for t in tokens)
    print(i, ctr.most_common(3))
```

The winners were not subtle at all. For example, the first few columns looked like this:

```text
col 00: [('m', 562), ('b', 116), ('a', 113)]
col 01: [('4', 569), ('z', 115), ('c', 113)]
col 02: [('r', 550), ('h', 121), ('5', 120)]
col 03: [('k', 524), ('4', 120), ('7', 118)]
col 04: [('0', 539), ('u', 120), ('9', 116)]
```

Those counts are nowhere near random noise. The dominant character in each column was massively above the expected baseline.

Taking the most common character from each position reconstructed:

```text
m4rk0v_w4s_h3r3_4ll_4l0ng
```

That was already a clean and meaningful result, and it matched the challenge theme perfectly.

---

## Sanity Check

I also checked how strong the bias was numerically.

For a uniform model over 37 symbols with 4000 samples, the expected count per symbol per column is about **108.1**. The dominant winners I observed ranged from **443** to **594** occurrences.

That is way too large to explain as chance. So this was not me overfitting random data. The message was really embedded across the dataset.

---

## Full Solve Script

This is the script I used to recover the hidden phrase automatically.

```python
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
```

---

## Running the Solve

I ran:

```bash
python3 solve.py
```

And got the reconstructed hidden message:

```text
m4rk0v_w4s_h3r3_4ll_4l0ng
```

So the final flag became:

```text
upCTF{m4rk0v_w4s_h3r3_4ll_4l0ng}
```

---

## Why This Worked

The nice part of this challenge is that the hidden data was not stored in one obvious place. It was spread statistically across the entire dataset.

Each line looked random on its own, which is why the file initially felt like noise. But once I noticed that every line contained a fixed-length non-uppercase fragment, the whole thing turned into a column-wise frequency recovery problem.

So the real solve idea was:

- ignore the uppercase filler
- extract the hidden 25-character token from every row
- treat the database as many samples from the same hidden channel
- recover the dominant character in each position

That was enough to reconstruct the phrase cleanly.

---

## Final Flag

```text
upCTF{m4rk0v_w4s_h3r3_4ll_4l0ng}
```

---

## Closing Thoughts

I liked this one because it was simple once I looked at the structure instead of the story. The “leaked password database” framing tried to push me toward cracking or decoding individual entries, but the real trick was to step back and treat the whole file as one noisy signal.

It was a clean reminder that in crypto and stego-style CTF challenges, “random-looking” data is often only random until I ask the right aggregate question.
