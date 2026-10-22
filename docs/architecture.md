# Architecture

How the layers connect. Each arrow is something a piece uses from the next one down; nothing above
Odin III changes Odin III.

```{mermaid}
flowchart TD
  V[Verilog, BLIF, Yosys JSON, gate Verilog] --> O[Odin III]
  O -->|BLIF| VTR[VTR: VPR]
  O -->|Python binding, C ABI| B[Bifrost III]
  B --> W[Wyrd III]
  B --> M[Midgard III]
  W -->|runs the flow| O
  W -->|step plugin| L[Loki III]
  L -->|provenance via the binding| O
```

## Verilog to VTR

Odin III reads Verilog-2005, BLIF, Yosys JSON, structural gate-level Verilog and VPR architecture
files into one hierarchical IR. Its flow is one pass per stage: read, `proc`, `fsm`, `opt`, `flatten`,
`wreduce`, `hardmap`, `lower`, `abc`, `write_blif`. The result is a BLIF netlist for VPR. The command
`odin3-flow` runs the whole path, with VPR when `VTR_ROOT` is set. The stages are described in the
[Odin III flow chapter](https://drpaj12.github.io/odin3/flow.html).

## Provenance

Every object in the IR carries a record of the HDL text it came from, and the record survives the
passes. The output writers can use it: `write_blif --name-style provenance` names nets by HDL
location, and `write_json --odin3` writes all provenance. Loki III reads provenance as the answer key
of its datasets. See the Odin III [outputs](https://drpaj12.github.io/odin3/outputs.html) and
[reverse-engineering workflow](https://drpaj12.github.io/odin3/re-workflow.html) pages.

## The Python binding and the C ABI

Odin III exposes a C ABI (`include/odin3/odin3.h`). `plugins/python/odin3.py` is a cffi binding to it,
and the wheel carries the same binding. Everything above Odin III uses Odin III either as programs
(`odin3`, `odin3-flow`) or through this binding, so the core stays unchanged when a new tool is
added. See the [Python API page](https://drpaj12.github.io/odin3/python-api.html).

## Bifrost III over the simulation API

Bifrost III (`wyrd.bifrost`) is the one place where Wyrd III imports the `odin3` package. It compiles
Verilog with `read_verilog; proc; opt; lower`, then steps Odin III's per-cycle simulator: named inputs
and outputs, step, reset, recording and VCD output. Wyrd III's `wyrd sim` command and the GUI's
Simulate tab use it.

## Midgard III on Bifrost III

Midgard III, the replication of verilogTown, runs on Bifrost III: each player module is compiled and
simulated by Odin III while cars drive through the town.

## Loki III datasets

Loki III is a Wyrd III step plugin (entry point group `wyrd.steps`). A Loki dataset is a Wyrd III
project: `loki bench init` writes it, `wyrd run` runs the designs through Odin III and VTR, and
`loki assemble` turns the runs into labelled, anonymised netlists with Odin III provenance as the
answer key.

## Gate mapping

For gate-level netlists, Odin III's `abc --gates LIB` maps soft logic to the gates of a library, and
`write_blif --gates-as-names` writes gate cells as plain `.names` logic so equivalence tools see
logic on both sides of a mapping. The Loki III hypothesis spec (L1) reads gate-level netlists through the same `write_blif --gates-as-names` path.
See the [pass reference](https://drpaj12.github.io/odin3/passes.html).
