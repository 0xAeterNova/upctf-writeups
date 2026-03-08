# Deoxyribonucleic acid - Write-Up

## Challenge Information
- **Category:** Misc
- **Difficulty:** Easy
- **Challenge Name:** Deoxyribonucleic acid
- **Flag Format:** `upCTF{}`

## Challenge Description
> Returning to fundamental silliness, Goldman et al. (2013)

The challenge only gave me a single file called `sample.txt`. At first glance it looked like a random DNA sequence, but the description was the real hint. The reference to **Goldman et al. (2013)** immediately pointed to DNA data storage.

That meant I was probably not dealing with anything biological in the usual sense. I was dealing with an encoding scheme that represents digital data as a sequence of nucleotides.

---

## Files Provided

```text
sample.txt
```

Inside the file, there were two important parts:

1. A long sequence over the alphabet `{A, C, G, T}`
2. A 4×3 transition table

The file looked like this:

```text
ACTCTACGAGTCTACAGAGTCGTCGTATCAGTCTCACGTGAGCGAGTATACAGTGTCGAGCGTGCGACTCGCTACAGAGTCGCTGTAGCACGAGTCTAGTGTGTCGATCGAGTGTAGTCTGTCGTCGTCGCTGTAGCACGAGTATAGTCTGTCGTAGTAGCAGTATGATAGAGCA

#           | 0 | 1 | 2
#  ---------|---|---|---
#     A     | C | G | T
#     C     | G | T | A
#     G     | T | A | C
#     T     | A | C | G
```

---

## Initial Recon

I started by looking at the structure instead of throwing random decoders at it.

A normal substitution cipher would map one nucleotide directly to one symbol, but that is not what this table was doing. The rows were based on the **previous nucleotide**, and each row had three possible outputs labeled `0`, `1`, and `2`.

That made the encoding stateful.

So the natural interpretation was:
- the hidden data was first represented in **trits** (`0`, `1`, `2`)
- each trit was converted into the **next nucleotide** depending on the current nucleotide
- the DNA string was therefore just a disguised ternary stream

That matched Goldman-style DNA encoding almost perfectly.

---

## Understanding the Encoding

The given transition table means:

- from `A`: `0 → C`, `1 → G`, `2 → T`
- from `C`: `0 → G`, `1 → T`, `2 → A`
- from `G`: `0 → T`, `1 → A`, `2 → C`
- from `T`: `0 → A`, `1 → C`, `2 → G`

So if I know two adjacent nucleotides, I can reverse the process and recover which trit produced that transition.

For example:
- `A → C` means trit `0`
- `C → T` means trit `1`
- `T → A` means trit `0`

So the solve path became very simple:

1. take every adjacent pair in the DNA sequence
2. invert the transition table
3. recover the ternary stream
4. group the trits correctly
5. convert them into text

---

## Recovering the Trit Stream

I inverted the table so I could decode each transition `(prev, next)` back into a trit.

For the first few pairs:

- `A → C = 0`
- `C → T = 1`
- `T → C = 1`
- `C → T = 1`
- `T → A = 0`
- `A → C = 0`

That gives the first chunk:

```text
011100
```

If I read that as a base-3 number:

```text
0·3^5 + 1·3^4 + 1·3^3 + 1·3^2 + 0·3 + 0 = 117
```

ASCII `117` is:

```text
u
```

That was the first strong confirmation that I was on the right path.

The next few 6-trit chunks gave:

- `011100` → `117` → `u`
- `011011` → `112` → `p`
- `002111` → `67` → `C`
- `010010` → `84` → `T`
- `002121` → `70` → `F`
- `011120` → `123` → `{`

So very early in the decode I already got:

```text
upCTF{
```

At that point the grouping was clearly correct.

---

## Full Decode

After continuing the exact same process over the entire sequence, the recovered plaintext was:

```text
upCTF{DnA_IsCh3pear_Th3n_R4M}
```

That matched the required format exactly and was fully derived from the provided file.

---

## Solve Script

I used the following script to decode the file automatically:

```python
dna = "ACTCTACGAGTCTACAGAGTCGTCGTATCAGTCTCACGTGAGCGAGTATACAGTGTCGAGCGTGCGACTCGCTACAGAGTCGCTGTAGCACGAGTCTAGTGTGTCGATCGAGTGTAGTCTGTCGTCGTCGCTGTAGCACGAGTATAGTCTGTCGTAGTAGCAGTATGATAGAGCA"

table = {
    'A': {0: 'C', 1: 'G', 2: 'T'},
    'C': {0: 'G', 1: 'T', 2: 'A'},
    'G': {0: 'T', 1: 'A', 2: 'C'},
    'T': {0: 'A', 1: 'C', 2: 'G'},
}

# invert (prev, cur) -> trit
inv = {}
for prev, row in table.items():
    for trit, cur in row.items():
        inv[(prev, cur)] = trit

# decode transitions into trits
trits = [inv[(dna[i], dna[i + 1])] for i in range(len(dna) - 1)]

# group into 6-trit base3 values and convert to ASCII
out = []
for i in range(0, len(trits), 6):
    chunk = trits[i:i + 6]
    if len(chunk) < 6:
        break

    value = 0
    for t in chunk:
        value = value * 3 + t

    out.append(chr(value))

print(''.join(out))
```

Running it prints:

```text
upCTF{DnA_IsCh3pear_Th3n_R4M}
```

---

## Why This Worked

The key observation was that the challenge did not just give me a DNA string. It also gave me the exact transition rule needed to reverse it.

The description was the final hint, because Goldman et al. is strongly associated with storing digital data in DNA using a ternary representation mapped into nucleotides while avoiding problematic repetitions.

So the challenge was basically:
- DNA transitions → trits
- trits → base-3 integers
- base-3 integers → ASCII

Once I recognized that, the rest was just careful decoding.

---

## Final Flag

```text
upCTF{DnA_IsCh3pear_Th3n_R4M}
```

---

## Closing Thoughts

I liked this one because it looked silly on the surface, but it was actually very clean. The description was short, the file was tiny, and the whole solve depended on recognizing the reference and reading the transition table correctly.

The nicest part was that there was no brute force involved. Once I interpreted the mapping the right way, the flag fell out directly and even validated itself early with the `upCTF{` prefix.

