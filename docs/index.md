# Yggdrasil III

Yggdrasil III is a suite of CAD and EDA tools for academic FPGA and ASIC-like research. It takes a
design from HDL to a netlist and keeps, for every object in the netlist, a pointer back to the HDL
text it came from. This site is the starting point: it shows how the pieces fit together. Each
piece has its own manual, linked from the page of that piece.

![Yggdrasil III drawn as a tree](_static/yggdrasil-tree.png)

The picture is a tree. The roots are what Odin III reads and writes (Verilog, BLIF, Yosys JSON and gate
Verilog in; BLIF for VPR and Verilog out) and the tools it links to (ABC, VTR and VPR). The trunk is
Odin III, with its steps running down from parsing to the roots. The oracles are the small forest beside
it: a Forest of Oracles to compare against, not part of the suite. The canopy holds Wyrd III, Bifrost III
and Midgard III. Loki III, Leman Russ III and The Norns III are tools and experiments on side branches
off the trunk.

## The layers

| Layer | Piece | What it is |
|---|---|---|
| Roots | inputs, outputs, linked tools | Reads Verilog, BLIF, Yosys JSON and gate Verilog; writes BLIF for VPR and Verilog; links ABC, VTR and VPR. |
| Oracle forest | the oracles | Yosys, Parmys, Odin II, VTR golden results and ABC. Forest of Oracles to compare against; not part of the suite. |
| Trunk | {doc}`Odin III <pieces/odin3>` | The condensed flow: Verilog to a provenance-tracked IR to BLIF for VPR. |
| Canopy | {doc}`Wyrd III <pieces/wyrd>` | Experiment runner and GUI. |
| Canopy | {doc}`Bifrost III <pieces/bifrost>` | The simulation bridge, inside Wyrd III. |
| Canopy | {doc}`Midgard III <pieces/midgard>` | verilogTown, inside Wyrd III. |
| Canopy | {doc}`Loki III <pieces/loki>` | Reverse engineering of structural netlists. |
| Canopy | {doc}`Leman Russ III <pieces/leman-russ>` | Higher-level detection, including Trojans. |
| Canopy | {doc}`The Norns III <pieces/norns>` | The placement experiment. |

## Where to start

- To install everything: {doc}`getting-started`.
- To see how the pieces connect: {doc}`architecture`.
- To use only the synthesis tool: the Odin III manual, <https://drpaj12.github.io/odin3/>.
- To run experiments: the Wyrd III manual, <https://drpaj12.github.io/wyrd/>.
- To reverse-engineer netlists: the Loki III manual, <https://drpaj12.github.io/loki/>.
- To cite the suite: {doc}`publications`.

```{toctree}
:maxdepth: 2
:hidden:

getting-started
architecture
pieces/index
publications
```
