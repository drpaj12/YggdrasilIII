# The Norns III

Tool & Experiment: Placement with Provenance. Does seeding VPR's simulated anneal from netlist
clusters (Loki III L2) or from the provenance hierarchy (Odin III) improve placement, and how hot
can the anneal start before it destroys the seed? The placement experiment, after Gharibian et al.
(see {doc}`../publications`), run through Wyrd III on the output of Odin III and VTR.

The project is closed with negative results (2026-10-31). The standard packer uses 22% more wire than a known grouping
over all topologies and 49% more on meshes and trees, but no packing or placement change tried from local, answer-free
information (seeding, affinity packing, an HDL-aware packer, refreshed criticality, a two-hop gain term, spare room,
duplication) gave a speed, wirelength or area gain that stood apart from noise. The known-optimum yardstick and the
instruments are kept. The paper states the numbers and the register of hypotheses.

- Repository: <https://github.com/drpaj12/nornsIII>
- Documentation index: <https://github.com/drpaj12/nornsIII/blob/main/docs/index.md>
- Experiment plan: <https://github.com/drpaj12/nornsIII/blob/main/docs/plan/norns-experiment.md>
- Paper: <https://github.com/drpaj12/nornsIII/tree/main/docs/paper> (IEEEtran, Overleaf-uploadable)
- Measured results (`EXPERIMENT.md`): <https://github.com/drpaj12/nornsIII/blob/main/docs/plan/EXPERIMENT.md>
- Pinned VTR interfaces: <https://github.com/drpaj12/nornsIII/blob/main/docs/plan/vtr-interfaces.md>
- Paper sections on seed construction in detail and on the benchmarks: <https://github.com/drpaj12/nornsIII/blob/main/docs/paper/norns.tex>

How it plugs in: it runs Odin III and VPR (a pinned VTR build) for the baseline and the seeded runs,
and takes the seed clusters from Loki III L2 or from the Odin III provenance hierarchy. It changes none
of them. Its tool setup is in {doc}`../getting-started`.
