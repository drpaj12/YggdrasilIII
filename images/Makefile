# Regenerate yggdrasil-tree.{svg,png} from images/src. Needs latexmk (system TeX Live). Override LATEXMK and PY for your machine.
LATEXMK ?= latexmk
PY ?= $(HOME)/odin3-ws/work/tools/venv/bin/python
WIDTH ?= 1600

all: yggdrasil-tree.png yggdrasil-tree.svg

src/yggdrasil-tree.pdf: src/yggdrasil-tree.tex src/fig_yggdrasil.tex src/odin3-tikz-styles.tex
	cd src && $(LATEXMK) -pdf -interaction=nonstopmode -halt-on-error yggdrasil-tree.tex

yggdrasil-tree.png yggdrasil-tree.svg: src/yggdrasil-tree.pdf render.py
	$(PY) -I render.py src/yggdrasil-tree.pdf $(WIDTH)

clean:
	rm -f src/yggdrasil-tree.pdf src/yggdrasil-tree.log src/yggdrasil-tree.fls src/yggdrasil-tree.fdb_latexmk yggdrasil-tree.png yggdrasil-tree.svg

.PHONY: all clean
