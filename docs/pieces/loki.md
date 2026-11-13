# Loki III

Tool & Experiment: reverse engineering. Reverse engineering of structural netlists (LUT, hard-block and gate-level) back to hierarchical,
word-level Verilog, with a Bayesian hypothesis flow over Odin III's provenance IR. Four levels: L0 builds
labelled, anonymised netlist datasets from Verilog designs, with Odin III provenance as the answer key; L1 is the Bayesian
hypothesis flow (`loki re`); L2 is graph analysis (`loki analyze`: export, structural features, clustering, graphlets, a GNN
baseline); L3 finds design patterns and grows blocks from anchors, with a guess of each block's kind. A Gate-Breaker style
harness tests whether Loki's hints help a language model that has the netlist. Headline (paper): the answer key covers all
54,306 gate nodes of 150 designs, hard adders are recovered 67 of 67, and grown and joined blocks are the right block for 0.715
of 1141 held-out constructs against 0.385 for bounded cones. Clustering does not find the designer's hierarchy, and Loki's
hints did not help a model that already has the netlist.

- Repository: <https://github.com/drpaj12/loki>
- Manual: <https://drpaj12.github.io/loki/> (source `docs/user/` in the repository)
- Specs and plans: <https://github.com/drpaj12/loki/tree/main/docs/specs> and
  <https://github.com/drpaj12/loki/tree/main/docs/plans>
- L0 runbook: <https://github.com/drpaj12/loki/blob/main/docs/runbook-l0.md>; L1 runbook: <https://github.com/drpaj12/loki/blob/main/docs/runbook-l1.md>
- Paper: kept locally by the author (see {doc}`../publications`)
- Experiments: renamed-instance re-run, <https://github.com/drpaj12/loki/blob/main/experiments/rename-l2/EXPERIMENT.md>;
  recovery from the cmos6 gate netlist, <https://github.com/drpaj12/loki/blob/main/experiments/f3-recovery/EXPERIMENT.md>;
  L0 provenance on the VerilogEval refs, <https://github.com/drpaj12/loki/blob/main/experiments/veval-l0/EXPERIMENT.md>
- Odin III 1.4 provenance step files: `loki prov` and `loki.prov_steps.resolve()` read the per-step manifests of a silicon or VTR run and walk any object back to the HDL.
- Reverse provenance: every `loki re` run writes `reverse-provenance.json` (what Loki claims each part
  of the netlist is, with confidence and proof status), and `loki rp doc` turns it into a document to
  hand an LLM with the netlist; see <https://drpaj12.github.io/loki/llm.html>

How it plugs in: a Wyrd III step plugin (`wyrd.steps`) that depends on the `odin3` package and never
changes the Odin III core.
