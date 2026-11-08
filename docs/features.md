# Features

What each piece can do today, one line per feature, with its status: **works** (in the repository with tests),
**optional** (needs an extra or an outside program), **experimental** (research code run by script) and **closed**
(measured, did not beat noise or did not help; kept as a record). The full tables, with the page or code each
line points to, are in each repository's README. Versions of the components are on {doc}`versions`.

(features-odin3)=
## Odin III (version 1.5.0; C ABI 7)

| Feature | Status |
|---|---|
| Inputs: SystemVerilog (slang adapter), Verilog-2005, BLIF, Yosys JSON, structural gate-level Verilog, VPR architecture files, project files | works |
| Elaboration and the pass flow (`proc`, `opt`, `fsm`, `flatten`, `wreduce`, partial mapping, `lower`, ABC, LPM, `unmap`); `odin3-flow` to a routed VPR result | works |
| Provenance at every granularity: each output object traces to its HDL text, with labelled joins | works |
| 4-state simulation (1.5.0): `sim_tb` is 4-state by default (`--2state` keeps the old interpreter) and runs the OpenCores testbenches in Mímir III (7 of 11) with output equal to iverilog; testbench tasks, `force`/`release`, DUT memories by path, testbench-side module instances | works |
| `--vcd-all` (1.5.0): one VCD variable per connected net under the name `write_blif --vtr` gives it, so a waveform joins the VTR netlist and its provenance | works |
| Graphlet instances (1.5.0): `graphlets --instances`, `graphlet_instances` and `graphlet_similarity` in the Python binding | works |
| Silicon flow (1.4.0): Odin III maps to SKY130 cells, OpenROAD (own Tcl, no Yosys) places and routes, KLayout writes GDS, Magic extracts, Netgen checks LVS, a name-free join takes extracted cells back to the HDL; the external tools are optional user-space installs | works on two small designs |
| Provenance step files (1.4.0): a manifest per flow step at every stage (HDL, IR, gates or LUTs, placed, routed, GDS, extracted, recovered) with links and JSON Schemas, from the silicon flow and `odin3-flow --prov`; flows described in the `.o3proj` file (`schema 2`) | works |
| Hierarchical references into another module as undriven nets with a warning (as Yosys); `$tribuf` sole-driver rule in `lower`; `flatten` marks unused modules and plain `write_blif` leaves them out; BLIF type names readable by ABC | works |
| Processor netlists (the Seeker-Proc case) | works |
| Graph features: graphlet and orbit counts, signature comparison, SCOAP testability and signal probability (used by Loki III and Mímir III) | works |
| Netlist editing API and edit events | works |
| Simulation: cycle simulator, toggle counting, derived clocks; testbench interpreter `sim_tb` (plusargs, `%t`, VCD, up to 4096 port connections), `testbench_gen`, `tb-compare`, `run_testbenches` | works (2-state, cycle-based) |
| Reverse-engineering passes (`submod`, `cone_check`, `raise`), the C ABI 7, the cffi Python binding and the plugin registry | works |

(features-wyrd)=
## Wyrd III, Bifrost III and Midgard III (version 0.1.0)

| Feature | Status |
|---|---|
| Experiment runner: `wyrd.toml` projects, sweeps under a memory budget, run directories indexed in `wyrd.db`, `table`, `compare`, critical-path attribution | works |
| Visualization tool: the GUI, schematic and cone views, placement atlas, Mímir browser with HDL heat, path view and Structures tab, Floorplan | optional (`gui`) |
| Bifrost III: simulation bridge over Odin III, `wyrd sim`, Simulate tab, VCD; testbench mode `wyrd tb run\|convert` | optional (`sim`) |
| Midgard III: Verilog Town, a replication of verilogTown | optional (`midgard`) |

(features-loki)=
## Loki III (version 1.0.0)

| Feature | Status |
|---|---|
| L0 ground-truth dataset with Odin III provenance as the answer key, naming-neutral | works |
| L1 Bayesian flow (`loki re`) with calibration, and the ReverseProvenance record for a language model | works |
| Reader for Odin III 1.4 provenance step files: `loki prov`, `resolve()` of any object at any stage back to the HDL | works |
| L2 analysis: export, structural features, clustering, ORCA graphlets, GNN baseline; loss audit; HAL and DANA comparison | works |
| L3 design-pattern census and v0 detector | works |
| L3 anchor-grow-join blocks and the M2 kind guess; graphlet signature matching; Gate-Breaker LLM replication harness (arms A, B, C and follow-ups) | experimental |
| Word-first detector, Bayes-factor stop rule, split step, clustering as the designer's hierarchy | closed |

(features-norns)=
## The Norns III (version 0.9.0, closed 2026-11-03, negative results)

| Feature | Status |
|---|---|
| Known-optimum yardstick (Cong03-style known-optimal clustering examples, the TPEKO idea, from 33 real designs in round 9); gap anatomy; heap studies | works (kept as instruments) |
| The Norns packer, seeding of VPR's anneal, nextpnr viaduct uarch, timing attribution, report and paper generators | works (kept as instruments) |
| Seeding from groupings or clusters, affinity packing, the HDL-aware packer, known-optimal clustering as a route to a better packer, refresh criticality, 2-hop gain, spare room, duplication, hindsight re-clustering, outside placers | closed (did not beat noise) |

(features-lemanruss)=
## Leman Russ III (private repository)

| Feature | Status |
|---|---|
| Hardware Trojan Library (triggers, payloads) with HDL and netlist insertion | works |
| Seeker v2.0 families (Comb and Seq) with obfuscation, release gates, releases with datasheets, and a rareness report | works |
| Seeker-Proc processor pilot | experimental |
| Detector baselines (size-only control, rare-signal, graphlet drift, GNNs) | works |
| Submission format and scorer (hosting not decided) | works |
| Cut-and-stitch for payloads that ABC would remove (in Seeker-Comb rc5 and Seeker-Seq rc6) | works |

(features-mimir)=
## Mímir III (version 0.1.0)

| Feature | Status |
|---|---|
| Circuit knowledge base: one `records` table plus schema 7 tables for designs, meta, lineage, flow configs, runs, timing, per-path timing and the HDL graph | works |
| Measurers: Hutton-style structure, Rent's rule, graphlet totals; importers for Norns, Loki and Odin III flow runs | works |
| Benchmark registry (`suite:design@flow`), content-addressed blobs, snapshots | works |
| `mimir fetch`: local store, archive directory, cache, then URL, sha256 verified; online data at <https://drpeterjamieson.com/RESEARCH/MIMIR/mimir-data> (benchmark index online since 2026-11-02) | works |
| Privacy tools: host aliases, scrubbing, `privacy-check` | works |

(features-verdandi)=
## Verdandi III (version 0.1.0)

| Feature | Status |
|---|---|
| Recorder: a micro Verilog design through the Odin III passes into a trace (snapshot, diff, provenance and code location per step), four-level step tree, ABC commands replayed | works |
| Player: stage map, Verilog, Code, Data and Explanation panes with provenance badges; notes and `check-notes` | optional (`gui`) |
