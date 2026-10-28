# Yggdrasil III

Yggdrasil III is a suite of CAD and EDA tools for academic FPGA and ASIC-like research. It takes a design
from HDL to a netlist and keeps, for every object in the netlist, a pointer back to the HDL text it came
from. This repository is the starting point: the overall documentation, and the six code repositories
as submodules.

![Yggdrasil III drawn as a tree: roots, the Odin III trunk, the canopy, the side-branch tools, Mímir III as the fruit and the oracle forest](images/yggdrasil-tree.png)

## The layers

| Layer | Piece | What it is | Repository | Documentation |
|---|---|---|---|---|
| Roots | inputs, outputs, linked tools | Reads Verilog, BLIF, Yosys JSON and gate Verilog; writes BLIF for VPR and Verilog; links ABC, VTR and VPR. |
| Deep roots | three wells | The outside work the suite draws on. Mimisbrunnr (Mimir's well of wisdom): prior work and benchmarks (VerilogEval, Gate-Breaker, HAL and DANA, CIRCT, TPEKO, LogikBench, fusesoc-cores), feeding Loki III, The Norns III and Odin III. Urdarbrunnr (the Norns' well): FPGA CAD and its views (VTR and VPR, nextpnr, DREAMPlaceFPGA, OpenPARF, netlistsvg), feeding The Norns III and Wyrd III. Hvergelmir (the spring of all rivers): synthesis sources (Yosys, ABC, slang, mockturtle, the Wildebeest ABC scripts, FuseSoC and Edalize), feeding Odin III; the oracle trees drink from it too. | | |
| Oracle forest | the oracles | Yosys, Parmys, Odin II, VTR golden results and ABC. Forest of Oracles to compare against; not part of the suite. | | |
| Trunk | Odin III | The condensed flow: Verilog to a provenance-tracked IR to BLIF for VPR. | [odin3](https://github.com/drpaj12/odin3) | [manual](https://drpaj12.github.io/odin3/) |
| Canopy | Wyrd III | Experiment runner and GUI. | [wyrd](https://github.com/drpaj12/wyrd) | [manual](https://drpaj12.github.io/wyrd/), tutorials: [command line](https://drpaj12.github.io/wyrd/wyrd-tutorial.pdf), [GUI](https://drpaj12.github.io/wyrd/wyrd-gui-tutorial.pdf) |
| Canopy | Bifrost III | The simulation bridge, inside Wyrd III. | [wyrd](https://github.com/drpaj12/wyrd) | [simulation](https://drpaj12.github.io/wyrd/simulation.html) |
| Canopy | Midgard III | verilogTown, inside Wyrd III. | [wyrd](https://github.com/drpaj12/wyrd) | [Midgard III](https://drpaj12.github.io/wyrd/midgard.html) |
| Side branch | Loki III | Tool & Experiment: reverse engineering of structural netlists. | [loki](https://github.com/drpaj12/loki) | [manual](https://drpaj12.github.io/loki/) |
| Side branch | Leman Russ III | Tool & Experiment: HT detection tools (higher-level detection, including Trojans). | | |
| Side branch | The Norns III | Tool & Experiment: Placement with Provenance. | [nornsIII](https://github.com/drpaj12/nornsIII) | [plan and paper](https://github.com/drpaj12/nornsIII/tree/main/docs) |
| Side branch | Verdandi III | Tool & Experiment: the Micro through the Macro; an interactive record-and-replay walk of a micro design through Odin III. | [verdandiIII](https://github.com/drpaj12/verdandiIII) | [spec and plan](https://github.com/drpaj12/verdandiIII/tree/main/docs) |
| Fruit | Mímir III | Knowledge base: the circuit dataset harvested from every run, to be mined (design meta and lineage, structure and Rent statistics, provenance relationships, QoR per placer family). | [mimirIII](https://github.com/drpaj12/mimirIII) | [spec and draft questions](https://github.com/drpaj12/mimirIII/tree/main/docs), [hub page](https://drpaj12.github.io/YggdrasilIII/pieces/mimir.html); data: <https://drpeterjamieson.com/RESEARCH/MIMIR/mimir-data> |

The [hub documentation](https://drpaj12.github.io/YggdrasilIII/) (sources in `docs/`) covers how the pieces connect:
[getting started](https://drpaj12.github.io/YggdrasilIII/getting-started.html), [working with an AI coding agent](https://drpaj12.github.io/YggdrasilIII/ai-agent.html), [running the suite with Claude Code](https://drpaj12.github.io/YggdrasilIII/agent-controller.html) (templates in [`agent-kit/`](agent-kit/README.md)),
[architecture](https://drpaj12.github.io/YggdrasilIII/architecture.html),
[the pieces](https://drpaj12.github.io/YggdrasilIII/pieces/index.html) and [publications](https://drpaj12.github.io/YggdrasilIII/publications.html).

## Versions

Each hub snapshot pins one commit of every component. Odin III is at 1.2.0 on `main`; Wyrd III, Loki III, Verdandi III
and Mímir III are at 0.1.0; The Norns III is identified by its commit. The table of snapshots (v1.1.0, v1.1.1, v1.2.0)
with the component versions, pins and what each added is in
[versions](https://drpaj12.github.io/YggdrasilIII/versions.html) (source `docs/versions.md`).

| Hub snapshot | Odin III | Wyrd III | Loki III | Verdandi III | The Norns III | Mímir III |
|---|---|---|---|---|---|---|
| v1.1.0 | 1.1.0 | 0.1.0 | 0.1.0 | 0.1.0 | `c49d316` | not a component |
| v1.1.1 | 1.1.1 | 0.1.0 | 0.1.0 | 0.1.0 | `0698983` | not a component |
| v1.2.0 (Odin III 1.2.0) | 1.2.0 | 0.1.0 | 0.1.0 | 0.1.0 | `61fd41b` | 0.1.0 (`b8b4118`) |

## Quick start

New here? Start with the [PDF tutorial](https://drpaj12.github.io/wyrd/wyrd-tutorial.pdf): it makes a project, takes it
through VTR, simulates it, and uses the ready-made samples. The [GUI tutorial](https://drpaj12.github.io/wyrd/wyrd-gui-tutorial.pdf) does the same
in the graphical interface, with a figure for each step.
To set everything up on Windows and drive it with an AI coding agent, see
[working with an AI coding agent](https://drpaj12.github.io/YggdrasilIII/ai-agent.html) and
[running the suite with Claude Code](https://drpaj12.github.io/YggdrasilIII/agent-controller.html).

```bash
git clone --recurse-submodules https://github.com/drpaj12/YggdrasilIII.git && cd YggdrasilIII
(cd components/odin3 && cmake --preset release && cmake --build --preset release)   # Odin III
python3 -m venv .venv && .venv/bin/pip install -e "components/wyrd[gui,sim,midgard]"   # Wyrd III
.venv/bin/pip install --no-deps -e components/loki                                     # Loki III
```

The full clean-machine procedure, for Ubuntu 24.04 and Windows 11, is in
[getting started](https://drpaj12.github.io/YggdrasilIII/getting-started.html).

The `sim` and `midgard` extras need the `odin3` package; see [getting started](https://drpaj12.github.io/YggdrasilIII/getting-started.html)
and each piece's own manual for the details, including VTR and `wyrd config init`.

## Components

`components/` holds odin3, wyrd, loki, verdandi (verdandiIII), norns (nornsIII) and mimir (mimirIII) as git submodules, pinned to a tested commit. To move the pins to
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
[docs/publications.md](https://drpaj12.github.io/YggdrasilIII/publications.html).

## License

MIT. See [LICENSE](LICENSE).
