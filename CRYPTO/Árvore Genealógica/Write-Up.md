# Árvore Genealógica — Write-Up

Category: Crypto  
Challenge: Árvore Genealógica  
Flag Format: `upCTF{}`

## Description

> Só primos atrás de primos atrás da fortuna do papi cris. In Portuguese it will make sense I swear.

## TL;DR

This challenge was an RSA break with a very loud hint hidden in the family tree page. The modulus was not generated from random unknown primes. Instead, one of the prime factors was chosen very close to `2**777`, and another hint told me that “até 100000 era perto”, which basically turned the factorization into a bounded search problem.

So instead of trying generic factorization, I searched for a prime divisor of `n` in the interval around `2**777 ± 100000`. Once I found that factor, the rest was standard RSA: compute `q`, recover `phi(n)`, invert `e`, decrypt `c`, and get the secret bank code.

The decrypted plaintext was:

```text
S3cr3t_to_p4pis_f0rtune
```

I then used that code on the bank page, which revealed the flag.

* * *

## Initial Analysis

The challenge gave me a fake family tree page with bits of information hidden inside the relatives' descriptions. The relevant data was attached to the root node, which exposed the RSA parameters:

```python
n = 625884537996922021301000341433932506927375585765524880339408244299388166616607970182814658884261038589890375258726352401200713142307149681483775252604692104227832166709807990289415964013032746766172102239270024433627974944278194240214614719847340322457045111198478821355004842741718270057503827331434371408025925605481105486995996528014519769908400670772699182920499677705809631318990058839592839709710458652675562071292900519774414030358230173117805552929123198203307

e = 0x10001

c = 62318722105864475633070267247974102130492586860223395750014121141640728228140922787683482348993303220123956188779410980859089837155685153563184703318488138798553149093011757720494639060509132811288893681789241883011105101728028235229519920858485960028687937326165670672221777501503866767604530227335608355547324683970157050707878702259507869498079204990540446272961682199498306150812336216294150630212362402674654569608827746982122255526272178602585754110118148113502
```

At first glance this looked like regular RSA, so the real question was: what exactly was weak about the key generation?

The strongest hints were hidden in two other family members:

- **Prima Sofia**: `O papi Cris dizia que até 100000 era perto e que basta 'descobrir um que o outro é óbvio'`
- **Primo Ricardo**: `Se pudesse escolher um número da sorte seria 777 então tenta prcurar um valor perto de 2**777`

That was enough to stop thinking about generic attacks and focus on the intended one.

* * *

## Reading the Hints Correctly

The wording was doing most of the work here.

`perto de 2**777` told me that one of the prime factors should be close to `2**777`.

`até 100000 era perto` suggested the search window.

So the intended weakness was not a small exponent issue, not textbook RSA, and not Wiener. It was simply that one prime factor had been generated from a tiny and predictable neighborhood around a public value.

That means I could just do this:

1. Set `center = 2**777`
2. Search all integers in `[center - 100000, center + 100000]`
3. Keep only primes
4. Test whether any of them divide `n`

If one worked, I had the factorization.

* * *

## Recovering the Factors

I searched the hinted interval and found a prime factor `p` such that `n % p == 0`.

```text
p = 794889263257962974796277498092801308291525640763748664903194643469338087775424965801409745320266996710649718116931109481559848982586784968419475084821084743272680947722675151641735826243378403750534655587182832000457137589153821536433
```

Then I computed:

```text
q = n // p
```

which gave:

```text
q = 787385824575926661725426270529827683535725643049946719804107953919786994989210642176713726655910594613464526403946857774409514647342708306916097497816526464349202205913693693351250266844252141149205004008266000953588760574091512234779
```

At that point I had the full private key material.

* * *

## Breaking the RSA

Once the factorization was done, the rest was completely standard.

I computed Euler's totient:

```python
phi = (p - 1) * (q - 1)
```

Then I recovered the private exponent:

```python
d = pow(e, -1, phi)
```

And finally decrypted the ciphertext:

```python
m = pow(c, d, n)
```

Converting `m` back to bytes gave me:

```text
S3cr3t_to_p4pis_f0rtune
```

That plaintext did not look like the final flag, but it looked exactly like a bank password, which matched the button on the challenge page.

* * *

## Final Step

The site had a pink button that led to the bank page.

I entered the decrypted code:

```text
S3cr3t_to_p4pis_f0rtune
```

That opened the dashboard and revealed the flag directly.

* * *

## Solve Script

```python
from sympy import isprime
from Crypto.Util.number import long_to_bytes

n = 625884537996922021301000341433932506927375585765524880339408244299388166616607970182814658884261038589890375258726352401200713142307149681483775252604692104227832166709807990289415964013032746766172102239270024433627974944278194240214614719847340322457045111198478821355004842741718270057503827331434371408025925605481105486995996528014519769908400670772699182920499677705809631318990058839592839709710458652675562071292900519774414030358230173117805552929123198203307

e = 65537

c = 62318722105864475633070267247974102130492586860223395750014121141640728228140922787683482348993303220123956188779410980859089837155685153563184703318488138798553149093011757720494639060509132811288893681789241883011105101728028235229519920858485960028687937326165670672221777501503866767604530227335608355547324683970157050707878702259507869498079204990540446272961682199498306150812336216294150630212362402674654569608827746982122255526272178602585754110118148113502

center = 2**777
window = 100000

p = None
for x in range(center - window, center + window + 1):
    if isprime(x) and n % x == 0:
        p = x
        break

if p is None:
    raise SystemExit("failed to find factor in hinted range")

q = n // p
phi = (p - 1) * (q - 1)
d = pow(e, -1, phi)
m = pow(c, d, n)
pt = long_to_bytes(m)

print(f"p = {p}")
print(f"q = {q}")
print(pt.decode())
```

Running it prints:

```text
S3cr3t_to_p4pis_f0rtune
```

* * *

## Why This Worked

RSA is only hard to break when factoring `n = p * q` is hard.

Here, the challenge basically leaked where one of the primes lived. Once I knew that one factor was extremely close to `2**777`, I no longer needed a general-purpose factoring algorithm. A bounded prime search was enough.

So the real vulnerability was predictable prime generation.

* * *

## Flag

```text
upCTF{0_m33s1_é_p3qu3n1n0-RkwBA6hw87dbf040}
```

## Final Notes

I liked this one because the crypto itself was simple, but the hints were wrapped in the family tree theme well enough that it was easy to overthink it at first. I initially considered whether it was trying to hint at something like close-prime factorization or even multi-prime RSA because of the “primos atrás de primos” joke, but the `2**777` clue was the one that actually mattered.

Once I stopped fighting the hint and just searched the window, the whole challenge collapsed immediately.

