# Versions

Each hub snapshot pins one commit of every component (`components/`). The hub tags are v1.1.0, v1.1.1, v1.2.0, v1.4.0 and v1.5.0;
each row is the set of pins at that tag, named after its Odin III release. Wyrd III, Verdandi III and
Mímir III carry the package version 0.1.0 in their `pyproject.toml`. Loki III is at 1.0.0 (tag v1.0.0) and The Norns III at 0.9.0 (tag v0.9.0, a `VERSION` file; closed 2026-11-03). Odin III has releases of its own (tags v1.0.0 to v1.5.0, with GitHub releases carrying the wheel, the source tarball and `SHA256SUMS`).

| Hub snapshot | Odin III | Wyrd III | Loki III | Verdandi III | The Norns III | Mímir III | Heimdall III | Added |
|---|---|---|---|---|---|---|---|---|
| v1.1.0 | 1.1.0 (`bcdd6ba`) | 0.1.0 (`1e328e3`) | 0.1.0 (`bc83f19`) | 0.1.0 (`905ef8e`) | commit `c49d316` | not a component | not a component | The first release snapshot: Odin III 1.1.0 (SystemVerilog through the vendored slang adapter, gate mapping, unmap, the simulation API), the tree picture with three wells, the Loki III, The Norns III and Verdandi III side branches, and a getting-started that installs the release wheel. |
| v1.1.1 | 1.1.1 (`a1cf6ff`) | 0.1.0 (`475c3d8`) | 0.1.0 (`92b5493`) | 0.1.0 (`905ef8e`) | commit `0698983` | not a component | not a component | Odin III 1.1.1 (critical-path attribution to HDL), the Wyrd III timing view, Loki III and The Norns III rounds 4 and 5, and a purpose and research-question section for every piece. |
| v1.2.0 (Odin III 1.2.0) | 1.2.0 (`b01a803`) | 0.1.0 (`a38fe7a`) | 0.1.0 (`3db365b`) | 0.1.0 (`905ef8e`) | commit `61fd41b` | 0.1.0 (`b8b4118`) | not a component | Mímir III as a component and as the fruit in the tree picture, with its dataset hosted at <https://drpeterjamieson.com/RESEARCH/MIMIR/mimir-data>; Odin III 1.2.0 (provenance at every granularity as a two-way DAG, ADR D14, version 2 name maps, `odin3-prov-post`, C ABI 7); the Wyrd III placement atlas and schematic view; Loki III LLM pilot and loss audit; The Norns III placement corpus and run records; home paths removed from Wyrd III and Loki III. |
| v1.4.0 (Odin III 1.4.0) | 1.4.0 (`a46ee9a`) | 0.1.0 (`c3047bb`) | 1.0.0 (`27fd687`) | 0.1.0 (`774e5be`) | 0.9.0 (`151f6ec`) | 0.1.0 (`4ec9dc9`) | not a component | Odin III 1.4.0: the silicon flow (SKY130 cells, OpenROAD, KLayout GDS, Magic, Netgen, a name-free join back to the HDL; no Yosys in the path), flows in the project file (`schema 2`) and provenance step files at every stage (C ABI stays 7); Loki III 1.0.0 (the pipeline, detectors, three endpoints, the Gate-Breaker replica and the Q-L rounds as recorded in its paper, and a reader for the step files, `loki prov`); The Norns III 0.9.0 (the final research state of a closed path); the tree picture with version labels and the silicon flow. |
| v1.5.0 (Odin III 1.5.0) | 1.5.0 (`f0cc33a`) | 0.1.0 (`c3047bb`) | 1.0.0 (`27fd687`) | 0.1.0 (`774e5be`) | 0.9.0 (`151f6ec`) | 0.1.0 (`4cf6019`) | 0.9.0 (`035be43`) | Odin III 1.5.0: `sim_tb` 4-state by default and the OpenCores testbenches run with output equal to iverilog (7 of 11 so far), `--vcd-all` waveforms joined to the VTR netlist, graphlet instances with similarity (C ABI stays 7); Heimdall III 0.9.0 as a component (the 3D provenance viewer, ASIC planes from the silicon flow, graph analytics, switching-activity overlay, graphlet instance lists, benchmark pages); Mímir III with the OpenCores suite (16 projects) and the catalogue view column linking to Heimdall III pages; the tree picture with version labels. |

Release notes of Odin III: [v1.1.0](https://github.com/drpaj12/odin3/blob/main/docs/V1.1.0.md),
[v1.1.1](https://github.com/drpaj12/odin3/blob/main/docs/V1.1.1.md) and
[v1.2.0](https://github.com/drpaj12/odin3/blob/main/docs/V1.2.0.md) and
[v1.4.0](https://github.com/drpaj12/odin3/blob/main/docs/V1.4.0.md) and
[v1.5.0](https://github.com/drpaj12/odin3/blob/main/docs/V1.5.0.md); of Heimdall III: v0.9.0 (tag v0.9.0, `heimdall.__version__`); of Loki III: [v1.0.0](https://github.com/drpaj12/loki/blob/main/docs/V1.0.0.md); of The Norns III: [v0.9.0](https://github.com/drpaj12/nornsIII/blob/main/docs/V0.9.0.md). To see the pins of a snapshot, run
`git ls-tree <tag> components/` in the hub.

## On main now

Read from each repository's `main` on 2026-11-09. Odin III is at 1.6.0 on `main` (C ABI 7; the latest tag is v1.5.1 and the v1.6.0 tag is not made yet),
Heimdall III at 0.9.2 (tag v0.9.2; `heimdall.__version__`), Loki III at 1.0.0 and The Norns III at 0.9.0 (closed). Wyrd III, Verdandi III,
Mímir III and Leman Russ III carry the package version 0.1.0 (`pyproject.toml` of each repository). Leman Russ III is a public repository
(<https://github.com/drpaj12/lemanrussIII>) and a component (`components/lemanruss`); its releases are Seeker-Comb v2.0-rc5, Seeker-Seq v2.0-rc8,
Seeker-Proc v2.0-rc3 and Seeker-Si v2.0-rc2. The submodule pins in `components/` are those of the last hub snapshot (v1.5.0), so they lag the versions
above; the next snapshot row follows the Odin III v1.6.0 tag. What each piece can do is on {doc}`features`, and the outside tools with their versions on {doc}`tools`.
