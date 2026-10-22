# Yggdrasil III

Yggdrasil III is a suite of CAD and EDA tools for academic FPGA and ASIC-like research. It takes a
design from HDL to a netlist and keeps, for every object in the netlist, a pointer back to the HDL
text it came from. This site is the starting point: it shows how the pieces fit together. Each
piece has its own manual, linked from the page of that piece.

![Yggdrasil III drawn as a tree](_static/yggdrasil-tree.png)

The picture is a tree. The roots are the inputs and the tools Odin III links to. The trunk is Odin III,
with its steps from the roots to the crown. The oracles are the small forest beside it: tools the suite
is compared against, not part of it. The canopy holds Wyrd III, Loki III, Bifrost III and Midgard III;
Leman Russ III and The Norns III are small pieces on the left.

## The layers

| Layer | Piece | What it is |
|---|---|---|
| Roots | the oracles | Yosys, Parmys, Odin II, VTR and ABC. Compared against; not part of the suite. |
| Trunk | {doc}`Odin III <pieces/odin3>` | The condensed flow: Verilog to a provenance-tracked IR to BLIF for VPR. |
| Branches | {doc}`Wyrd III <pieces/wyrd>` | Experiment runner and GUI. |
| Branches | {doc}`Bifrost III <pieces/bifrost>` | The simulation bridge, inside Wyrd III. |
| Branches | {doc}`Midgard III <pieces/midgard>` | verilogTown, inside Wyrd III. |
| Canopy | {doc}`Loki III <pieces/loki>` | Reverse engineering of structural netlists. |
| Canopy | {doc}`Leman Russ III <pieces/leman-russ>` | Higher-level detection, including Trojans. |
| Canopy | {doc}`The Norns III <pieces/norns>` | The placement experiment. |

## Where to start

- To install everything: {doc}`getting-started`.
- To see how the pieces connect: {doc}`architecture`.
- To use only the synthesis tool: the Odin III manual, <https://drpaj12.github.io/odin3/>.
- To cite the suite: {doc}`publications`.

```{toctree}
:maxdepth: 2
:hidden:

getting-started
architecture
pieces/index
publications
```
