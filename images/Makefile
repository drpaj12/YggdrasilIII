# Regenerate yggdrasil-tree.{svg,png} from images/src. Override TECTONIC and PY for your machine.
TECTONIC ?= $(HOME)/odin3-ws/work/tools/tectonic/tectonic
PY ?= $(HOME)/odin3-ws/work/tools/venv/bin/python
WIDTH ?= 1600

all: yggdrasil-tree.png yggdrasil-tree.svg

src/yggdrasil-tree.pdf: src/yggdrasil-tree.tex src/fig_yggdrasil.tex src/odin3-tikz-styles.tex
	cd src && $(TECTONIC) yggdrasil-tree.tex

yggdrasil-tree.png yggdrasil-tree.svg: src/yggdrasil-tree.pdf render.py
	$(PY) -I render.py src/yggdrasil-tree.pdf $(WIDTH)

clean:
	rm -f src/yggdrasil-tree.pdf yggdrasil-tree.png yggdrasil-tree.svg

.PHONY: all clean
