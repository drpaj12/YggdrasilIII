# Verdandi III

Tool & Experiment: the Micro through the Macro. An interactive record-and-replay walk of a micro
Verilog design through Odin III: it records each stage, pass and logged event of a real run, then
replays them as a playthrough with the code that ran, the data structures before and after, and the
HDL provenance of the touched objects at each step.

- Repository: <https://github.com/drpaj12/verdandiIII>
- Manual: <https://drpaj12.github.io/verdandiIII/> (source `docs/user/` in the repository)
- Design and plan: <https://github.com/drpaj12/verdandiIII/tree/main/docs>

How it plugs in: a desktop app in the Wyrd III style (PySide6), with its own package (`verdandi`)
that depends on the `odin3` package like Loki III. It records through the `odin3` Python binding
from the current build and source tree, so the playthrough follows code changes, and it never changes
the Odin III core.
