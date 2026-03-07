# xSTF's Decryption Capsule — Write-Up

**Category:** Crypto  
**Difficulty:** Easy  
**Challenge:** xSTF's Decryption Capsule  
**Flag Format:** `upCTF{}`

## Description

> What is the capsule telling you?

## Files

- `chall.py`

## TL;DR

This challenge was a classic **AES-CBC padding oracle**. The service let me submit a hex-encoded blob, used the first 16 bytes as the IV, decrypted the rest with AES-CBC, and then called `unpad()` on the plaintext. The important part was that it printed the padding error back to me instead of treating every failure the same.

That gave me an oracle.

From there, I did not need the AES key at all. I recovered the intermediate value `D(C)` for chosen ciphertext blocks one byte at a time, then forged a valid `IV || C1 || C2 || C3` so that the decrypted plaintext became exactly:

```text
xSTF is the best portuguese CTF team :P
```

Once that string matched, the service printed the flag.

---

## Initial Analysis

I started by reading `chall.py`.

```python
from Crypto.Cipher import AES
from Crypto.Util.Padding import unpad
import os
import signal

signal.signal(signal.SIGPIPE, signal.SIG_DFL)

KEY = os.urandom(16)


def print_banner():
    print("="*50)
    print("       Welcome to xSTF's decryption capsule!         ")
    print("="*50)
    print("Awaiting hex-encoded transmission...")


def main():
    print_banner()

    while True:
        try:
            line = input("\n>")
            if not line:
                break

            raw_data = line.strip()
            if raw_data.startswith("0x"):
                raw_data = raw_data[2:]

            data = bytes.fromhex(raw_data)
            if len(data) < 32:
                print("Incomplete Block")
                continue

            iv = data[:16]
            ciphertext = data[16:]

            cipher = AES.new(KEY, AES.MODE_CBC, iv=iv)
            decrypted = cipher.decrypt(ciphertext)

            try:
                plaintext = unpad(decrypted, AES.block_size).decode('latin1')
            except Exception as e:
                print(str(e))
                continue

            if plaintext == "xSTF is the best portuguese CTF team :P":
                print("Yeah it is!")
                print(open("/flag.txt", "r").read())
                return
            else:
                print("you ain't got lil bro")

        except Exception as e:
            print(str(e))
```

There were three things that mattered immediately:

1. The service used **AES-CBC**.
2. I fully controlled the **IV** and the **ciphertext**.
3. On invalid PKCS#7 padding, it printed the exception text directly.

That third point is the bug. A padding oracle is enough to decrypt CBC blocks without knowing the key.

---

## Why the Oracle Works

For CBC mode, decryption of a block works like this:

```text
P_i = D_K(C_i) xor C_{i-1}
```

For the first block:

```text
P_1 = D_K(C_1) xor IV
```

If I send some chosen block `C` and keep changing the previous block, I can force the decrypted plaintext to end with valid PKCS#7 padding. Whenever the server accepts the padding, that leaks one byte of the intermediate state:

```text
I = D_K(C)
```

Once I know `I`, I can make the plaintext decrypt to anything I want:

```text
Prev = I xor TargetPlaintextBlock
```

So this challenge was not about recovering the AES key. It was about recovering the intermediate values for chosen blocks and then forging a ciphertext that decrypts to the exact target sentence.

---

## Splitting the Target Plaintext

The service wanted this exact string:

```text
xSTF is the best portuguese CTF team :P
```

Its length is 39 bytes, so after PKCS#7 padding it becomes 48 bytes total, which is exactly 3 blocks.

I split it like this:

```text
Block 1: xSTF is the best
Block 2:  portuguese CTF 
Block 3: team :P + 09 * 9
```

In hex:

```text
T1 = 78535446206973207468652062657374
T2 = 20706f72747567756573652043544620
T3 = 7465616d203a50090909090909090909
```

---

## Exploitation Strategy

I built the final ciphertext **backwards**.

### Step 1: Pick a random last block

I chose a random `C3`.

Then I used the padding oracle to recover:

```text
I3 = D_K(C3)
```

Once I had `I3`, I set:

```text
C2 = I3 xor T3
```

That guarantees block 3 decrypts to `T3`.

### Step 2: Recover the intermediate value for `C2`

Now I treated `C2` as the chosen ciphertext block and recovered:

```text
I2 = D_K(C2)
```

Then I set:

```text
C1 = I2 xor T2
```

That guarantees block 2 decrypts to `T2`.

### Step 3: Recover the intermediate value for `C1`

Finally, I recovered:

```text
I1 = D_K(C1)
```

Then I built the IV as:

```text
IV = I1 xor T1
```

That guarantees block 1 decrypts to `T1`.

At that point, the final forged payload was:

```text
IV || C1 || C2 || C3
```

When the service decrypted it, the plaintext became exactly the target string, so it printed the flag.

---

## Recovering One Block with the Oracle

The byte-at-a-time part follows the standard CBC padding oracle approach.

For a chosen ciphertext block `C`, I submit:

```text
Prefix || C
```

where `Prefix` is a fake previous block that I control.

I recover bytes from the end toward the beginning.

If I want the plaintext suffix to become valid padding of value `pad`, then for already solved bytes I set:

```text
Prefix[j] = I[j] xor pad
```

For the current unknown byte position `pos`, I brute-force `Prefix[pos]` from `0x00` to `0xff` until the service accepts the padding. Once that happens:

```text
I[pos] = Prefix[pos] xor pad
```

Then I move one byte left and repeat until I recover the full 16-byte intermediate block.

I also used the usual extra check on the last byte to avoid false positives.

---

## Solver

This is the solver I used:

```python
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
```

---

## Running the Exploit

I used:

```bash
HOST=46.225.117.62 PORT=30003 python3 solve.py
```

And the solver recovered the intermediate bytes for all three blocks, forged the final payload, and sent it back to the server.

The final forged payload in my solve was:

```text
86708dfa362331775a70ec7cc1d6bd4389773c7252d8a07a270279b2df3cc18dfa580e8443b56716c47b856903fa220275cfa30f366a82e254e88e6160ac38df
```

Server response:

```text
Yeah it is!
upCTF{p4dd1ng_0r4cl3_s4ys_xSTF_1s_num3r0_un0-B0vhI7isad47cea6}
```

---

## Why This Works Reliably

The nice thing about this challenge is that the oracle is very clean.

I did not need:

- the AES key,
- any brute-force over the key space,
- any weakness in AES itself,
- or any special property of the plaintext.

I only needed the service to reveal whether the decrypted plaintext had valid PKCS#7 padding.

Once that happened, CBC became malleable enough to fully forge the target message.

---

## Takeaway

This was a really clean example of why padding errors must never be distinguishable.

AES-CBC itself was not broken here. The implementation was.

The server gave me exactly the one bit of information I needed over and over again: whether the padding was valid. That was enough to recover intermediate states, build a valid ciphertext backwards, and make the service decrypt my payload into the success string.

---

## Flag

```text
upCTF{p4dd1ng_0r4cl3_s4ys_xSTF_1s_num3r0_un0-B0vhI7isad47cea6}
```
