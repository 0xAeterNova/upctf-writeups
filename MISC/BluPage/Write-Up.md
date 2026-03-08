# BluPage

**Category:** Misc  
**Difficulty:** Easy  
**Challenge:** BluPage  
**Flag Format:** `upCTF{}`

## Description

> A big friend of mine tried to work as a front-end dev, shipped a “minimal” page and forgot that the web isn’t just what you see.

## TL;DR

This challenge was a small web-style misc puzzle, but the real solve path was hidden in the page source. The source prefetched a file called `artifacts.zip`, and the JavaScript hint said `LSB, 32bits.`. Inside the archive, one file was a deliberately broken PNG that revealed the first half of the flag after I fixed its header, and the other file hid the second half in the blue-channel LSBs of the first row.

The final flag was:

```text
upCTF{PNG_hdrs_4r3_sn34ky}
```

---

## Initial Recon

I started with the page source instead of staring at the UI too long.

```html
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>forwebdevs — tips, snippets, UI puzzles</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="prefetch" href="/assets/artifacts.zip" as="fetch" crossorigin>
<link rel="stylesheet" href="/static/style.css">
</head>
<body>
  <main class="card">
      <h1>BluPage</h1>
      <p>Practical tips, small snippets, and UI puzzles.</p>
      <a class="btn" href="#" aria-disabled="true">Soon</a>
      <hr class="hr">
      <p>Some things reveal themselves to those who look a little closer.</p>
    </main>
    <script src="/static/touch.js"></script>
</body>
</html>
```

The important part was this line:

```html
<link rel="prefetch" href="/assets/artifacts.zip" as="fetch" crossorigin>
```

That immediately told me the page was hiding an asset that was never linked in the visible UI.

Then I checked the JavaScript:

```js
console.log("Don't forget: LSB, 32bits.");
```

That was basically the challenge author telling me where to look next.

At that point the plan was clear:

1. download `artifacts.zip`
2. inspect its contents
3. recover anything broken or hidden
4. use the `LSB, 32bits` hint on the suspicious image

---

## Extracting the Hidden Files

I downloaded the hidden archive and listed it:

```bash
curl -sS -O http://46.225.117.62:30021/assets/artifacts.zip
sha256sum artifacts.zip
file artifacts.zip
7z l artifacts.zip
```

The archive contained:

```text
artifacts/
├── f_left.png
└── f_right.png
```

Then I extracted and fingerprinted both files:

```bash
mkdir -p out
7z x -y artifacts.zip -oout >/dev/null
find out -maxdepth 3 -type f -exec file {} \;
exiftool out/artifacts/*
```

What stood out immediately:

- `f_right.png` was a valid PNG
- `f_left.png` was **not** recognized as a valid PNG and threw a file format error

That was too suspicious to be accidental. It looked intentional.

---

## Fixing the Broken PNG Header

I checked the broken file header in hex and found that the PNG signature had been tampered with.

A valid PNG starts with:

```text
89 50 4E 47 0D 0A 1A 0A
```

But this file had:

```text
89 50 4E 58 ...
```

So the `G` in `PNG` had been replaced with `X`.

That meant the file was not corrupted in a deep way. It was just a one-byte sabotage job to stop normal tools from opening it.

I fixed it with a tiny Python snippet:

```python
from zipfile import ZipFile
from io import BytesIO
from PIL import Image

zf = ZipFile("artifacts.zip")
left = bytearray(zf.read("artifacts/f_left.png"))
left[3] = ord("G")
img = Image.open(BytesIO(left))
img.save("left_fixed.png")
```

After fixing the signature, the image opened normally and showed:

```text
upCTF{PNG_hdrs_
```

So that gave me the left half of the flag with no guessing involved.

---

## Extracting the Hidden Data from `f_right.png`

Now I moved to the second image.

The hint from `touch.js` was:

```js
Don't forget: LSB, 32bits.
```

Since `f_right.png` was an RGBA image, the `32bits` part fit perfectly. I expected the payload to be hidden in pixel least significant bits, probably with a 32-bit alignment trick.

I loaded the image as RGBA and inspected the LSBs. The interesting signal was in the **blue channel of the first row**.

The visible transition started slightly before the aligned boundary, but the `32bits` hint strongly suggested that I should decode from a 32-bit aligned offset instead of the very first changed pixel.

So I read the blue-channel LSBs from the first row starting at `x = 32`.

This gave me 88 bits of meaningful data.

I grouped those bits into 4-bit nibbles, converted them to hex, and then decoded the hex into ASCII.

The extraction produced:

```text
3472335f736e33346b797d
```

Hex-decoding that gave:

```text
4r3_sn34ky}
```

That was clearly the missing suffix of the flag.

---

## Reconstructing the Flag

Now I had both halves:

- from the repaired left image: `upCTF{PNG_hdrs_`
- from the LSB payload in the right image: `4r3_sn34ky}`

Putting them together gave:

```text
upCTF{PNG_hdrs_4r3_sn34ky}
```

---

## Full Solve Script

I used the following script to recover the flag end to end:

```python
from zipfile import ZipFile
from io import BytesIO
from PIL import Image

zf = ZipFile("artifacts.zip")

# Recover left half by fixing the PNG signature
left = bytearray(zf.read("artifacts/f_left.png"))
left[3] = ord("G")
img_left = Image.open(BytesIO(left))
img_left.save("left_fixed.png")

prefix = "upCTF{PNG_hdrs_"

# Recover right half from blue-channel LSBs
img_right = Image.open(BytesIO(zf.read("artifacts/f_right.png"))).convert("RGBA")

bits = ''.join(str(img_right.getpixel((x, 0))[2] & 1) for x in range(img_right.width))
msg_bits = bits[32:120]
hex_str = ''.join(f'{int(msg_bits[i:i+4], 2):x}' for i in range(0, len(msg_bits), 4))
suffix = bytes.fromhex(hex_str).decode()

flag = prefix + suffix
print(flag)
```

When I ran it, it printed:

```text
upCTF{PNG_hdrs_4r3_sn34ky}
```

---

## Why This Worked

I liked this challenge because it stayed simple but still forced me to pay attention to multiple layers:

- the visible page was just a distraction
- the source revealed a hidden downloadable artifact
- one image was intentionally broken in a very small but meaningful way
- the other image used a clean LSB trick with a 32-bit alignment hint

The nice part was that nothing here required blind brute force. Every step was hinted at:

- hidden asset in source
- `LSB, 32bits.` in JavaScript
- malformed PNG header in the left file
- valid RGBA image in the right file

Once I followed those clues in order, the flag came out cleanly.

---

## Verification

I submitted the recovered flag to the challenge and it was accepted:

```text
upCTF{PNG_hdrs_4r3_sn34ky}
```

So the solve path was fully confirmed.

---

## Flag

```text
upCTF{PNG_hdrs_4r3_sn34ky}
```

---

## Closing Note

I enjoyed this one because it used very small front-end details in a smart way. The challenge title and the minimal page made it look almost too simple, but the real trick was noticing that the browser source and hidden assets were part of the puzzle.

The broken PNG header was a nice touch, and the `LSB, 32bits` hint made the second half feel fair instead of random. Overall, this was a clean misc challenge that rewarded careful inspection more than overcomplicating things.

