# Loki III

Tool & Experiment: reverse engineering. Reverse engineering of structural netlists (LUT, hard-block and gate-level) back to hierarchical,
word-level Verilog, with a Bayesian hypothesis flow over Odin III's provenance IR. The L0 stage builds
labelled, anonymised netlist datasets from Verilog designs, with Odin III provenance as the answer key.

- Repository: <https://github.com/drpaj12/loki>
- Manual: <https://drpaj12.github.io/loki/> (source `docs/user/` in the repository)
- Specs and plans: <https://github.com/drpaj12/loki/tree/main/docs/specs> and
  <https://github.com/drpaj12/loki/tree/main/docs/plans>
- L0 runbook: <https://github.com/drpaj12/loki/blob/main/docs/runbook-l0.md>; L1 runbook: <https://github.com/drpaj12/loki/blob/main/docs/runbook-l1.md>
- Paper: <https://github.com/drpaj12/loki/tree/main/docs/paper> (`loki.tex`, under the Gate-Breaker metrics, with
  every number traced to the experiment records)
- Experiments: renamed-instance re-run, <https://github.com/drpaj12/loki/blob/main/experiments/rename-l2/EXPERIMENT.md>;
  recovery from the cmos6 gate netlist, <https://github.com/drpaj12/loki/blob/main/experiments/f3-recovery/EXPERIMENT.md>

How it plugs in: a Wyrd III step plugin (`wyrd.steps`) that depends on the `odin3` package and never
changes the Odin III core.
