# External tools

Every outside program the suite calls, reads or is measured against, with a link, what it is for, whether it is
required, and the exact version used on the development machine (Ubuntu 24.04 under WSL 2) on 2026-11-09. Nothing
here is guessed: each version was read from the machine. "Not installed here" means the tool is absent from the
development machine; the piece that uses it then runs without it or skips the test.

How each version was read: `--version` (or `-V`) of the program; `git -C <checkout> rev-parse` for a source
checkout; `pip show` or `pip list` for a Python package; `micromamba list` for a conda package; the pinned value in
the piece's own source where the tool is vendored or fetched by pin. Which piece uses which tool is on
{doc}`features`. A fresh machine installs the required ones in {doc}`getting-started`.

(tools-core)=
(tool-vtr)=
(tool-abc)=
(tool-slang)=
(tool-unity)=
(tool-oracles)=
## Synthesis and FPGA flow

| Tool | What for | Required | Links | Version used | How read |
|---|---|---|---|---|---|
| VTR and VPR (with ACE 2.0 and the architecture files) | Target flow: pack, place, route, timing, power; ACE 2.0 gives vectorless activity; first VTR paper Rose et al. 2012 and VTR 9 (TRETS 2025) | Optional for Odin III alone; required for `odin3-flow` to a routed result, Wyrd III runs, Bifrost III power, Heimdall III pages, The Norns III | [site](https://verilogtorouting.org/), [repo](https://github.com/verilog-to-routing/vtr-verilog-to-routing) | commit `3c9a4d23b2` (`v9.0.0-candidate1-6764-g3c9a4d23b2`); `vpr --version`: 9.0.0-dev+v8.0.0-18416-g3c9a4d23b2 | `git -C external/vtr-verilog-to-routing rev-parse`, `vpr --version` |
| ABC (Berkeley) | Soft-logic optimisation, LUT and gate mapping, equivalence checks; linked into Odin III and called by Leman Russ III and Verdandi III | Required (submodule of Odin III) | [repo](https://github.com/berkeley-abc/abc) | commit `a3001b72edc5de22442e942165487fddf150e3d0` (`third_party/abc`) | `git -C odin3 submodule status`, `docs/ORACLES.md` |
| slang | SystemVerilog front end (parse and elaborate) | Required (vendored, no network at build) | [repo](https://github.com/MikePopoloski/slang) | v12.0, commit `545f88b2ed3a2d20325fbd17413af177a6bca72f` (with fmt 12.2.0, boost.regex 1.91.0, tomlplusplus 3.4.0) | `third_party/slang/VENDORING.md` in odin3 |
| Unity | C unit-test framework for Odin III tests | Required to run tests (submodule) | [repo](https://github.com/ThrowTheSwitch/Unity) | v2.7.0, commit `b6763fbd9cedfacaa89e2ad9fd00d615a234e355` | `git -C odin3 submodule status` |
| Yosys + Parmys (VTR's pinned copy) | Oracle: VTR's default front end, goldens to compare against; never in the silicon path | Optional | [Yosys](https://github.com/YosysHQ/yosys), [Parmys in VTR](https://github.com/verilog-to-routing/vtr-verilog-to-routing/tree/master/parmys) | Yosys 0.55, `60f126cd00c94892782470192d6c9f7abebe7c05`; yosys-slang `55e3a2ad5b9dcdc8cf86918fb0a110fb6356def8` | `git submodule status` in the VTR checkout, `docs/ORACLES.md` |
| Yosys (standalone) | Differential oracle for fuzzing | Optional | [repo](https://github.com/YosysHQ/yosys) | source checkout `c4a0a2c486` (`v0.69-270-gc4a0a2c48`); no installed binary on the PATH | `git -C external/yosys rev-parse`; `yosys` not installed here |
| Odin II | Oracle and predecessor, built inside VTR | Optional | [in VTR](https://github.com/verilog-to-routing/vtr-verilog-to-routing/tree/master/odin_ii) | `9.0.0-dev+v8.0.0-18416-g3c9a4d23b2` (VTR commit above) | `docs/ORACLES.md` |
| Wildebeest ABC scripts | ABC scripts studied for Odin III's mapping | Optional | [repo](https://github.com/zeroasiccorp/wildebeest) | checkout `6763981244` | `git -C external/wildebeest rev-parse` |

(tool-iverilog)=
(tool-gtkwave)=
## Simulation

| Tool | What for | Required | Links | Version used | How read |
|---|---|---|---|---|---|
| Icarus Verilog | Reference simulator: testbench output compared with `sim_tb`, gate-level activity for Bifrost III power, Leman Russ III RTL testbenches | Optional (tests skip) | [site](https://steveicarus.github.io/iverilog/), [repo](https://github.com/steveicarus/iverilog) | 12.0 (stable) | `iverilog -V` |
| GTKWave | Open a Bifrost III recording | Optional | [site](https://gtkwave.sourceforge.net/) | not installed here | `command -v gtkwave` |

(tool-openroad)=
(tool-klayout)=
(tool-magic)=
(tool-netgen)=
(tool-pdk)=
## Silicon flow (Odin III 1.4 and later)

All optional, installed in user space, no sudo and no Docker ({doc}`getting-started` links to the Odin III manual page,
[silicon flow](https://drpaj12.github.io/odin3/silicon-flow.html), for the install lines). Without them the silicon tests skip and the flow
stops with exit 2 and a list. No Yosys is in this path.

| Tool | What for | Required | Links | Version used | How read |
|---|---|---|---|---|---|
| OpenROAD (includes OpenSTA) | Place and route with Odin III's own Tcl; OpenSTA gives ASIC power in Bifrost III | Optional | [repo](https://github.com/The-OpenROAD-Project/OpenROAD), [OpenSTA](https://github.com/The-OpenROAD-Project/OpenSTA) | `2.0_3175_gf12e2f474` (git `f12e2f474`, March 2022, conda `litex-hub`); OpenSTA is the copy inside it | `micromamba list -n orcond`, `openroad -version` |
| KLayout (Python module) | DEF to GDS | Optional | [site](https://www.klayout.de/) | 0.30.12 | `pip list` in the tools venv |
| Magic | Transistor-netlist extraction | Optional | [site](http://opencircuitdesign.com/magic/) | 8.3.465 (conda `litex-hub`) | `micromamba list -n eda` |
| Netgen | LVS: extracted SPICE against the OpenROAD netlist | Optional | [site](http://opencircuitdesign.com/netgen/) | 1.5.272 (conda `litex-hub`) | `micromamba list -n eda` |
| SKY130 PDK (`sky130_fd_sc_hd`) with ciel | Standard cells and Liberty for the silicon flow and Seeker-Si | Optional | [PDK](https://github.com/google/skywater-pdk), [ciel](https://github.com/fossi-foundation/ciel) | SKY130A, library `sky130_fd_sc_hd`, PDK commit `792ef67037d74c8c51811eab3ce23cf793491296`, ciel 3.2.0 | `ciel` pin in the install line, `pip list` |
| micromamba | Installs OpenROAD, Magic and Netgen from conda | Optional | [site](https://mamba.readthedocs.io/) | 2.10.0 | `micromamba --version` |

(tool-placers)=
(tool-orca)=
(tool-gatebreaker)=
(tool-hal)=
(tool-benchmarks)=
## Experiment tools, datasets and prior work

These are read, or run as separate tools; none is vendored into a piece.

| Tool | What for | Required | Links | Version used | How read |
|---|---|---|---|---|---|
| nextpnr | Outside placer tried by The Norns III (own "viaduct" uarch as an overlay) | Optional | [repo](https://github.com/YosysHQ/nextpnr) | checkout `9691ce8c43` | `git -C external/nextpnr rev-parse` |
| DREAMPlaceFPGA | Outside analytic placer, read for The Norns III | Optional | [repo](https://github.com/rachelselinar/DREAMPlaceFPGA) | checkout `0044943184` | `git -C external/DREAMPlaceFPGA rev-parse` |
| OpenPARF | Outside placer, read for The Norns III | Optional | [repo](https://github.com/PKU-IDEA/OpenPARF) | checkout `793cac2bb1` | `git -C external/OpenPARF rev-parse` |
| ORCA | Graphlet counting oracle for Odin III tests and the Loki III L2 backend | Optional | [repo](https://github.com/thocevar/orca) | commit `e146a8b1a99a90f5e3096b7bcc2ab0ea246c3ca7`, sha256 `01c580febfd3653a632a04d6b466f7c6f2bf2f9baf3a75a2e553be30ac7ee778` | `loki/analysis/graphlets/ext.py` (`loki tools fetch-orca` checks it) |
| HAL and DANA | Word-recovery comparison in Loki III | Optional | [repo](https://github.com/emsec/hal) | source read at master `c923080` (2026-10-26); not installed here | `docs/plan/hal-feasibility.md` in loki |
| Gate-Breaker and its VerilogEval netlists | LLM replication harness and the 156-design netlist dataset | Optional | [Gate-Breaker](https://github.com/NMSU-PEARL/Gate-Breaker), [the VerilogEval copy it uses](https://github.com/NMSU-PEARL/verilog-eval) | Gate-Breaker `8d0d3fa811`; Gate-Breaker-verilog-eval `d60f0b1045`; the plain external/verilog-eval is not a git checkout | `git -C external/<dir> rev-parse` |
| OpenCores designs, picorv32, darkriscv, serv, openMSP430, tinyriscv, ITC'99, FuseSoC, Edalize | Benchmark sources registered in Mímir III and used by Leman Russ III | Optional | [OpenCores](https://opencores.org/), [picorv32](https://github.com/YosysHQ/picorv32), [darkriscv](https://github.com/darklife/darkriscv) | each suite's upstream URL, commit and licence are in the Mímir III registry (`data/benchmarks/`); e.g. darkriscv `955511961f`, picorv32 `ef203c2b0a`, serv `f200eb2ed7`, fusesoc `2ed5d33646`, edalize `9a6f648c59` | registry, `git -C external/<dir> rev-parse` |

(tool-python)=
(tool-cmake)=
(tool-ninja)=
(tool-compilers)=
(tool-lint)=
(tool-cffi)=
(tool-sphinx)=
## Build, test and lint

| Tool | What for | Required | Links | Version used | How read |
|---|---|---|---|---|---|
| Python | Every piece except the Odin III core | Required (3.11 or later; 3.12 in CI for the hub) | [site](https://www.python.org/) | 3.12.3 | `python3 --version` |
| CMake | Odin III build | Required (3.25 or later; 3.28 for the default slang build) | [site](https://cmake.org/) | 3.28.3 | `cmake --version` |
| Ninja | Odin III build generator | Required | [site](https://ninja-build.org/) | 1.11.1 | `ninja --version` |
| gcc | Release build and CI | Required (gcc or clang) | [site](https://gcc.gnu.org/) | 13.3.0 (Ubuntu 13.3.0-6ubuntu2~24.04.1) | `gcc --version` |
| clang, clang-tidy, clang-format | Debug build with sanitisers in CI, lint gate | Required for the lint gate | [site](https://clang.llvm.org/) | 18.1.3 (Ubuntu 1ubuntu1) | `clang --version` |
| cppcheck | Lint gate | Required for the lint gate | [site](https://cppcheck.sourceforge.io/) | 2.13.0 | `cppcheck --version` |
| lizard | Complexity gate | Required for the lint gate | [repo](https://github.com/terryyin/lizard) | 1.24.1 | `lizard --version` |
| ruff | Python lint | Required for the lint gate | [site](https://docs.astral.sh/ruff/) | 0.16.10 (Odin III venv); 0.17.4 in the Heimdall III and Mímir III venvs | `ruff --version`, `pip list` |
| mypy | Python types | Required for the lint gate | [site](https://mypy-lang.org/) | 2.4.0 (Odin III venv); 2.4.1 in the Heimdall III and Mímir III venvs | `mypy --version`, `pip list` |
| pre-commit | Runs the gate on each commit | Optional | [site](https://pre-commit.com/) | 4.6.2 | `pre-commit --version` |
| cffi | The Python binding to the C ABI | Required for the binding | [site](https://cffi.readthedocs.io/) | 2.1.1 | `pip list` |
| scikit-build-core and build | Build the Odin III wheel | Optional | [repo](https://github.com/scikit-build/scikit-build-core) | scikit-build-core 0.11.6, build 1.2.2.post1, cffi 1.17.1 (the pins in {doc}`getting-started`) | pins in the build line |
| Sphinx, MyST, sphinxcontrib-mermaid | Documentation of every piece | Required to build docs | [Sphinx](https://www.sphinx-doc.org/), [MyST](https://myst-parser.readthedocs.io/) | Sphinx 8.1.3, myst-parser 4.0.1, sphinxcontrib-mermaid 1.0.0 | `requirements-docs.txt`, `pip list` |
| TeX Live (pdflatex, latexmk) | Papers and the tree picture | Optional | [site](https://tug.org/texlive/) | TeX Live 2023/Debian (pdfTeX 3.141592653-2.6-1.40.25), latexmk 4.83 | `pdflatex --version`, `latexmk --version` |
| pymupdf | Renders the tree picture PNG | Optional | [site](https://pymupdf.readthedocs.io/) | 1.28.2 (tools venv) | `pip list` |
| Git, GitHub CLI | Sources, pull requests | Required | [git](https://git-scm.com/), [gh](https://cli.github.com/) | git 2.43.0, gh 2.45.0 | `git --version`, `gh --version` |
| jq, flock (util-linux) | Controller scripts (status line, heavy lock) | Optional | [jq](https://jqlang.github.io/jq/) | jq 1.7, flock 2.39.3 | `jq --version`, `flock --version` |

(tool-pyside6)=
(tool-pygame)=
(tool-netlistsvg)=
(tool-graphviz)=
(tool-threejs)=
(tool-playwright)=
(tool-pydeps)=
(tool-torch)=
(tool-sqlite)=
(tool-xz)=
## Libraries and viewers

| Tool | What for | Required | Links | Version used | How read |
|---|---|---|---|---|---|
| PySide6 (Essentials) | Wyrd III GUI, Midgard III editors, Verdandi III player | Optional (extra `gui`) | [site](https://doc.qt.io/qtforpython-6/) | PySide6_Essentials 6.12.0 (with shiboken6 6.12.0) | `pip list` in the Wyrd III venv |
| pygame-ce | Midgard III game window | Optional (extra `midgard`) | [site](https://pyga.me/) | 2.5.8 | `pip list` |
| netlistsvg | Wyrd III schematic view (Node.js program, not bundled) | Optional | [repo](https://github.com/nturley/netlistsvg) | 1.0.2 tested by Wyrd III; not installed here | Wyrd III README; `command -v netlistsvg` |
| Node.js and npm | Runs netlistsvg | Optional | [site](https://nodejs.org/) | Node 22.23.3, npm 11.11.0 | `node --version`, `npm --version` |
| Graphviz `dot` | Verdandi III graph pictures | Optional | [site](https://graphviz.org/) | 2.43.0 | `dot -V` |
| three.js (vendored) | Heimdall III 3D viewer, with OrbitControls, both unmodified | Required by Heimdall III (vendored, no install) | [site](https://threejs.org/) | 0.160.0 (npm package `three@0.160.0`) | `heimdall/web/vendor/VERSIONS.txt` |
| Playwright and Chromium | Heimdall III headless checks, screenshots, touch check | Optional | [site](https://playwright.dev/python/) | Playwright 1.64.1 (Python); Chromium build 1248 | `pip list` in the screenshot venv, `~/.cache/ms-playwright` |
| numpy, scipy, scikit-learn, networkx | Loki III analysis extra, Mímir III analysis, Leman Russ III | Optional (extras) | [numpy](https://numpy.org/), [scikit-learn](https://scikit-learn.org/) | numpy 2.5.4, scipy 1.18.1, scikit-learn 1.9.1, networkx 3.7 | `pip list` |
| torch and torch_geometric | GNN baselines of Loki III and Leman Russ III (CPU wheel) | Optional; not installed in the main Python | [PyTorch](https://pytorch.org/), [PyG](https://pyg.org/) | torch 2.5.1+cpu, torch_geometric 2.8.1 (in a separate environment); `import torch` fails in the system Python | `pip list` in that environment |
| pymetis, pyarrow | Mímir III Rent's rule (METIS) and Parquet export | Optional (extras) | [pymetis](https://github.com/inducer/pymetis), [pyarrow](https://arrow.apache.org/docs/python/) | pymetis 2025.2.2, pyarrow 26.0.1 | `pip list` in the Mímir III venv |
| SQLite | Mímir III store | Required (Python standard library) | [site](https://www.sqlite.org/) | 3.45.1 | `sqlite3.sqlite_version` |
| xz | Mímir III blobs and snapshots | Required | [site](https://tukaani.org/xz/) | 5.4.5 | `xz --version` |

(tool-claude)=
## Agent tooling

For {doc}`agent-controller`. All optional.

| Tool | What for | Links | Version used | How read |
|---|---|---|---|---|
| Claude Code | The controller session and the lane subagents | [docs](https://code.claude.com/docs) | 2.1.316 | `claude --version` |
| superpowers plugin | Skills for planning, test-first work and review | [repo](https://github.com/obra/superpowers) | 6.4.2 (marketplace `superpowers-marketplace`) | `claude plugin list` |
| caveman plugin | Terse output style that saves tokens | [repo](https://github.com/JuliusBrussee/caveman) | 4.0.1 (marketplace `caveman`; enabled in the workspace project) | `claude plugin list` |
| clangd-lsp plugin | C language server for Odin III | [directory](https://github.com/anthropics/claude-plugins-official) | 1.0.0 | `claude plugin list` |
| code-review-graph (MCP server) | A code graph per worktree, so agents query instead of reading whole files | [repo](https://code-review-graph.com) | 2.3.9 (installed with pipx) | `code-review-graph --version` |

## What you need to do X

- **Synthesise and map a design (Verilog to BLIF).** Odin III alone: a C compiler, CMake, Ninja, bison, flex and
  readline ({doc}`getting-started` section 1 and 3). ABC, slang and Unity come with the Odin III sources.
- **Run a design through VPR and read the QoR.** Add VTR and VPR (commit above) with `VTR_ROOT` set; for the
  floorplan window, a VPR built with Qt6 graphics.
- **Run experiments with Wyrd III.** Python 3.11 or later, the `odin3` wheel, VTR; `PySide6` for the GUI.
- **Estimate power.** VPR `--power` for FPGA, which needs the VTR build; ACE 2.0 (in VTR) or Odin III's `activity`
  pass for the activity; Icarus Verilog for gate-level testbench activity; OpenROAD (with OpenSTA) and the SKY130 PDK
  for ASIC.
- **Simulate a testbench.** `sim_tb` in Odin III needs nothing else; Icarus Verilog to compare; GTKWave to look at a VCD.
- **Silicon place and route.** The silicon-flow tools above: OpenROAD, KLayout, Magic, Netgen and the PDK.
- **View a design in Heimdall III.** Python 3.11 or later and a browser; a finished run directory from Odin III and VPR;
  Playwright and Chromium only for the checks.
- **Reverse-engineer a netlist with Loki III.** The `odin3` package, numpy, scipy, scikit-learn and networkx; torch
  only for the GNN; ORCA by `loki tools fetch-orca`.
- **Build the Seeker benchmarks.** Leman Russ III, the `odin3` package, ABC, Icarus Verilog; the silicon tools for Seeker-Si.
- **Build the documentation.** Python and `requirements-docs.txt`; Node.js and netlistsvg are not needed; TeX Live only for papers.
