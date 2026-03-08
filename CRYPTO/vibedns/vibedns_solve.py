#!/usr/bin/env python3
import argparse
import base64
import http.client
import random
import socket
import struct
import urllib.parse
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.asymmetric import ec
from cryptography.hazmat.primitives.asymmetric.utils import decode_dss_signature

P256_ORDER = 0xFFFFFFFF00000000FFFFFFFFFFFFFFFFBCE6FAADA7179E84F3B9CAC2FC632551
ZONE_NAME = "xstf.pt."
TARGET_NAME = "flag.xstf.pt."


def dns_name_to_wire(name: str) -> bytes:
    out = b""
    for label in name.rstrip(".").split("."):
        out += bytes([len(label)]) + label.lower().encode()
    return out + b"\x00"


def qname_wire(name: str) -> bytes:
    out = b""
    for label in name.rstrip(".").split("."):
        out += bytes([len(label)]) + label.encode()
    return out + b"\x00"


def parse_name(data: bytes, off: int):
    labels = []
    jumped = False
    ret_off = None
    while True:
        ln = data[off]
        if ln == 0:
            off += 1
            break
        if ln & 0xC0 == 0xC0:
            ptr = ((ln & 0x3F) << 8) | data[off + 1]
            if not jumped:
                ret_off = off + 2
                jumped = True
            off = ptr
            continue
        off += 1
        labels.append(data[off:off + ln].decode())
        off += ln
    return ".".join(labels) + ".", (ret_off if jumped else off)


def rtype_to_int(rtype: str) -> int:
    return {
        "A": 1,
        "NS": 2,
        "CNAME": 5,
        "SOA": 6,
        "MX": 15,
        "TXT": 16,
        "AAAA": 28,
        "RRSIG": 46,
        "DNSKEY": 48,
    }[rtype]


def rdata_to_wire(rtype: str, rdata: str) -> bytes:
    if rtype == "TXT":
        enc = rdata.encode()
        out = b""
        for i in range(0, len(enc), 255):
            chunk = enc[i:i + 255]
            out += bytes([len(chunk)]) + chunk
        return out
    if rtype == "A":
        return bytes(map(int, rdata.split(".")))
    if rtype == "NS":
        return dns_name_to_wire(rdata)
    if rtype == "MX":
        prio, host = rdata.split(None, 1)
        return struct.pack("!H", int(prio)) + dns_name_to_wire(host)
    if rtype == "SOA":
        parts = rdata.split()
        return (
            dns_name_to_wire(parts[0])
            + dns_name_to_wire(parts[1])
            + struct.pack("!IIIII", *map(int, parts[2:7]))
        )
    return rdata.encode()


def build_rrsig_header(rtype: str, ttl: int, inception: int, expiration: int, key_tag: int, signer_name: str) -> bytes:
    labels = len(signer_name.rstrip(".").split("."))
    return (
        struct.pack("!HBBI", rtype_to_int(rtype), 13, labels, ttl)
        + struct.pack("!I", expiration)
        + struct.pack("!I", inception)
        + struct.pack("!H", key_tag)
        + dns_name_to_wire(signer_name)
    )


def build_rrset_wire(name: str, rtype: str, ttl: int, rdata_list) -> bytes:
    wire = b""
    for rdata in sorted(rdata_list):
        rdata_wire = rdata_to_wire(rtype, rdata)
        wire += dns_name_to_wire(name)
        wire += struct.pack("!HHI", rtype_to_int(rtype), 1, ttl)
        wire += struct.pack("!H", len(rdata_wire))
        wire += rdata_wire
    return wire


def dns_tcp_query(host: str, port: int, name: str, qtype: int = 48) -> bytes:
    txid = 0x1337
    msg = struct.pack("!HHHHHH", txid, 0x0100, 1, 0, 0, 0)
    msg += qname_wire(name) + struct.pack("!HH", qtype, 1)
    with socket.create_connection((host, port), timeout=8) as s:
        s.sendall(struct.pack("!H", len(msg)) + msg)
        length = struct.unpack("!H", s.recv(2))[0]
        data = b""
        while len(data) < length:
            data += s.recv(length - len(data))
    return data


def parse_dnskey_response(resp: bytes):
    _, _, qdcount, ancount, _, _ = struct.unpack("!HHHHHH", resp[:12])
    off = 12
    for _ in range(qdcount):
        _, off = parse_name(resp, off)
        off += 4

    dnskey = None
    rrsig = None
    for _ in range(ancount):
        name, off = parse_name(resp, off)
        rtype, rclass, ttl, rdlen = struct.unpack("!HHIH", resp[off:off + 10])
        off += 10
        rdata = resp[off:off + rdlen]
        off += rdlen

        if rtype == 48:
            flags, protocol, algo = struct.unpack("!HBB", rdata[:4])
            dnskey = {
                "name": name,
                "ttl": ttl,
                "flags": flags,
                "protocol": protocol,
                "algorithm": algo,
                "public_rdata": rdata,
                "pub_raw": rdata[4:],
            }
        elif rtype == 46:
            type_cov, algo, labels, orig_ttl, expiration, inception, key_tag = struct.unpack("!HBBIIIH", rdata[:18])
            signer_name, sig_off = parse_name(rdata, 18)
            rrsig = {
                "name": name,
                "ttl": ttl,
                "type_covered": type_cov,
                "algorithm": algo,
                "labels": labels,
                "original_ttl": orig_ttl,
                "expiration": expiration,
                "inception": inception,
                "key_tag": key_tag,
                "signer_name": signer_name,
                "signature": rdata[sig_off:],
            }

    if dnskey is None or rrsig is None:
        raise RuntimeError("Failed to parse DNSKEY/RRSIG from DNS response")
    return dnskey, rrsig


def derive_private_key(inception_timestamp: int):
    rng = random.Random(inception_timestamp)
    key_bytes = bytes(rng.randint(0, 255) for _ in range(32))
    private_int = int.from_bytes(key_bytes, "big") % (P256_ORDER - 1) + 1
    return ec.derive_private_key(private_int, ec.SECP256R1(), default_backend())


def main():
    ap = argparse.ArgumentParser(description="Exploit vibedns")
    ap.add_argument("--host", default="46.225.117.62")
    ap.add_argument("--port", type=int, default=30023)
    ap.add_argument("--rdata", default="give_me_the_flag")
    ap.add_argument("--ttl", type=int, default=3600)
    ap.add_argument("--rtype", default="TXT")
    args = ap.parse_args()

    resp = dns_tcp_query(args.host, args.port, ZONE_NAME, 48)
    dnskey, rrsig = parse_dnskey_response(resp)

    print(f"[+] DNSKEY key_tag   = {rrsig['key_tag']}")
    print(f"[+] inception       = {rrsig['inception']}")
    print(f"[+] expiration      = {rrsig['expiration']}")

    private_key = derive_private_key(rrsig["inception"])
    pub = private_key.public_key().public_numbers()
    derived_pub_raw = pub.x.to_bytes(32, "big") + pub.y.to_bytes(32, "big")
    if derived_pub_raw != dnskey["pub_raw"]:
        raise RuntimeError("Derived private key does not match published DNSKEY")
    print("[+] Recovered signing key successfully")

    data = build_rrsig_header(args.rtype, args.ttl, rrsig["inception"], rrsig["expiration"], rrsig["key_tag"], ZONE_NAME)
    data += build_rrset_wire(TARGET_NAME, args.rtype, args.ttl, [args.rdata])

    der_sig = private_key.sign(data, ec.ECDSA(hashes.SHA256()))
    r, s = decode_dss_signature(der_sig)
    raw_sig = r.to_bytes(32, "big") + s.to_bytes(32, "big")
    sig_b64 = base64.b64encode(raw_sig).decode()

    body = urllib.parse.urlencode({
        "name": TARGET_NAME,
        "type": args.rtype,
        "ttl": str(args.ttl),
        "rdata": args.rdata,
        "sig": sig_b64,
    })

    conn = http.client.HTTPConnection(args.host, args.port, timeout=8)
    conn.request("POST", "/verify", body, {"Content-Type": "application/x-www-form-urlencoded"})
    res = conn.getresponse()
    response_body = res.read().decode()
    print(f"[+] HTTP {res.status}")
    print(response_body)
    conn.close()


if __name__ == "__main__":
    main()
