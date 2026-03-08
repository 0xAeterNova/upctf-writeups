# vibedns — Write-Up

Category: Crypto  
Difficulty: Easy  
Challenge: vibedns  
Flag Format: `upCTF{}`

## Description

> The shareholders said we were spending to much in DNSSEC providers and i should vibe code my own.

## Files

- `dnssec_signer.py`
- `dns_server.py`
- `vibedns_solve.py`

## TL;DR

This challenge was a bad DNSSEC implementation where the ECDSA signing key was generated from Python's `random` module, seeded only with the RRSIG inception timestamp.

That timestamp was not secret. It was published inside the DNSSEC metadata.

So I did not need to break ECDSA, brute-force anything large, or attack the verifier directly. I just asked the service for the signed `DNSKEY` record, extracted the `inception` field from the `RRSIG`, regenerated the exact same private key locally, forged a valid signature for `flag.xstf.pt.`, and submitted it to `/verify`.

The server accepted my forged RRSIG and returned the flag.

* * *

## Initial Analysis

I started by reading `dnssec_signer.py`.

The important part was the key generation function:

```python
P256_ORDER = int("FFFFFFFF00000000FFFFFFFFFFFFFFFFBCE6FAADA7179E84F3B9CAC2FC632551", 16)

def generate_zsk(inception_timestamp):
    random.seed(inception_timestamp)
    key_bytes = bytes([random.randint(0, 255) for _ in range(32)])
    private_int = int.from_bytes(key_bytes, "big") % (P256_ORDER - 1) + 1
    return ec.derive_private_key(private_int, ec.SECP256R1())
```

That is the bug.

The zone signing key was not generated from `os.urandom()` or any cryptographically secure source. It was generated from Python's Mersenne Twister, seeded with a single integer: the signature inception timestamp.

So the private key was completely deterministic.

If I could recover that timestamp, I could rebuild the exact same ECDSA private key.

Then I checked how the server was using it in `dns_server.py`.

The verifier endpoint did this:

- accepted a base64-encoded DNS message in JSON
- parsed it with `dnspython`
- extracted the answer section
- required exactly one `TXT` RRset and one `RRSIG(TXT)` RRset
- called `dns.dnssec.validate()` with the service's trusted key dictionary
- returned the flag if validation passed and the owner name was `flag.xstf.pt.`

So the challenge reduced to this:

1. Recover the DNSSEC signing key.
2. Sign any `TXT` record at `flag.xstf.pt.`.
3. Submit the signed answer to `/verify`.

There was no need to know the real TXT contents ahead of time. The verifier only cared that the signature was valid under the trusted key.

* * *

## Why the Key Recovery Works

The whole trick is that DNSSEC publishes enough metadata for validators to check signatures.

When I queried the zone's `DNSKEY`, the response included:

- the `DNSKEY` RRset itself
- an `RRSIG(DNSKEY)` covering that RRset

That `RRSIG` includes fields such as:

- algorithm
- key tag
- signer name
- inception
- expiration

The critical one was `inception`.

The server used that exact value as the seed here:

```python
random.seed(inception_timestamp)
```

So once I learned the published inception timestamp, I could replay the same generation process locally:

```python
rng = random.Random(inception)
key_bytes = bytes(rng.randint(0, 255) for _ in range(32))
private_int = int.from_bytes(key_bytes, "big") % (P256_ORDER - 1) + 1
```

That gave me the real private scalar.

At that point, I checked the derived public key against the `DNSKEY` record from the server. If they matched, the recovery was confirmed.

That check is important because it removes all guesswork.

* * *

## Exploitation Strategy

I used a very direct flow.

### Step 1: Query the signed DNSKEY RRset

I connected to the challenge over DNS-over-TCP and requested:

```text
xstf.pt. IN DNSKEY
```

From the answer section I extracted:

- the `DNSKEY` record
- the covering `RRSIG`
- `inception`
- `expiration`
- `key_tag`

From my solve run, the important values were:

```text
key_tag    = 4168
inception  = 1773006691
expiration = 1775598691
```

### Step 2: Rebuild the private key from the inception timestamp

I reproduced the buggy key generation exactly.

```python
import random
from cryptography.hazmat.primitives.asymmetric import ec

P256_ORDER = 0xFFFFFFFF00000000FFFFFFFFFFFFFFFFBCE6FAADA7179E84F3B9CAC2FC632551

rng = random.Random(1773006691)
key_bytes = bytes(rng.randint(0, 255) for _ in range(32))
private_int = int.from_bytes(key_bytes, "big") % (P256_ORDER - 1) + 1
priv = ec.derive_private_key(private_int, ec.SECP256R1())
```

Then I derived the public key and made sure it matched the published `DNSKEY`.

Once that matched, I knew I had the real signing key.

### Step 3: Forge a signed TXT record for `flag.xstf.pt.`

The verifier only required a valid `TXT` RRset at `flag.xstf.pt.` with a valid `RRSIG(TXT)`.

So I created a DNS response containing:

- `flag.xstf.pt. 3600 IN TXT "give flag"`
- a valid `RRSIG(TXT)` over that RRset using the recovered ECDSA key

I kept the metadata aligned with the zone:

- same algorithm
- same signer name
- same key tag
- sensible inception/expiration window

### Step 4: Submit the forged message to `/verify`

The service expected JSON like this:

```json
{"dns_message_b64": "..."}
```

So I encoded the crafted DNS message in base64 and sent it to:

```text
POST /verify
```

The server validated the signature successfully and returned the flag.

* * *

## Solver

This is the solver I used.

```python
#!/usr/bin/env python3
import argparse
import base64
import json
import random
import socket
import struct
import urllib.request

import dns.flags
import dns.message
import dns.name
import dns.rdata
import dns.rdataclass
import dns.rdatatype
import dns.rrset
from cryptography.hazmat.primitives.asymmetric import ec

P256_ORDER = 0xFFFFFFFF00000000FFFFFFFFFFFFFFFFBCE6FAADA7179E84F3B9CAC2FC632551


def recv_exact(sock, n):
    data = b''
    while len(data) < n:
        chunk = sock.recv(n - len(data))
        if not chunk:
            raise EOFError("socket closed")
        data += chunk
    return data


def dns_tcp_query(host, port, qname, rdtype):
    query = dns.message.make_query(qname, rdtype, want_dnssec=True)
    wire = query.to_wire()

    with socket.create_connection((host, port), timeout=10) as s:
        s.sendall(struct.pack("!H", len(wire)) + wire)
        resp_len = struct.unpack("!H", recv_exact(s, 2))[0]
        resp_wire = recv_exact(s, resp_len)

    return dns.message.from_wire(resp_wire)


def derive_private_key(inception_timestamp):
    rng = random.Random(inception_timestamp)
    key_bytes = bytes(rng.randint(0, 255) for _ in range(32))
    private_int = int.from_bytes(key_bytes, "big") % (P256_ORDER - 1) + 1
    return ec.derive_private_key(private_int, ec.SECP256R1())


def extract_dnskey_and_rrsig(msg):
    dnskey_rrset = None
    rrsig_rrset = None

    for rrset in msg.answer:
        if rrset.rdtype == dns.rdatatype.DNSKEY:
            dnskey_rrset = rrset
        elif rrset.rdtype == dns.rdatatype.RRSIG:
            for rdata in rrset:
                if rdata.type_covered == dns.rdatatype.DNSKEY:
                    rrsig_rrset = rrset
                    return dnskey_rrset, rdata

    raise RuntimeError("failed to find DNSKEY and covering RRSIG")


def build_txt_response(priv, qid, qname_text, signer_name, key_tag, inception, expiration):
    qname = dns.name.from_text(qname_text)
    signer = dns.name.from_text(signer_name)

    msg = dns.message.Message(id=qid)
    msg.flags |= dns.flags.QR | dns.flags.AA
    msg.question.append(dns.rrset.RRset(qname, dns.rdataclass.IN, dns.rdatatype.TXT))

    txt_rrset = dns.rrset.from_text(qname_text, 3600, "IN", "TXT", '"give flag"')
    msg.answer.append(txt_rrset)

    rrsig = dns.dnssec.sign(
        rrset=txt_rrset,
        private_key=priv,
        signer=signer,
        dnskey=None,
        inception=inception,
        expiration=expiration,
        lifetime=None,
        verify=False,
        policy=None,
        origin=None,
        deterministic=True,
    )

    patched = []
    for rd in rrsig:
        patched.append(dns.rdata.from_text(
            dns.rdataclass.IN,
            dns.rdatatype.RRSIG,
            f"TXT 13 3 3600 {expiration} {inception} {key_tag} {signer_name} {rd.signature.decode() if isinstance(rd.signature, bytes) else rd.signature}"
        ))

    sig_rrset = dns.rrset.RRset(qname, dns.rdataclass.IN, dns.rdatatype.RRSIG)
    for rd in patched:
        sig_rrset.add(rd)
    msg.answer.append(sig_rrset)

    return msg


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--host", default="46.225.117.62")
    ap.add_argument("--port", type=int, default=30023)
    args = ap.parse_args()

    resp = dns_tcp_query(args.host, args.port, "xstf.pt.", dns.rdatatype.DNSKEY)
    dnskey_rrset, dnskey_sig = extract_dnskey_and_rrsig(resp)

    inception = dnskey_sig.inception
    expiration = dnskey_sig.expiration
    key_tag = dnskey_sig.key_tag
    signer_name = dnskey_sig.signer.to_text()

    print(f"[+] DNSKEY key_tag   = {key_tag}")
    print(f"[+] inception       = {inception}")
    print(f"[+] expiration      = {expiration}")

    priv = derive_private_key(inception)
    print("[+] Recovered signing key successfully")

    forged = build_txt_response(
        priv=priv,
        qid=0x1337,
        qname_text="flag.xstf.pt.",
        signer_name=signer_name,
        key_tag=key_tag,
        inception=inception,
        expiration=expiration,
    )

    payload = json.dumps({
        "dns_message_b64": base64.b64encode(forged.to_wire()).decode()
    }).encode()

    req = urllib.request.Request(
        f"http://{args.host}:{args.port}/verify",
        data=payload,
        headers={"Content-Type": "application/json"},
        method="POST",
    )

    with urllib.request.urlopen(req, timeout=10) as r:
        body = r.read().decode()
        print(f"[+] HTTP {r.status}")
        print(body)


if __name__ == "__main__":
    main()
```

* * *

## Running the Exploit

I ran it like this:

```bash
python3 vibedns_solve.py --host 46.225.117.62 --port 30023
```

And got:

```text
[+] DNSKEY key_tag   = 4168
[+] inception       = 1773006691
[+] expiration      = 1775598691
[+] Recovered signing key successfully
[+] HTTP 200
{
  "status": "RRSIG_VERIFIED",
  "message": "Signature accepted. The resolver trusts your record.",
  "flag": "upCTF{ev3n_wh3n_1ts_crypto_1ts_alw4ys_Dn5_cc0AnCjYee8047fe}"
}
```

That was enough to confirm the exploit cleanly.

* * *

## Why This Broke

The challenge tried to mimic DNSSEC trust, but the actual signing key generation destroyed the whole security model.

ECDSA itself was not the weak point here.  
The weak point was the RNG.

More specifically:

- Python's `random` is not cryptographically secure.
- The seed came from public metadata.
- The metadata was literally shipped inside the signature.

So the private key was effectively public to anyone who understood how it was generated.

In other words, the challenge did not fail because DNSSEC is weak.  
It failed because the implementation turned the secret signing key into a reproducible function of public data.

* * *

## Flag

```text
upCTF{ev3n_wh3n_1ts_crypto_1ts_alw4ys_Dn5_cc0AnCjYee8047fe}
```

* * *

## Final Notes

I liked this challenge because it looked like a DNSSEC problem at first, but the real issue was much simpler: predictable key generation.

Once I saw `random.seed(inception_timestamp)`, the rest of the solve path was basically fixed.

Query the signed record, read the timestamp, replay the RNG, recover the key, forge the RRset, get the flag.
