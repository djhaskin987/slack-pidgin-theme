import pathlib
import re

find_root = re.compile(r"\.svg$")
find_png = re.compile(r"\.png")
svg_path = pathlib.Path("svg")

pngs = {}
with open("theme", "r", encoding="utf-8", errors="ignore") as theme_file:
    for line in theme_file:
        if len(line) != 0 and find_png.search(line):
            fields = line.strip().split()
            pngs[fields[0]] = fields[1:]
new_lines = []
for svg in svg_path.iterdir():
    root = find_root.sub("", svg.name.lower())
    png = f"{root}.png"
    if png not in pngs:
        ordinals = [chr(int(x, 16)) for x in root.split("-")]
        unicode_string = "".join(ordinals)
        new_lines.append(f"{png}\t{unicode_string}")
with open("theme", "a", encoding="utf-8", errors="ignore") as theme_file:
    for new_line in new_lines:
        print(new_line, file=theme_file)