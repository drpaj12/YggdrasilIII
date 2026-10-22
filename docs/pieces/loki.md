# Loki III

Reverse engineering of structural netlists (LUT, hard-block and gate-level) back to hierarchical,
word-level Verilog, with a Bayesian hypothesis flow over Odin III's provenance IR. The L0 stage builds
labelled, anonymised netlist datasets from Verilog designs, with Odin III provenance as the answer key.

- Repository: <https://github.com/drpaj12/loki>
- Specs and plans: <https://github.com/drpaj12/loki/tree/main/docs/specs> and
  <https://github.com/drpaj12/loki/tree/main/docs/plans>
- L0 runbook: <https://github.com/drpaj12/loki/blob/main/docs/runbook-l0.md>

How it plugs in: a Wyrd III step plugin (`wyrd.steps`) that depends on the `odin3` package and never
changes the Odin III core.
