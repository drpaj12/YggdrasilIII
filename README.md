# Yggdrasil III

Yggdrasil III is a suite of CAD and EDA tools for academic FPGA and ASIC-like research. It takes a design
from HDL to a netlist and keeps, for every object in the netlist, a pointer back to the HDL text it came
from. This repository is the starting point: the overall documentation, and the three code repositories
as submodules.

![Yggdrasil III drawn as a tree: roots, the Odin III trunk, the canopy, and the oracle forest](images/yggdrasil-tree.png)

## The layers

| Layer | Piece | What it is | Repository | Documentation |
|---|---|---|---|---|
| Roots | the oracles | Yosys, Parmys, Odin II, VTR and ABC. Compared against; not part of the suite. | | |
| Trunk | Odin III | The condensed flow: Verilog to a provenance-tracked IR to BLIF for VPR. | [odin3](https://github.com/drpaj12/odin3) | [manual](https://drpaj12.github.io/odin3/) |
| Branches | Wyrd III | Experiment runner and GUI. | [wyrd](https://github.com/drpaj12/wyrd) | [manual](https://github.com/drpaj12/wyrd/tree/main/docs/user), [tutorial](https://github.com/drpaj12/wyrd/tree/main/docs/tutorial) |
| Branches | Bifrost III | The simulation bridge, inside Wyrd III. | [wyrd](https://github.com/drpaj12/wyrd) | [simulation](https://github.com/drpaj12/wyrd/blob/main/docs/user/simulation.md) |
| Branches | Midgard III | verilogTown, inside Wyrd III. | [wyrd](https://github.com/drpaj12/wyrd) | [midgard](https://github.com/drpaj12/wyrd/blob/main/docs/user/midgard.md) |
| Canopy | Loki III | Reverse engineering of structural netlists. | [loki](https://github.com/drpaj12/loki) | [specs](https://github.com/drpaj12/loki/tree/main/docs/specs), [runbook](https://github.com/drpaj12/loki/blob/main/docs/runbook-l0.md) |
| Canopy | Leman Russ III | Higher-level detection, including Trojans. | | |
| Canopy | The Norns III | The placement experiment. | | |

The hub documentation (sources in `docs/`) covers how the pieces connect:
[getting started](docs/getting-started.md), [architecture](docs/architecture.md),
[the pieces](docs/pieces/index.md) and [publications](docs/publications.md).

## Quick start

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
