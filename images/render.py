"""Render a one-page PDF to PNG (given width in px) and SVG next to this script."""
import sys
from pathlib import Path

import pymupdf

pdf, width = Path(sys.argv[1]), int(sys.argv[2])
out = Path(__file__).resolve().parent / "yggdrasil-tree"
page = pymupdf.open(pdf)[0]
page.get_pixmap(matrix=pymupdf.Matrix(width / page.rect.width, width / page.rect.width)).save(f"{out}.png")
Path(f"{out}.svg").write_text(page.get_svg_image(), encoding="utf-8")
