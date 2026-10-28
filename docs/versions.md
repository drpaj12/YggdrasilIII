# Versions

Each hub snapshot pins one commit of every component (`components/`). The hub tags are v1.1.0 and v1.1.1;
the v1.2.0 row is the set of pins on `main`, named after Odin III 1.2.0. Wyrd III, Loki III, Verdandi III and
Mímir III carry the package version 0.1.0 in their `pyproject.toml`. The Norns III has no package version and is
identified by its commit. Only Odin III has releases of its own (tags v1.1.0 and v1.1.1).

| Hub snapshot | Odin III | Wyrd III | Loki III | Verdandi III | The Norns III | Mímir III | Added |
|---|---|---|---|---|---|---|---|
| v1.1.0 | 1.1.0 (`bcdd6ba`) | 0.1.0 (`1e328e3`) | 0.1.0 (`bc83f19`) | 0.1.0 (`905ef8e`) | commit `c49d316` | not a component | The first release snapshot: Odin III 1.1.0 (SystemVerilog through the vendored slang adapter, gate mapping, unmap, the simulation API), the tree picture with three wells, the Loki III, The Norns III and Verdandi III side branches, and a getting-started that installs the release wheel. |
| v1.1.1 | 1.1.1 (`a1cf6ff`) | 0.1.0 (`475c3d8`) | 0.1.0 (`92b5493`) | 0.1.0 (`905ef8e`) | commit `0698983` | not a component | Odin III 1.1.1 (critical-path attribution to HDL), the Wyrd III timing view, Loki III and The Norns III rounds 4 and 5, and a purpose and research-question section for every piece. |
| v1.2.0 (Odin III 1.2.0) | 1.2.0 (`b01a803`) | 0.1.0 (`a38fe7a`) | 0.1.0 (`3db365b`) | 0.1.0 (`905ef8e`) | commit `61fd41b` | 0.1.0 (`b8b4118`) | Mímir III as a component and as the fruit in the tree picture, with its dataset hosted at <https://drpeterjamieson.com/RESEARCH/MIMIR/mimir-data>; Odin III 1.2.0 (provenance at every granularity as a two-way DAG, ADR D14, version 2 name maps, `odin3-prov-post`, C ABI 7); the Wyrd III placement atlas and schematic view; Loki III LLM pilot and loss audit; The Norns III placement corpus and run records; home paths removed from Wyrd III and Loki III. |

Release notes of Odin III: [v1.1.0](https://github.com/drpaj12/odin3/blob/main/docs/V1.1.0.md),
[v1.1.1](https://github.com/drpaj12/odin3/blob/main/docs/V1.1.1.md) and
[v1.2.0](https://github.com/drpaj12/odin3/blob/main/docs/V1.2.0.md). To see the pins of a snapshot, run
`git ls-tree <tag> components/` in the hub.
