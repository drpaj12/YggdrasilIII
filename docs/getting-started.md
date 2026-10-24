# Getting started

This page takes a clean machine to a working Yggdrasil III: every tool compiled, every Python package
installed, and one smoke test per tool. It links to each piece's own manual for details instead of
repeating them, and each command names the file it comes from. To drive the result through an AI
coding agent, see {doc}`ai-agent` and {doc}`agent-controller`.

## 0. The machine

Two starting points reach the same state.

- **Ubuntu 24.04, native.** Go on to section 1.
- **Windows 11.** The tools run on Linux, so install WSL 2 with Ubuntu 24.04 and keep the work in the
  Linux file system. {doc}`ai-agent` section 1 gives the commands, the `.wslconfig` memory limits and
  the free-space rule. Then open the Ubuntu terminal and go on to section 1.

A full build and the sweeps use several gigabytes of memory and tens of gigabytes of disk. Give the
machine at least 16 GB of RAM and 60 GB of free disk before the VTR build in section 6.

## 1. Operating-system packages

The Odin III CI installs `ninja-build libreadline-dev bison flex` on Ubuntu
(`.github/workflows/ci.yml` in the Odin III repository). Add the basics:

```bash
sudo apt-get update
sudo apt-get install -y --no-install-recommends \
  git curl ca-certificates build-essential cmake ninja-build bison flex libreadline-dev \
  python3 python3-venv python3-pip
```

Odin III needs CMake 3.28 or later for its default SystemVerilog build; with `cmake --version` below
3.28, configure with `-DODIN3_WITH_SLANG=OFF` (CMake 3.25 then suffices). Source:
`docs/user/getting-started.md` in the Odin III repository. Wyrd III, Loki III and Verdandi III need
Python 3.11 or later (their `CLAUDE.md`); Ubuntu 24.04 ships 3.12.

## 2. Get the sources

The hub holds all five code repositories as git submodules under `components/`: `odin3`, `wyrd`,
`loki`, `verdandi` (Verdandi III) and `norns` (The Norns III). Clone it with the submodules, into one
workspace folder (`<ws>` below; any name, for example `~/ws`):

```bash
mkdir -p ~/ws && cd ~/ws
git clone --recurse-submodules https://github.com/drpaj12/YggdrasilIII.git
cd YggdrasilIII
```

The submodules of Odin III (ABC, Unity, vendored slang) come with `--recurse-submodules`. You can
also clone each repository on its own: <https://github.com/drpaj12/odin3>,
<https://github.com/drpaj12/wyrd>, <https://github.com/drpaj12/loki>,
<https://github.com/drpaj12/verdandiIII>, <https://github.com/drpaj12/nornsIII>.

If you cloned without `--recurse-submodules`, run `git submodule update --init --recursive`.

## 3. Odin III

From `components/odin3` (source: its `README.md` and `docs/user/getting-started.md`):

```bash
cd components/odin3
cmake --preset release && cmake --build --preset release
export ODIN3_ROOT=$PWD
export PATH="$ODIN3_ROOT/build/release:$PATH"
odin3 --version
```

`odin3 --version` prints the version, the ABI number, the SystemVerilog adapter line and the linked ABC
commit. The `debug` preset adds ASan and UBSan and is the one the test suite uses.

The standalone ABC binary that Verdandi III and the equivalence tools use comes from the same tree
(`docs/ORACLES.md` in the Odin III repository):

```bash
cmake --build --preset release --target odin3_abc_exe     # build/release/third_party/abc/abc
```

**Smoke test.** The flow script takes a micro design from Verilog to a BLIF netlist; without
`VTR_ROOT` it stops after Odin III and says so:

```bash
tools/flow/odin3-flow tests/micro/verilog/micro/bm_DL_2_4_encoder.v --analysis --out out/enc
```

It ends with `step odin3: ok`, `step analysis: ok` and `luts 4`. The unit tests are
`ctest --preset debug` after `cmake --preset debug && cmake --build --preset debug`
(`CLAUDE.md` of Odin III).

## 4. The Python environment

One virtual environment, at the hub folder, holds Wyrd III, Loki III and Verdandi III:

```bash
cd ~/ws/YggdrasilIII
python3 -m venv .venv
```

### The odin3 package

The `sim` and `midgard` extras of Wyrd III, Loki III and Verdandi III import the `odin3` Python
package (a cffi binding). Odin III is not on PyPI. Two ways to give them the package:

- **From the source tree you just built** (the way the Loki III and Verdandi III `CLAUDE.md` files do it):

  ```bash
  .venv/bin/pip install cffi
  export ODIN3_LIB=$ODIN3_ROOT/build/release/libodin3.so
  export PYTHONPATH=$ODIN3_ROOT/plugins/python
  ```

- **As a wheel.** The release page of Odin III, <https://github.com/drpaj12/odin3/releases>, carries
  wheels (`pip install odin3-<version>-py3-none-linux_x86_64.whl`; the wheel bundles `libodin3`, ABC,
  the `odin3` command and `odin3-flow`). To build one from the sources, the release check
  (`tools/release/clean-check`) runs:

  ```bash
  python3 -m venv /tmp/buildvenv
  /tmp/buildvenv/bin/python -m pip install scikit-build-core==0.11.6 build==1.2.2.post1 cffi==1.17.1
  /tmp/buildvenv/bin/python -m build --wheel --no-isolation --outdir dist "$ODIN3_ROOT"
  .venv/bin/pip install dist/odin3-*.whl
  ```

Wyrd III needs `odin3` 1.0.3 or later for its `sim` and `midgard` extras.

### Wyrd III

```bash
.venv/bin/pip install -e "components/wyrd[gui,sim,midgard]"
.venv/bin/wyrd config init     # writes ~/.config/wyrd/machine.toml with detected values
.venv/bin/wyrd config show     # every effective setting and where it came from
```

(`README.md` and `docs/user/getting-started.md` of Wyrd III.) The extras add the GUI (`gui`, PySide6),
simulation through Bifrost III (`sim`) and Midgard III (`midgard`, pygame-ce). Tool locations and
resource limits belong to the machine, not to a project: set `vtr_root` in `machine.toml` once VTR is
built (section 6), or export `VTR_ROOT` before `wyrd config init`. `$WYRD_CONFIG` changes the path of
the file.

**Smoke test.** The unit tests need no Odin III or VTR:

```bash
cd components/wyrd && ../../.venv/bin/python -m unittest discover -s tests -t . -v
```

(`CLAUDE.md` of Wyrd III.) With VTR built, the samples check the whole chain:
`wyrd run --project components/wyrd/samples` then `wyrd table --project components/wyrd/samples`
(`README.md` of Wyrd III). The first project from scratch is the PDF tutorial,
<https://drpaj12.github.io/wyrd/wyrd-tutorial.pdf>, and the same in the graphical interface,
<https://drpaj12.github.io/wyrd/wyrd-gui-tutorial.pdf>.

### Loki III

```bash
.venv/bin/pip install --no-deps -e components/loki
.venv/bin/pip install numpy scipy scikit-learn networkx     # the analysis extra, for loki analyze
.venv/bin/loki tools fetch-orca                             # graphlet orbit counts (L2), built from pinned source
```

Loki III installs with `--no-deps` because `odin3` is not on PyPI; it needs `cffi` and the three Odin
III variables of section 3 and above (`ODIN3_ROOT`, `ODIN3_LIB`, `PYTHONPATH`). The `gnn` extra adds
torch and torch_geometric; its two install lines are in `CLAUDE.md` of Loki III. Source: the Loki III
`README.md`, `CLAUDE.md`, and its manual, <https://drpaj12.github.io/loki/install.html>.

**Smoke test.** The L0 dataset on the micro designs (`docs/runbook-l0.md` of Loki III; needs VTR for the
architecture files):

```bash
.venv/bin/loki bench init --suite micro --odin3-root $ODIN3_ROOT --out datasets/l0
.venv/bin/wyrd run --project datasets/l0 --jobs 3 --mem-budget 8G
.venv/bin/loki assemble --project datasets/l0 --out dataset
.venv/bin/loki check dataset
```

The last line prints `loki check: 0 error(s)`. The unit tests are
`.venv/bin/python -m unittest discover -s tests -t . -v` from `components/loki`.

**The VerilogEval dataset.** `--suite verilog-eval` of `loki bench init` clones the pinned VerilogEval
commit into `~/.cache/loki/verilog-eval` (`--cache DIR` changes the place) and treats it as data,
never executed (`docs/runbook-l0.md` of Loki III):

```bash
.venv/bin/loki bench init --suite verilog-eval --odin3-root $ODIN3_ROOT --out datasets/veval
```

### Verdandi III

```bash
.venv/bin/pip install -e "components/verdandi[gui]"
```

(`CLAUDE.md` and the manual of Verdandi III.) It needs PySide6 for the player (extra `gui`),
`ODIN3_ROOT`, `ODIN3_LIB` and `PYTHONPATH` as above; the standalone ABC binary (`$ODIN3_ABC`, else
`$ODIN3_ROOT/build/*/third_party/abc/abc`) and Graphviz `dot` (`sudo apt-get install -y graphviz`)
are optional.

**Smoke test.** Record the shipped example without VTR, using the LPM technology library, and read the
trace (`examples/playthrough/README.md` and the manual):

```bash
cd components/verdandi
../../.venv/bin/verdandi record examples/playthrough/playthrough.v --top playthrough \
  --techlib "$ODIN3_ROOT/lib/lpm.o3lib" -o /tmp/trace
../../.venv/bin/verdandi info /tmp/trace
```

`verdandi play /tmp/trace` opens the player (it needs a display; under WSL 2 the window appears through
WSLg).

### The Norns III

The Norns III is scripts and data, not an installed package (`README.md` of The Norns III). It needs a
Python with the Loki analysis libraries (numpy, scipy, scikit-learn, networkx, cffi), the pinned VTR
build of section 6, Odin III, and Loki III imported from its checkout. Set its variables, then read
`scripts/env.sh`:

```bash
python3 -m venv ~/ws/nr-venv && ~/ws/nr-venv/bin/pip install numpy scipy scikit-learn networkx cffi
export NR_PY=~/ws/nr-venv/bin/python
export ODIN3_ROOT=~/ws/YggdrasilIII/components/odin3
export LOKI_HOME=~/ws/YggdrasilIII/components/loki
export VTR_ROOT=~/ws/vtr-verilog-to-routing
```

`scripts/env.sh` and `scripts/nornlib.py` read `ODIN3_ROOT`, `VTR_ROOT`, `LOKI_HOME` and `NR_PY` from the
environment. `env.sh` also sets `NORN` to `$HOME/odin3-ws/work/norns-exp`, so a Norns III run expects
its checkout at that path; link or clone it there (`ln -s` from `components/norns`) until the script
takes the path from the environment.

**Smoke test.** One small design end to end, then the report (`README.md` of The Norns III; every VPR run
takes the heavy lock described in {doc}`agent-controller`):

```bash
cd components/norns
scripts/run_design.sh ch_intrinsics     # front end, baseline, Loki clusters, seeds, matrix
scripts/report.py                       # regenerate docs/plan/EXPERIMENT.md
```

## 5. ABC

Odin III links its own ABC (a pinned submodule, built with Odin III) and needs nothing else. The
standalone `abc` program is the `odin3_abc_exe` target of section 3. VTR carries a second ABC for its
own flow; the two are different pins and are not mixed in one comparison (`docs/ORACLES.md` of Odin III).

## 6. VTR and VPR

The VPR step of the flow, the Wyrd III `vtr` flow, the Loki III architecture files and The Norns III need
a VTR checkout. The Norns III and the Odin III goldens use one pin: VTR commit
`3c9a4d23b27d187bd67c79dc01a18ff1ffc21d9b` (`9.0.0-dev+v8.0.0-18416-g3c9a4d23b2`; `docs/ORACLES.md` of
Odin III and `docs/plan/vtr-interfaces.md` of The Norns III). The build steps are those of
`BUILDING.md` at that commit in the VTR repository:

```bash
cd ~/ws
git clone https://github.com/verilog-to-routing/vtr-verilog-to-routing.git
cd vtr-verilog-to-routing
git checkout 3c9a4d23b27d187bd67c79dc01a18ff1ffc21d9b
git submodule init && git submodule update
./install_apt_packages.sh
make env && source .venv/bin/activate && pip install -r requirements.txt
make -j$(nproc)
export VTR_ROOT=$PWD
```

The build takes a long time and several gigabytes of disk. `VTR_ROOT` is what `odin3-flow`, Wyrd III
(`vtr_root` in `machine.toml`), Loki III and The Norns III read; the VPR binary is
`$VTR_ROOT/build/vpr/vpr`. The floorplan viewer of the Wyrd III GUI needs a second VPR built with
graphics; its steps are in the [Wyrd III getting-started page](https://drpaj12.github.io/wyrd/getting-started.html).

Without `VTR_ROOT`, `odin3-flow` stops after Odin III and says so. Re-run the Odin III smoke test of
section 3 with `VTR_ROOT` set to see VPR's numbers in `summary.json`.

## 7. Tectonic, for the papers

The papers are LaTeX. Odin III builds its paper with Tectonic (`docs/paper/Makefile`, variable
`TECTONIC`); the hub regenerates the tree picture with it (`images/Makefile`). The Tectonic install
page, <https://tectonic-typesetting.github.io/en-US/install.html>, gives:

```bash
curl --proto '=https' --tlsv1.2 -fsSL https://drop-sh.fullyjustified.net | sh
```

That leaves a `tectonic` binary in the current folder; put it on `PATH`. Then:

```bash
make -C components/odin3/docs/paper TECTONIC=$(command -v tectonic)     # build/odin3.pdf
```

The Loki III and The Norns III papers are IEEEtran sources made to upload to Overleaf (compile with
pdfLaTeX; `docs/paper/README.md` of each). The tree picture also needs `pymupdf`
(`make -C images TECTONIC=... PY=...`).

## 8. The documentation

The hub and the manuals build with Sphinx and MyST, each with `-W`, so a broken link or reference fails
the build:

```bash
python3 -m venv .docs-venv && .docs-venv/bin/pip install -r requirements-docs.txt
.docs-venv/bin/sphinx-build -W -b html docs build/docs                      # this hub
.docs-venv/bin/sphinx-build -W -b html components/wyrd/docs/user build/wyrd
```

The Odin III, Loki III and Verdandi III manuals build the same way from `docs/user`; the Odin III build
also needs the `odin3` binary (`ODIN3_CLI`, or `build/release/odin3`).

## Updating the components

The pins of the submodules are the commits the hub was last tested against. To move them to the
current `main` of each repository:

```bash
git submodule update --remote
git add components
git commit -m "components: update pins"
```
