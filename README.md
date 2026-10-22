# Yggdrasil III

Yggdrasil III is a suite of CAD and EDA tools for academic FPGA and ASIC-like research. It takes a design
from HDL to a netlist and keeps, for every object in the netlist, a pointer back to the HDL text it came
from. This repository is the starting point: the overall documentation, and the three code repositories
as submodules.

![Yggdrasil III drawn as a tree: roots, the Odin III trunk, the canopy, the side-branch tools and the oracle forest](images/yggdrasil-tree.png)

## The layers

| Layer | Piece | What it is | Repository | Documentation |
|---|---|---|---|---|
| Roots | inputs, outputs, linked tools | Reads Verilog, BLIF, Yosys JSON and gate Verilog; writes BLIF for VPR and Verilog; links ABC, VTR and VPR. |
| Oracle forest | the oracles | Yosys, Parmys, Odin II, VTR golden results and ABC. Forest of Oracles to compare against; not part of the suite. | | |
| Trunk | Odin III | The condensed flow: Verilog to a provenance-tracked IR to BLIF for VPR. | [odin3](https://github.com/drpaj12/odin3) | [manual](https://drpaj12.github.io/odin3/) |
| Canopy | Wyrd III | Experiment runner and GUI. | [wyrd](https://github.com/drpaj12/wyrd) | [manual](https://drpaj12.github.io/wyrd/), tutorials: [command line](https://drpaj12.github.io/wyrd/wyrd-tutorial.pdf), [GUI](https://drpaj12.github.io/wyrd/wyrd-gui-tutorial.pdf) |
| Canopy | Bifrost III | The simulation bridge, inside Wyrd III. | [wyrd](https://github.com/drpaj12/wyrd) | [simulation](https://drpaj12.github.io/wyrd/simulation.html) |
| Canopy | Midgard III | verilogTown, inside Wyrd III. | [wyrd](https://github.com/drpaj12/wyrd) | [Midgard III](https://drpaj12.github.io/wyrd/midgard.html) |
| Side branch | Loki III | Tool & Experiment: reverse engineering of structural netlists. | [loki](https://github.com/drpaj12/loki) | [manual](https://drpaj12.github.io/loki/) |
| Side branch | Leman Russ III | Tool & Experiment: HT detection tools (higher-level detection, including Trojans). | | |
| Side branch | The Norns III | Tool & Experiment: Placement with Provenance. | | |

The [hub documentation](https://drpaj12.github.io/YggdrasilIII/) (sources in `docs/`) covers how the pieces connect:
[getting started](docs/getting-started.md), [architecture](docs/architecture.md),
[the pieces](docs/pieces/index.md) and [publications](docs/publications.md).

## Quick start

New here? Start with the [PDF tutorial](https://drpaj12.github.io/wyrd/wyrd-tutorial.pdf): it makes a project, takes it
through VTR, simulates it, and uses the ready-made samples. The [GUI tutorial](https://drpaj12.github.io/wyrd/wyrd-gui-tutorial.pdf) does the same
in the graphical interface, with a figure for each step.

```bash
git clone --recursive https://github.com/drpaj12/YggdrasilIII.git && cd YggdrasilIII
(cd components/odin3 && cmake --preset release && cmake --build --preset release)   # Odin III
python3 -m venv .venv && .venv/bin/pip install -e "components/wyrd[gui,sim,midgard]"   # Wyrd III
.venv/bin/pip install --no-deps -e components/loki                                     # Loki III
```

The `sim` and `midgard` extras need the `odin3` package; see [getting started](docs/getting-started.md)
and each piece's own manual for the details, including VTR and `wyrd config init`.

## Components

`components/` holds odin3, wyrd and loki as git submodules, pinned to a tested commit. To move the pins to
the current `main` of each:

```bash
git submodule update --remote
git add components && git commit -m "components: update pins"
```

## Build the documentation

```bash
python3 -m venv .venv && .venv/bin/pip install -r requirements-docs.txt
.venv/bin/sphinx-build -W -b html docs build/docs
```

The tree picture is regenerated from `images/src/` with `make -C images`.

## How to cite

Cite the Odin III paper: *Odin III, the Final Frontier: Verilog Synthesis, again, Now Leading to
Yggdrasil III built by the dark factory* (no venue yet). Further publications are listed in
[docs/publications.md](docs/publications.md).

## License

MIT. See [LICENSE](LICENSE).
