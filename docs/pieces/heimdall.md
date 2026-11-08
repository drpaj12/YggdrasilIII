# Heimdall III

The 3D provenance viewer, named for the watchman who sees all nine worlds and guards the Bifrost. It was `o3viz`
inside Wyrd III. One benchmark is a stack of planes: the HDL constructs on top, then the graph views, the Odin III
cells, the LUTs, the clusters and the placed atoms on the FPGA grid. Any measured parameter can colour or size a
plane, and a click on an object lights its column through every plane and the HDL lines behind it. Planes carry a
`target` (`fpga`, `asic` or `common`), so the standard-cell and placed-die planes of the Odin III silicon flow fit the
same viewer.

- Repository: <https://github.com/drpaj12/heimdallIII>
- Documentation: <https://github.com/drpaj12/heimdallIII/blob/main/docs/user/viz.md> and the design in
  <https://github.com/drpaj12/heimdallIII/blob/main/docs/specs/2026-11-05-heimdall-design.md>
- Version: 0.9.0 (tag v0.9.0 of the repository; hub snapshot v1.5.0).
- Place in the tree: the canopy. It sits between Wyrd III, which forwards `wyrd viz` to it, and Mímir III, whose
  catalogue links each design that has a page.
- Commands: `heimdall export`, `heimdall serve` and `heimdall site`, which builds a static site (no server code) of
  many benchmarks for any web host.
- Needs Odin III, VPR and ABC only as programs; the Python package uses the standard library alone.
