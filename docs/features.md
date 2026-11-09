# Features

What each piece of Yggdrasil III does, what is noted but not done, and what it stands on. The sheet follows the
tree picture on the {doc}`index` page: the roots (the outside tools, and the data they feed), the trunk (Odin III),
the canopy (Wyrd III with Bifrost III and Midgard III, and Heimdall III), the side branches (Loki III, Leman Russ III,
Verdandi III), the fruit (Mímir III) and the cut branch (The Norns III).

Each piece has three parts:

- **Implemented**: the feature, the version it came in, and the user page to read. A row is in the piece's
  repository on `main`, with tests, as read from its README, changelog, manual and `--help` on 2026-11-09.
- **Noted**: planned, deferred, known gaps and dropped items, each with the reason. These are not promises.
- **Uses**: the other pieces and the outside tools the piece calls. Tools link to {doc}`tools`, which gives
  each tool's link, the version used here and how it was read.

Versions of the components, and the commit each hub snapshot pins, are on {doc}`versions`. The papers are on
{doc}`publications`; the reason each piece exists is on {doc}`purpose`.

(features-summary)=
## The pieces in one table

| Piece | Version | Repository | Role | Stands on |
|---|---|---|---|---|
| Outside tools | see {doc}`tools` | n/a | The roots: VTR and VPR, ABC, slang, the oracles (Yosys, Parmys, Odin II), the silicon tools | n/a |
| Odin III (trunk) | 1.6.0 on `main` (latest tag v1.5.1) | [odin3](https://github.com/drpaj12/odin3) | HDL elaboration and front-end synthesis with provenance to the HDL text | ABC, slang, Unity, VTR and VPR (target), OpenROAD, KLayout, Magic, Netgen and the SKY130 PDK (silicon flow, optional), iverilog (comparison) |
| Wyrd III (canopy) | 0.1.0 | [wyrd](https://github.com/drpaj12/wyrd) | Experiment runner and GUI | Odin III, VPR, ABC, PySide6, netlistsvg (optional), GTKWave (optional) |
| Bifrost III (in Wyrd III) | 0.1.0 | [wyrd](https://github.com/drpaj12/wyrd) | Simulation bridge, testbench mode and power estimation | Odin III, ACE 2.0 in VTR, VPR power, OpenSTA through OpenROAD, iverilog |
| Midgard III (in Wyrd III) | 0.1.0 | [wyrd](https://github.com/drpaj12/wyrd) | Verilog Town, a replication of verilogTown | Bifrost III, pygame-ce, PySide6 |
| Heimdall III (canopy) | 0.9.2 (tag v0.9.2) | [heimdallIII](https://github.com/drpaj12/heimdallIII) | 3D provenance viewer, static benchmark site | Odin III step files, VPR run directories, three.js (vendored), Mímir III |
| Loki III (side branch) | 1.0.0 | [loki](https://github.com/drpaj12/loki) | Reverse engineering of structural netlists, four levels | Odin III, Wyrd III, ORCA, scikit-learn, torch (optional), Gate-Breaker |
| Leman Russ III (side branch) | 0.1.0 (Seeker-Comb rc5, Seq rc8, Proc rc3, Si rc2) | [lemanrussIII](https://github.com/drpaj12/lemanrussIII) | Hardware Trojan library and the Seeker's Dilemma v2.0 benchmarks | Odin III, ABC, iverilog, Mímir III, OpenROAD and SKY130 (Seeker-Si) |
| Verdandi III (side branch) | 0.1.0 | [verdandiIII](https://github.com/drpaj12/verdandiIII) | Record-and-replay walk of a micro design through Odin III | Odin III, PySide6, Graphviz, ABC |
| Mímir III (fruit) | 0.1.0 | [mimirIII](https://github.com/drpaj12/mimirIII) | Circuit knowledge base and benchmark registry | Odin III, VTR, Loki III, The Norns III, pymetis, pyarrow, SQLite |
| The Norns III (cut branch) | 0.9.0, closed 2026-11-03 | [nornsIII](https://github.com/drpaj12/nornsIII) | Placement with provenance (negative results) | VTR and VPR 9, nextpnr, DREAMPlaceFPGA, OpenPARF, Loki III, Mímir III |

Wyrd III, Bifrost III and Midgard III are one repository and one package (`wyrd`, version 0.1.0 from `pyproject.toml`).
Leman Russ III is a public repository and is a component of the hub (`components/lemanruss`). Its package version is
0.1.0; its releases carry their own names (rc numbers).

(features-roots)=
## Roots: the outside tools

The roots are not code of the suite. They are the programs Odin III reads from and writes to, the oracles it is
measured against, and the silicon tools its second flow calls. The tree picture draws three wells under them
(Mimisbrunnr, prior work; Urdarbrunnr, FPGA CAD and its views; Hvergelmir, synthesis sources). The full list, with
links, versions and what each is needed for, is {doc}`tools`.

| Root | What it is for | Required |
|---|---|---|
| VTR and VPR (with ACE 2.0) | Target flow: pack, place, route, timing, power; vectorless activity for comparison | Optional for Odin III alone; required for `odin3-flow` to a routed result |
| ABC | Soft-logic optimisation and LUT mapping, linked into Odin III | Required (a submodule of Odin III) |
| slang | The SystemVerilog front end, vendored in Odin III | Required (vendored) |
| Yosys, Parmys, Odin II | Oracles to compare against; never in the silicon path | Optional (tests and goldens) |
| OpenROAD (with OpenSTA), KLayout, Magic, Netgen, SKY130 PDK | The silicon flow | Optional |
| Icarus Verilog | Reference simulator for testbenches and gate-level checks | Optional |

(features-odin3)=
## Trunk: Odin III (version 1.6.0 on `main`, C ABI 7)

Manual: <https://drpaj12.github.io/odin3/>. Repository README table: [odin3](https://github.com/drpaj12/odin3#features).
The latest tag is v1.5.1; version 1.6.0 is merged on `main` and its tag is not made yet.

**Implemented**

| Feature | Since | Read |
|---|---|---|
| Inputs: Verilog-2005, BLIF, Yosys JSON, structural gate-level Verilog, VPR architecture files, project files (`.o3proj`, `.qsf`, Odin II) | 1.0 | [inputs](https://drpaj12.github.io/odin3/inputs.html) |
| SystemVerilog through the vendored slang adapter (elaborated AST) | 1.1.0 | [inputs](https://drpaj12.github.io/odin3/inputs.html) |
| Two-stage elaboration and the pass flow: `proc`, `opt`, `fsm`, `flatten`, `wreduce`, `lower`, ABC for soft logic | 1.0 | [passes](https://drpaj12.github.io/odin3/passes.html), [flow](https://drpaj12.github.io/odin3/flow.html) |
| Architecture-driven partial mapping (`hardmap`) and LPM mapping for an Altera-style flow | 1.0 | [passes](https://drpaj12.github.io/odin3/passes.html) |
| Gate mapping (`abc --gates`), `dfflibmap` and `unmap` | 1.1.0 | [passes](https://drpaj12.github.io/odin3/passes.html) |
| `odin3-flow`: one command from Verilog to a routed VPR result or LPM Verilog | 1.0 | [odin3-flow](https://drpaj12.github.io/odin3/odin3-flow.html) |
| Outputs: BLIF (plain and `--vtr`), Yosys JSON, Verilog, dot, RTLIL | 1.0 | [outputs](https://drpaj12.github.io/odin3/outputs.html) |
| Critical-path attribution of a VPR result to HDL lines | 1.1.1 | [timing-attribution](https://drpaj12.github.io/odin3/timing-attribution.html) |
| Provenance at every granularity: a two-way granularity chain with labelled joins, readable from C and Python, version 2 name maps | 1.2.0 | [provenance](https://drpaj12.github.io/odin3/provenance.html) |
| Netlist editing API and edit events (`write_json --odin3`, `write_blif --edit-tags`) | 1.3.0 | [edit](https://drpaj12.github.io/odin3/edit.html) |
| Graphlet and orbit counts (undirected 2 to 5 nodes, directed 2 to 4), own implementation, ORCA only as a test oracle | 1.3.0 | [graphlets](https://drpaj12.github.io/odin3/graphlets.html) |
| SCOAP testability and signal probability per net (`scoap`) | 1.3.0 | [scoap](https://drpaj12.github.io/odin3/scoap.html) |
| Processor netlists (hierarchical, readable by ABC, dead generate branches not elaborated); hierarchical references as undriven nets with a WARNING; the `$tribuf` sole-driver rule | 1.3.0 | [inputs](https://drpaj12.github.io/odin3/inputs.html), [passes](https://drpaj12.github.io/odin3/passes.html) |
| Cycle simulator `sim` (vectors, random inputs, VCD), toggle counting and derived clocks | 1.3.0 | [testbench](https://drpaj12.github.io/odin3/testbench.html), [python-api](https://drpaj12.github.io/odin3/python-api.html) |
| Testbench interpreter `sim_tb`, `testbench_gen`, `tb-compare`, `run_testbenches` (project `testbench` key, up to 16 clocks, plusargs) | 1.1.0 to 1.3.0 | [testbench](https://drpaj12.github.io/odin3/testbench.html) |
| `sim_tb` 4-state by default (`--2state` for the old mode); the OpenCores testbenches in Mímir III with output equal to iverilog (7 of 11); force/release, tb-side instances, DUT memories by path; `--vcd-all` waveforms joined to the VTR netlist | 1.5.0 | [testbench](https://drpaj12.github.io/odin3/testbench.html) |
| Graphlet instances and similarity (`graphlets --instances`, `graphlet_instances`, `graphlet_similarity`) | 1.5.0 | [graphlets](https://drpaj12.github.io/odin3/graphlets.html) |
| Provenance tools at scale: `odin3-prov-steps` streams its steps (340 MB for a 2016-LUT CPU), `write_blif --prov-map` about 20 times faster | 1.5.1 | [provenance-files](https://drpaj12.github.io/odin3/provenance-files.html) |
| Vectorless switching activity per net on the netlist view (`activity`), ACE 2.0 comparable, VPR `.act` output, `odin3-prov-steps --activity` | 1.6.0 | [activity](https://drpaj12.github.io/odin3/activity.html) |
| Silicon flow: SKY130 cells, OpenROAD (own Tcl, no Yosys), KLayout GDS, Magic extraction, Netgen LVS, a name-free join back to the HDL (on two small designs) | 1.4.0 | [silicon-flow](https://drpaj12.github.io/odin3/silicon-flow.html) |
| Provenance step files at every stage with JSON Schemas (`odin3-prov-steps`, `odin3-flow --prov`); flows in the project file (`schema 2`) | 1.4.0 | [provenance-files](https://drpaj12.github.io/odin3/provenance-files.html), [project-flows](https://drpaj12.github.io/odin3/project-flows.html) |
| Analysis: `write_dot` focus and colouring, `levelize`, `write_json --odin3` graph export, `prov-cover` | 1.0 | [analysis](https://drpaj12.github.io/odin3/analysis.html) |
| Reverse-engineering passes `submod`, `cone_check`, `raise` and the RE loop | 1.0 | [re-workflow](https://drpaj12.github.io/odin3/re-workflow.html) |
| C ABI 7, cffi Python binding, plugin loading with an ABI check, `odin3_graph.py` | 1.0 (ABI 7 from 1.2.0) | [python-api](https://drpaj12.github.io/odin3/python-api.html) |
| Releases: source tarball with submodules, `cmake --install`, Python wheel, `SHA256SUMS` | 1.0 | [README](https://github.com/drpaj12/odin3#install) |

**Noted**

| Item | Kind | Reason or detail |
|---|---|---|
| Activity: spatial correlation, reachable states, glitches, multi-clock domains | Known gap | Inputs of a node are taken as independent; a counter or one-hot machine a testbench never leaves needs simulation ([activity](https://drpaj12.github.io/odin3/activity.html), "What it does not know") |
| Activity: a random-vector simulation engine (`sim:N`) behind the same options | Left open | Only the analytic engine exists |
| Activity: feedback components of three OpenCores designs (wb_lcd, sdr_ctrl, vga_lcd) do not reach the tolerance | Known gap | A WARNING says `converged` is false |
| `sim_tb`: `$display` inside the DUT RTL does not run | Known gap | Odin III simulates the synthesised DUT; one line at time 0 differs on mips_16 |
| `sim_tb`: `real`, fork/join, events, `disable`, `defparam` onto DUT instances, `@*`, `specify` in testbenches | Deferred | Four of the 11 OpenCores testbenches (vga_lcd, uart2spi, usbhostslave, sdram_16bit) need them; each is a large feature |
| `sim_tb`: DUT-side tri-state; shifts, divide, modulo and power have no word-level hooks | Known gap | After `lower` they are gate level, so an x shift amount is not IEEE all-x |
| `sim_tb` on an `abc`-mapped netlist when the RTL relies on `if (x)` (wb_lcd) | Known gap | `abc` drops the RTL select attribute; run with `--2state` |
| Silicon flow: only two small designs run; drive strength 1 only; no latches, tri-states or multi-cell outputs; no setup repair or DRC deck; device-level objects not modelled; the join needs the golden run's DEF | Known gap | Limits chapter of [silicon-flow](https://drpaj12.github.io/odin3/silicon-flow.html); OpenROAD is the March 2022 build because it installs without sudo |
| Equivalence that ABC cannot decide on the silicon flow | Known gap | A WARNING, not a stop |
| Power is not measured by Odin III itself | Noted | Power runs through Bifrost III (Wyrd III) and VPR or OpenSTA |
| VQM, EDIF and atom output; CIRCT writer | Dropped | Out of v1 scope (decisions D10, D12 in the repository) |
| The paper (FCCM target) | Planned | Kept by the author; not in the repository |
| Headline: two VTR benchmarks differ from Parmys in multiplier count and five lose adders | Known gap | The equal-or-explained rule against Parmys is not met on every design |
| Comparison with Parmys by default | Rule | Where Odin III and Parmys differ, `--vtr-compat` matches Parmys and prints a WARNING |

**Uses.** Pieces: none (the trunk; every other piece uses it as a package or as programs and none changes it).
Tools: {ref}`ABC <tool-abc>`, {ref}`slang <tool-slang>`, {ref}`Unity <tool-unity>`, {ref}`VTR and VPR <tool-vtr>` (target flow),
{ref}`OpenROAD <tool-openroad>`, {ref}`KLayout <tool-klayout>`, {ref}`Magic <tool-magic>`, {ref}`Netgen <tool-netgen>`
and the {ref}`SKY130 PDK <tool-pdk>` (silicon flow), {ref}`Icarus Verilog <tool-iverilog>` (comparison),
{ref}`Yosys, Parmys and Odin II <tool-oracles>` (oracles only), {ref}`CMake <tool-cmake>`, {ref}`Ninja <tool-ninja>`,
{ref}`gcc and clang <tool-compilers>`, the {ref}`lint tools <tool-lint>` and {ref}`cffi <tool-cffi>`.

(features-wyrd)=
## Canopy: Wyrd III, Bifrost III and Midgard III (version 0.1.0)

Manual: <https://drpaj12.github.io/wyrd/>. Tutorials: [command line](https://drpaj12.github.io/wyrd/wyrd-tutorial.pdf) and
[GUI](https://drpaj12.github.io/wyrd/wyrd-gui-tutorial.pdf).

**Implemented**

| Feature | Version | Read |
|---|---|---|
| Wyrd III: experiment runner. A `wyrd.toml` project of designs, recipes and architectures expands to runs under a memory budget; run directories kept and indexed in `wyrd.db`; `table`, `compare`, `script`, `status` | 0.1.0 | [projects](https://drpaj12.github.io/wyrd/projects.html), [running](https://drpaj12.github.io/wyrd/running.html) |
| Wyrd III: machine settings with a fixed precedence (`wyrd config init\|show`); step types `odin3`, `vpr`, `abc`, `shell`, `odin3-flow` and plugin steps registered as entry points | 0.1.0 | [projects](https://drpaj12.github.io/wyrd/projects.html) |
| Wyrd III: critical-path attribution (`wyrd timing`, Timing panel); three sample projects with expected results | 0.1.0 | [samples](https://drpaj12.github.io/wyrd/samples.html) |
| Wyrd III: desktop GUI with project tree, source, report, `wyrd.toml` editor with live validation and flow runner (extra `gui`) | 0.1.0 | [gui](https://drpaj12.github.io/wyrd/gui.html) |
| Wyrd III: schematic and cone views, the Norns placement atlas, the Mímir browser with HDL heat, path view, Structures and Timing tabs, Floorplan button | 0.1.0 | [gui](https://drpaj12.github.io/wyrd/gui.html), [mimir](https://drpaj12.github.io/wyrd/mimir.html) |
| Wyrd III: `wyrd viz` forwards to Heimdall III (optional extra `viz`) | 0.1.0 | [viz](https://drpaj12.github.io/wyrd/viz.html) |
| Bifrost III: compile Verilog with Odin III, set inputs, step, reset, record, VCD; `wyrd sim`; Simulate tab (extra `sim`) | 0.1.0 | [simulation](https://drpaj12.github.io/wyrd/simulation.html) |
| Bifrost III testbench mode: `wyrd tb run\|convert` on RTL, netlist or both | 0.1.0 | [testbench](https://drpaj12.github.io/wyrd/testbench.html) |
| Bifrost III power: switching activity from a design's testbench, from Odin III's vectorless pass or from ACE 2.0 goes into VPR `--power` (FPGA) and OpenSTA through OpenROAD (ASIC), joined to HDL lines (`wyrd power run`); 48 designs have power rows | 0.1.0 | Spec `docs/specs/2026-11-06-bifrost-power-design.md` in the repository |
| Midgard III: Verilog Town, a close replication of verilogTown with a Verilog editor and a level editor (extra `midgard`) | 0.1.0 | [midgard](https://drpaj12.github.io/wyrd/midgard.html) |

**Noted**

| Item | Kind | Reason or detail |
|---|---|---|
| Bifrost III power: no user-manual page | Gap | The method, limits and pilot results are in the spec and `docs/power/` only |
| Bifrost III power skips: sha3 does not route at channel width 100, vga_lcd is multi-clock (VPR power is single-clock), ethmac is over the memory cap | Known gap | Reasons per design in the power run records |
| Bifrost III: ASIC-side names for Heimdall III joins (instance and net columns) | Planned | Follow-up from the power lane |
| Bifrost III simulator (S1): clocks must be top-level inputs; a signal removed by `remove` needs `(* keep *)`; a port that mixes clock and data use is not supported; the VCD samples once per step | Known gap | Stated in the manual |
| Floorplan button needs a VPR built with Qt6 graphics | Optional | Otherwise the Flow log says so |
| Schematic needs netlistsvg (Node.js), not bundled; modules over 300 cells are not drawn | Optional | Limits measured in `docs/specs/2026-10-26-schematic-view.md` |
| Midgard III deviations from the original | Noted | Listed in section 13 of the W4 design spec; the original wins |
| A separate Wyrd III paper | Dropped | Wyrd III has no paper of its own |

**Uses.** Pieces: Odin III (package and programs), Heimdall III (optional viewer), Loki III (registers step plugins),
Mímir III (the browser reads its store). Tools: {ref}`VPR <tool-vtr>`, {ref}`ABC <tool-abc>`, {ref}`ACE 2.0 <tool-vtr>`,
{ref}`OpenROAD and OpenSTA <tool-openroad>` (ASIC power), {ref}`Icarus Verilog <tool-iverilog>` (gate-level activity),
{ref}`PySide6 <tool-pyside6>`, {ref}`pygame-ce <tool-pygame>`, {ref}`netlistsvg <tool-netlistsvg>` (optional) and
{ref}`GTKWave <tool-gtkwave>` (optional).

(features-heimdall)=
## Canopy: Heimdall III (version 0.9.2)

Manual: [viz](https://github.com/drpaj12/heimdallIII/blob/main/docs/user/viz.md), and the viewer's own help page (key `?`).

**Implemented**

| Feature | Version | Read |
|---|---|---|
| 3D provenance viewer: a benchmark as a stack of planes (HDL, graph views, cells, LUTs, clusters, placed atoms) with every object linked to its HDL line; `heimdall export`, `serve` | 0.9.0 | [viz](https://github.com/drpaj12/heimdallIII/blob/main/docs/user/viz.md) |
| Static site of benchmarks (`heimdall site`), no server code; the Mímir III catalogue links each design that has a page | 0.9.0 | [README](https://github.com/drpaj12/heimdallIII#the-site) |
| ASIC planes from the silicon flow; graph analytics (signatures, clusterings, graphlet types, graphlet instances) | 0.9.0 | [viz](https://github.com/drpaj12/heimdallIII/blob/main/docs/user/viz.md) |
| Switching-activity overlay from Bifrost III power data, Odin III's vectorless pass or ACE 2.0, on every page that has data | 0.9.1 | [viz](https://github.com/drpaj12/heimdallIII/blob/main/docs/user/viz.md) |
| Large-design pages: the a-z80-modified CPU page (link cap of 64 per object) and OpenCores pages | 0.9.1 | [viz](https://github.com/drpaj12/heimdallIII/blob/main/docs/user/viz.md) |
| Pages ordered by complexity tier (micros, VerilogEval, small VTR, OpenCores, big VTR) with simpler and more complex links | 0.9.2 | [viz](https://github.com/drpaj12/heimdallIII/blob/main/docs/user/viz.md) |
| Phone use: pinch zoom, two-finger pan, panels collapsed on narrow screens, 48 px controls; headless touch check | 0.9.2 | [viz](https://github.com/drpaj12/heimdallIII/blob/main/docs/user/viz.md) |
| Built-in help page with shortcut table and 47 screenshots retaken from real runs | 0.9.0 | [viz](https://github.com/drpaj12/heimdallIII/blob/main/docs/user/viz.md) |

**Noted**

| Item | Kind | Reason or detail |
|---|---|---|
| Three pages have weak activity-to-object name joins (sha3_high about 5%, mips_16 about 70%, attiny about 82%) | Known gap, being rebuilt | Their bundles came from other flow runs; they are rebuilt in 0.9.3 |
| Big-VTR tier order is by LUT count; `sha` follows `dblclockfft` | Optional | Sorting that tier by size is a later change |
| ASIC exporter beyond the silicon-flow planes | Noted | The target is built into the design (FPGA, ASIC or both); the early stub is replaced for the silicon flow only |
| Per-LUT cell lineage on a very large design | Known gap | Provenance of the a-z80 run is capped at 64 links per object |
| STG transitions are not attributed to one case item | Known gap | Odin III does not record it ("Limits" in the manual) |
| Slack-weighted atom ordering | Not yet | Atoms are ordered by worst slack within a cluster, not weighted by it |
| Hosting | Not done by the tools | The built site is uploaded by hand; nothing is uploaded by the tools |

**Uses.** Pieces: Odin III (step files, run directories), Wyrd III (power data, `wyrd viz` forwarder), Mímir III (the
catalogue). Tools: {ref}`VPR <tool-vtr>` (read as run directories), {ref}`three.js <tool-threejs>` (vendored),
{ref}`Playwright and Chromium <tool-playwright>` (optional checks), {ref}`Python <tool-python>`.

(features-loki)=
## Side branch: Loki III (version 1.0.0)

Manual: <https://drpaj12.github.io/loki/>.

**Implemented**

| Feature | Version | Read |
|---|---|---|
| L0 ground-truth dataset: Odin III provenance as the answer key, three floors, anonymised names, `cell_type` labels in `graph.json` (`loki bench`, `assemble`, `check`) | 1.0.0 | [dataset](https://drpaj12.github.io/loki/dataset.html) |
| Naming-neutral answer key (names only in `key.json`; the renamed re-run over 105,646 identifiers) | 1.0.0 | [formats](https://drpaj12.github.io/loki/formats.html) |
| L1 Bayesian flow `loki re`: detectors, provers, commit with `raise` and `submod`, the `hard` detector; calibration, `re-project`, `score` | 1.0.0 | [hypotheses](https://drpaj12.github.io/loki/hypotheses.html) |
| `loki rp`: run record for Mímir III and the ReverseProvenance output for a language model | 1.0.0 | [llm](https://drpaj12.github.io/loki/llm.html) |
| Reader for Odin III provenance step files: `loki prov` resolves any object at any stage to the HDL | 1.0.0 | [provenance-steps](https://drpaj12.github.io/loki/provenance-steps.html) |
| L2 analysis: graph export (edge list, GraphML, PyG), structural features, clustering (k-means, affinity propagation, spectral, Louvain), ORCA graphlets, GNN baseline | 1.0.0 | [hypotheses](https://drpaj12.github.io/loki/hypotheses.html) |
| Loss audit (the pass at which each construct is lost); HAL and DANA comparison harness | 1.0.0 | [results](https://drpaj12.github.io/loki/results.html) |
| L3 design-pattern census and v0 detector (catalogue under `loki/l3/catalogue`) | 1.0.0 | L3 spec in the repository |
| Gate-Breaker LLM replication harness (arms A, B, C and follow-ups) and calibrated intent claims | 1.0.0 (experiments) | [llm](https://drpaj12.github.io/loki/llm.html) |
| L3 anchor-grow-join blocks and the M2 kind guess; graphlet signature matching; block-by-block decode (Q-L10) | 1.0.0 (experiments) | `experiments/` in the repository |
| Wyrd III step plugins (`loki-dataset`, `loki-re`, `loki-export`, `loki-cluster`, `loki-graphlets`, `loki-gnn`) | 1.0.0 | [install](https://drpaj12.github.io/loki/install.html) |

**Noted**

| Item | Kind | Reason or detail |
|---|---|---|
| Word-first detector and word-group detector | Dropped | Lost to DANA; opt-in, off by default |
| Bayes-factor stop rule, stop rules, split step, clustering as the designer's hierarchy | Dropped or inconclusive | Did not help (paper table "what did not work") |
| M2 kind guess (macro F1 0.392) | Known gap | The weakest part of the pipeline |
| Graphlet signature matching on whole designs | Inconclusive | No pattern reaches 0.80 |
| Loki's hints for a language model | Dropped | Added nothing to a model that already has the netlist |
| State-machine encoding rule FSM3 | Dropped | Precision 0.676 |
| Trojan detection | Out of scope | That is Leman Russ III |
| Block decode on designs too big for one prompt | Noted | 3 of 4 decode; no model call in the repository, replies came from the controller |
| Paper | Kept locally | Not in the repository |

**Uses.** Pieces: Odin III (package, `raise`, `submod`, step files), Wyrd III (step plugins), Mímir III (run records),
Leman Russ III (bases and the detector comparison), The Norns III (L2 clusters seeded it). Tools: {ref}`ORCA <tool-orca>`
(pinned fetch), {ref}`scikit-learn, scipy, numpy and networkx <tool-pydeps>`, {ref}`torch and torch_geometric <tool-torch>`
(GNN, optional), {ref}`Gate-Breaker and VerilogEval <tool-gatebreaker>` (data), {ref}`HAL and DANA <tool-hal>` (comparison).

(features-lemanruss)=
## Side branch: Leman Russ III (public repository)

Repository: <https://github.com/drpaj12/lemanrussIII> (public since 2026-11-09). User docs:
[docs/user](https://github.com/drpaj12/lemanrussIII/blob/main/docs/user/README.md) and the
[scoring manual](https://github.com/drpaj12/lemanrussIII/blob/main/docs/user/SCORING-MANUAL.md). Defensive research: the
circuits are Trojans to detect. Released answer keys, generator seeds and per-circuit labels are not in the repository.

**Implemented**

| Feature | Release | Read |
|---|---|---|
| Hardware Trojan Library: triggers (rare-value AND, counter, FSM pattern, always-on, input pattern) and payloads (denial of service, error insertion, energy, slow-down) with legality checks | v2.0 | [docs/user](https://github.com/drpaj12/lemanrussIII/blob/main/docs/user/README.md) |
| Insertion at HDL level and at netlist level (Odin III edit-API recipes, each object tagged `trojan:<id>`) | v2.0 | `lemanruss insertion`, `prov-demo` |
| Rare-site selection from signal probability and SCOAP | v2.0 | `lemanruss/htl/sites.py` |
| Seeker-Comb v2.0-rc5: 5,809 circuits on 31 bases, three mapping sets (LUT k=4, LUT k=6, AND/OR/NOT) | rc5 | `releases/` |
| Seeker-Seq v2.0-rc8: 11,005 circuits on 38 bases (the 36 of rc7 plus the OpenCores ca_prng and i2c); no Trojan flip-flops | rc8 | `releases/`, `docs/results-seq-rc8.md` |
| Seeker-Proc v2.0-rc3: processor images lowered to netlists on the four public bases darkriscv, mcu, mips_16 and picorv32, with regions and levels | rc3 | `releases/`, spec `2026-11-06-seeker-proc-rc3.md` |
| Seeker-Si v2.0-rc2: standard-cell (SKY130) forms of Comb, Seq and Proc circuits, place-and-route of a stratified subset. A new set, not compared per base with the other families | rc2 | `docs/results-si-rc2.md` |
| Obfuscation: 18 ABC restructuring scripts and the three mapping sets; cut-and-stitch so energy and slow-down payloads survive ABC | v2.0 | `lemanruss restructure` |
| Verification and release gates: witness replay in Odin III, equivalence by ABC, label-leak gates, datasheets and checksums | v2.0 | `lemanruss verify`, `release` |
| Rareness report: trigger activation probability per circuit and pooled | v2.0 | `lemanruss/htl/rareness.py` |
| Detector baselines: size-only control, rare-signal, graphlet drift, GNNs, class histogram; three-level scorer with localisation | v2.0 | `docs/results-detectors.md` |
| Submission format and scorer (CSV per subset, aggregate report that does not publish the key; subsets, regions, anonymisation) | v2.0 | [SUBMISSION](https://github.com/drpaj12/lemanrussIII/blob/main/docs/user/SUBMISSION.md) |
| RTL testbenches against iverilog, energy-payload toggle counts, bases from the Mímir III registry | v2.0 | `lemanruss rtl-tb`, `energy`, `bases` |

**Noted**

| Item | Kind | Reason or detail |
|---|---|---|
| Detectors not rerun on Seq rc8 | Planned | The rc7 results are carried |
| The i2c K6 mapping set was dropped in rc8 | Deferred | A combinational loop or undriven net at the release draw; not reproduced on the clean base, so it can join a later round |
| The family builder drops the whole set when one proposal fails | Planned change | Drop only the failing proposal |
| Seeker-Si: P&R stalls on designs of 1,000 to 1,999 cells; a 60-minute cap applies, so results are biased toward small designs | Known gap | Rule off, no retry after the cap |
| Seeker-Si: Trojan count split (1, 2, 3) missing from the rc2 results | Gap | Not tabulated |
| Seeker-Proc: four circuits per pilot, magic-word triggers only | Noted | A pilot; the family grows with bases |
| Copyleft OpenCores bases (GPL, LGPL) left out of public releases | Dropped | Only permissively licensed bases are admitted; the reasons are in the datasheet |
| Scoring service hosting | Open | The GitHub Actions packaging is an example only |
| Fab-side check: insert a Trojan into spare layout and show the check flags it | Planned | Needs the silicon path of Odin III; not built |
| Paper | Kept locally | Not in the repository |

**Uses.** Pieces: Odin III (edit API, `sim_tb`, step files), Mímir III (base circuits, registry), Loki III (graph features
for baselines). Tools: {ref}`ABC <tool-abc>`, {ref}`Icarus Verilog <tool-iverilog>`, {ref}`OpenROAD <tool-openroad>` and the
{ref}`SKY130 PDK <tool-pdk>` (Seeker-Si place and route), {ref}`numpy <tool-pydeps>`, {ref}`torch and torch_geometric <tool-torch>`
(GNN detectors, optional).

(features-verdandi)=
## Side branch: Verdandi III (version 0.1.0)

Manual: <https://drpaj12.github.io/verdandiIII/>.

**Implemented**

| Feature | Version | Read |
|---|---|---|
| Recorder `verdandi record`: a micro design through the Odin III passes into a trace (source, snapshot per step, diff, provenance spans, code location, log lines) | 0.1.0 | [manual](https://drpaj12.github.io/verdandiIII/) |
| Four-level step tree: stage, pass, sub-step, event | 0.1.0 | [manual](https://drpaj12.github.io/verdandiIII/) |
| ABC stage opened into its commands with node counts and graph pictures (standalone ABC binary) | 0.1.0 | [manual](https://drpaj12.github.io/verdandiIII/) |
| Player `verdandi play`: stage map, Verilog, Code, Data and Explanation panes, Diff strip, provenance badges (extra `gui`) | 0.1.0 | [manual](https://drpaj12.github.io/verdandiIII/) |
| Shipped notes explaining the stages; `check-notes` against the current Odin III source; `info` | 0.1.0 | [manual](https://drpaj12.github.io/verdandiIII/) |
| Five examples and a script that records all five; size guard and deterministic snapshots | 0.1.0 | `examples/record-all.sh` |

**Noted**

| Item | Kind | Reason or detail |
|---|---|---|
| A trace records a run; it does not follow later code changes | Known gap | Rerun `verdandi record`, then `check-notes` |
| The Code pane needs an Odin III source tree; the graph picture needs Graphviz | Optional | Not needed to replay a saved trace |
| Without a standalone ABC binary the ABC stage is one step | Optional | Stated in the manual |
| A paper or measured result | Dropped | A teaching and inspection tool, not an experiment |

**Uses.** Pieces: Odin III (the `odin3` binding at record time and the source tree for the Code pane). Tools:
{ref}`PySide6 <tool-pyside6>`, {ref}`Graphviz <tool-graphviz>`, {ref}`ABC <tool-abc>` (standalone), {ref}`Python <tool-python>`.

(features-mimir)=
## Fruit: Mímir III (version 0.1.0)

Documentation: specs in `docs/specs/` of the [repository](https://github.com/drpaj12/mimirIII), and
[data access](https://github.com/drpaj12/mimirIII/blob/main/docs/data-access.md). Data: <https://drpeterjamieson.com/RESEARCH/MIMIR/mimir-data>.

**Implemented**

| Feature | Version | Read |
|---|---|---|
| Circuit knowledge base: one `records` table plus schema 7 tables (design, meta, lineage, flow config, run, partition, timing, per-path timing, HDL graph); CSV and Parquet export; migration on open | 0.1.0 | `mimir init`, `export`, `migrate` |
| Importers for Norns runs, Loki runs, Odin III flow output and run records | 0.1.0 | `mimir import`, `import-runs`, `import-flow` |
| Measurers: Hutton-style structure, Rent's rule (METIS through pymetis), opt-in graphlet orbit totals | 0.1.0 | `mimir measure`, `measure-set` |
| Near-critical and per-path timing tables; line-level HDL graph | 0.1.0 | `mimir import-timing`, `hdl-graph` |
| Structures and detector report (Loki detectors on stored BLIFs, precision and recall) | 0.1.0 | `mimir detect`, `report` |
| Benchmark registry `suite:design@flow` with upstream URL, commit and licence per suite; content-addressed xz blob store; snapshots restored byte for byte | 0.1.0 | `mimir bench`, `blob`, `snapshot` |
| OpenCores suite of 16 projects and their testbenches in the registry; the catalogue with a view column linking Heimdall III pages | 0.1.0 | `docs/benchmarks/opencores.md` |
| Power columns from Bifrost III runs (32 designs, FPGA and ASIC) | 0.1.0 | `mimir bench` power rows |
| `mimir fetch`: local store, archive directory, cache, then URL, sha256 verified; online benchmark index | 0.1.0 | [data-access](https://github.com/drpaj12/mimirIII/blob/main/docs/data-access.md) |
| Privacy tools: host aliases, scrubbing, `mimir privacy-check`; merging stores; coverage reports; metric registry and citations | 0.1.0 | `mimir host-alias`, `privacy-check`, `merge`, `registry` |

**Noted**

| Item | Kind | Reason or detail |
|---|---|---|
| Odin micros suite (the `bm_*` designs) with power rows | In progress | 15 micro rows in the power runs are not yet in the registry |
| Vectorless activity column (Odin III `activity`) next to the testbench and ACE 2.0 columns | In progress | Follows Odin III 1.6.0 |
| 16 further power rows from the power run directory | Planned | Not yet collected into the store |
| No manual index page | Gap | The specs are the reference |
| Graphlet measurer values must not be stored as real until the Odin III `$sop`/`$lut` graph fix is confirmed on `main` | Caution | Stated in the README |
| `mimir bench catalogue` check `test_repo_cells_not_cut` | Known issue | Failed once on `main`; not reproduced |
| Made-up benchmarks (Norns synthetic sets, Loki families, Seeker releases) | Not Mímir's | They stay with the tool that made them |
| Hosting of the data | Author's decision | Files are uploaded by hand; the repository holds an index |
| Own paper | Dropped | Mímir III reports no finding of its own |

**Uses.** Pieces: Odin III (graphlet measurer, flow output), Loki III (detectors), The Norns III (run import), Wyrd III
(power runs, browser), Leman Russ III (registered bases), Heimdall III (catalogue links). Tools: {ref}`pymetis <tool-pydeps>`,
{ref}`pyarrow <tool-pydeps>`, {ref}`numpy <tool-pydeps>`, {ref}`SQLite <tool-sqlite>`, {ref}`xz <tool-xz>`, {ref}`VTR <tool-vtr>`
(benchmarks and flows), {ref}`OpenCores and third-party suites <tool-benchmarks>`.

(features-norns)=
## Cut branch: The Norns III (version 0.9.0, closed 2026-11-03)

Closed with negative results; the frozen state is kept as instruments and a record. Plan and results:
[docs](https://github.com/drpaj12/nornsIII/tree/main/docs); release notes
[V0.9.0](https://github.com/drpaj12/nornsIII/blob/main/docs/V0.9.0.md).

**Implemented (kept as instruments)**

| Feature | Version | Read |
|---|---|---|
| Known-optimum yardstick (Cong03-style known-optimal clustering examples, the TPEKO idea, from 33 real designs); gap anatomy; heap studies | 0.9.0 | `docs/plan/round9-tpeko-real.md` |
| Instrumented packer (VPR AAPack and APPack at a pinned commit with a provenance-affinity term); seeding of VPR's anneal from a clustering | 0.9.0 | `docs/plan/norns-experiment.md` |
| Placement corpus and run records; timing attribution; report and paper generators | 0.9.0 | `docs/plan/EXPERIMENT.md` |
| nextpnr "viaduct" uarch for the VTR k6 grid, as an overlay (nextpnr is not forked or vendored) | 0.9.0 | `placers/nextpnr_k6/` |

**Noted**

| Item | Kind | Reason or detail |
|---|---|---|
| Seeding from groupings or clusters, affinity packing, the HDL-aware packer, refreshed criticality, two-hop gain, spare room, duplication, hindsight re-clustering, outside placers | Closed | None beat noise (geomean speed change between -2.1% and +0.7%) |
| Known-optimal clustering as a route to a better packer | Closed | Did not help |
| HDL-aware packer first result (0.902 wirelength ratio) | Dropped | It was a leak; with realistic registers it used 65% to 150% more wire |
| DREAMPlaceFPGA and OpenPARF runs | Not run | Planned as separate tools after approval; never vendored |
| Reopening the path | Noted | `docs/plan/STATUS.md` says how |

**Uses.** Pieces: Loki III (L2 clusters), Odin III (provenance hierarchy), Mímir III (receives its runs). Tools:
{ref}`VPR 9 <tool-vtr>` (commit pinned), {ref}`nextpnr <tool-placers>`, {ref}`DREAMPlaceFPGA <tool-placers>`,
{ref}`OpenPARF <tool-placers>`, {ref}`scikit-learn and networkx <tool-pydeps>`.
