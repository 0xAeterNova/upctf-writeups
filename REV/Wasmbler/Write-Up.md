# Wasmbler - Reverse Engineering Write-Up

**Category:** Reverse Engineering  
**Difficulty:** Medium  
**Challenge:** Wasmbler  
**Files:** `challenge.js`, `challenge.wasm`

---

## TL;DR

The web page itself was mostly noise. The only thing that mattered was that it called:

```js
Module.ccall('check_flag', 'number', ['string'], [v])
```

That immediately told me the real logic lived inside the exported wasm function `check_flag`, not in the HTML or the surrounding JavaScript.

After pulling `challenge.wasm`, I reversed `check_flag` and found that it only accepted strings of length **38**, then ran a small **stack-based VM** over the input. The bytecode program was **387 bytes** long, and the opcode table was shuffled after every instruction with a deterministic PRNG seeded from `0x1337beef`.

The important part was modeling the VM state correctly. The checker copied a **68-byte init block** into memory before execution, and that block pre-seeded the opcode table, RNG seed, stack pointer, and program counter. Once I accounted for that, the final VM result collapsed into a conjunction of byte-equality constraints that reconstructed the flag cleanly.

The flag is:

> **upCTF{n3rd_squ4d_4ss3mbl3_c0de_7f2b1d}**

---

## Environment / Tools

Static analysis was enough for this one.

- **Browser / DevTools** to inspect the page and see how the checker was called
- **Python 3** to parse the wasm, emulate the VM, and verify candidates
- Optional local helpers such as **`file`**, **`md5sum`**, **`sha256sum`**, and wasm tooling like **`wasm2wat`**

---

## Artifact Fingerprint

### Step 1 — Ignore the frontend and identify the real target

The page source made the split very obvious:

- the HTML only rendered an input box and a button
- `challenge.js` was a standard Emscripten runtime wrapper
- the only meaningful call was:

```js
const ok = Module.ccall('check_flag', 'number', ['string'], [v]);
```

That meant I did not need to spend time reversing UI code. The real target was just `challenge.wasm`.

---

### File identification

```bash
file challenge.wasm
# WebAssembly (wasm) binary module version 0x1 (MVP)
```

This confirmed it was a normal standalone WebAssembly module and not some packed archive or multi-stage loader.

---

### Hashes (reproducibility)

```text
MD5:    e8a19512ea56e2588ea9717291ccb195
SHA256: 81984e39cc2b5d6d18d351b4ad50cd010c0b8fbd5b6708d11cee2046aad47799
```

Keeping the hashes in the write-up made it easier to verify I was reversing the exact same artifact later.

---

## Solution Steps (single consolidated section)

### Step 2 — Pull the wasm and focus on `check_flag`

I grabbed the wasm directly from the challenge instance:

```bash
python3 - <<'PY'
import requests
url = 'http://46.225.117.62:30016/challenge.wasm'
r = requests.get(url, timeout=20)
print('status:', r.status_code, 'bytes:', len(r.content))
open('challenge.wasm', 'wb').write(r.content)
print('saved: challenge.wasm')
PY
```

The module was tiny, so I treated it like a small crackme instead of something that needed dynamic instrumentation first.

Inside the wasm, the only function that mattered was the exported checker:

- it called `strlen(input)`
- rejected anything whose length was not **38**
- copied a fixed init block into VM state memory
- ran a bytecode interpreter
- popped one final value and returned it as the success result

So the whole challenge reduced to understanding that VM.

---

### Step 3 — Recover the VM layout and init state

Once I mapped the helper functions used by `check_flag`, the overall design became clear.

The checker initialized a small VM state area that contained:

- an opcode table
- a PRNG seed
- a stack pointer
- a program counter
- the input pointer
- a byte stack

The critical detail was the copied **68-byte init block**. That block seeded the interpreter with:

```text
opcode table = [1, 2, 3, ..., 13]
seed         = 0x1337beef
stack ptr    = 19
pc           = 0
```

That stack pointer value mattered a lot. My first rough pass under-modeled the initial stack state, and that gave me the wrong conclusion. After I mirrored the copied state exactly, the VM started behaving consistently.

---

### Step 4 — Recover the instruction set

The VM was stack-based and used a shuffled dispatch table. I recovered the instruction handlers and labeled them as:

- `IMM`
- `INP`
- `ADD`
- `SUB`
- `XOR`
- `OR`
- `AND`
- `SHL`
- `SHR`
- `ROL`
- `ROR`
- `MOD`
- `EQ`

The bytecode itself was **387 bytes** long.

A nice anti-static trick here was that the checker did **not** use a fixed opcode mapping for the entire program. After every instruction, it shuffled the opcode table again using a deterministic PRNG and a Fisher–Yates-style swap routine.

So a program byte did not directly mean “run XOR” or “run ADD” forever. Its meaning depended on the current state of the shuffled table at that exact step.

That sounds annoying at first, but because the shuffle was deterministic, I could still emulate it exactly.

---

### Step 5 — Symbolically flatten the final check

Instead of trying random inputs against the service, I reimplemented the VM in Python and tracked how each operation transformed symbolic input bytes.

With the correct init block in place, the last popped VM value simplified into a large AND-chain of equality checks. In other words, the checker was effectively enforcing a set of per-byte constraints on the 38-character flag.

The fixed format already gave me:

```text
x0..x5  = upCTF{
x37     = }
```

Then the VM constraints pinned the remaining body bytes. A few of the direct solved bytes were:

```text
x9  = 'd'
x12 = 'q'
x13 = 'u'
x15 = 'd'
x21 = 'm'
x27 = '0'
x31 = '7'
x34 = 'b'
x35 = '1'
```

Solving the rest of the printable ASCII constraints reconstructed the inner payload as:

```text
n3rd_squ4d_4ss3mbl3_c0de_7f2b1d
```

Which gave the full flag:

> **upCTF{n3rd_squ4d_4ss3mbl3_c0de_7f2b1d}**

---

### Step 6 — Verify against the real wasm export

I did not want to stop at “looks correct”, so I verified it directly against the uploaded `challenge.wasm` by instantiating the module locally and calling `check_flag` on a fresh instance.

```js
const fs = require('fs');
const bytes = fs.readFileSync('challenge.wasm');

(async () => {
  const { instance } = await WebAssembly.instantiate(bytes, {
    env: {},
    wasi_snapshot_preview1: {}
  });

  const e = instance.exports;
  e.emscripten_stack_init();
  if (e.__wasm_call_ctors) e.__wasm_call_ctors();

  const s = 'upCTF{n3rd_squ4d_4ss3mbl3_c0de_7f2b1d}';
  const mem = new Uint8Array(e.memory.buffer);
  const ptr = 70000;

  mem.fill(0, ptr - 100, ptr + 300);
  for (let i = 0; i < s.length; i++) mem[ptr + i] = s.charCodeAt(i);
  mem[ptr + s.length] = 0;

  console.log('len =', s.length);
  console.log('check_flag =', e.check_flag(ptr));
})();
```

Expected result:

```text
len = 38
check_flag = 1
```

That matched the service-side validation, so the solve was fully confirmed.

---

## Final Answer

> **upCTF{n3rd_squ4d_4ss3mbl3_c0de_7f2b1d}**

---

## Notes / Takeaways

- When a web challenge ships an Emscripten wrapper, I always check whether the frontend is just a thin shell around an exported wasm function. Here, that was exactly the case.
- The shuffled opcode table looked intimidating at first, but once I recovered the deterministic PRNG and mirrored the state exactly, it turned back into a normal VM reversing problem.
- The copied init block mattered more than it first looked. Missing the pre-seeded stack state was enough to send the analysis in the wrong direction.
- For small wasm crackmes, it is often faster to treat them like tiny native crackmes: identify the real checker, recover the interpreter semantics, and solve the constraints offline instead of poking the remote blindly.
