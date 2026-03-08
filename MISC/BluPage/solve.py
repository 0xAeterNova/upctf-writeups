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
