# Bifrost III

The simulation bridge, `wyrd.bifrost`, inside Wyrd III. It wraps Odin III's cycle-by-cycle simulator:
it compiles Verilog with `read_verilog; proc; opt; lower`, then gives named inputs and outputs, step,
reset, recording and VCD output. One step is one rising clock edge.

- Repository: <https://github.com/drpaj12/wyrd> (package `wyrd/bifrost`)
- Manual page: <https://github.com/drpaj12/wyrd/blob/main/docs/user/simulation.md>

How it plugs in: it sits on Odin III's simulation API through the `odin3` Python package (the `sim`
extra of Wyrd III, Odin III 1.0.3 or later). The Wyrd III GUI Simulate tab, `wyrd sim` and Midgard III
use it.
