# Odin III

The trunk of the suite. An open-source (MIT) HDL elaboration and front-end synthesis framework for FPGA
CAD research, the successor to Odin (FPL 2005) and Odin II (FCCM 2010). It reads Verilog-2005, BLIF,
Yosys JSON, structural gate-level Verilog and VPR architecture files into one hierarchical,
provenance-tracked IR, maps it, links ABC for soft logic, and writes BLIF for VPR, LPM Verilog and
dot and JSON for analysis.

- Repository: <https://github.com/drpaj12/odin3>
- Manual: <https://drpaj12.github.io/odin3/> (source `docs/user/` in the repository)
- Paper source: <https://github.com/drpaj12/odin3/tree/main/docs/paper> (`odin3.tex`)
- Release notes v1.6.0 (the vectorless `activity` pass, comparable to ACE 2.0, with `.act` output; `odin3-prov-steps --activity`; the `sim_tb` hard-cell fix; ABI 7): <https://github.com/drpaj12/odin3/blob/main/docs/V1.6.0.md>
- Release notes v1.5.0 (`sim_tb` is 4-state by default and runs the OpenCores testbenches with output equal to iverilog; `--vcd-all` waveforms named as the VTR netlist nets; graphlet instances with similarity; graph views and provenance additions; ABI 7): <https://github.com/drpaj12/odin3/blob/main/docs/V1.5.0.md>
- Release notes v1.4.0 (the silicon flow to a routed SKY130 layout and back with no Yosys, flows described in the project file, provenance step files at every stage; ABI 7): `docs/V1.4.0.md` in the repository
- Release notes v1.2.0 (provenance as a two-way granularity DAG, D14: version 2 name maps,
  `odin3-prov-post`, why-classes and criticality, restore from a map; ABI 7):
  <https://github.com/drpaj12/odin3/blob/main/docs/V1.2.0.md>
- Release notes v1.1.1 (critical-path attribution to HDL: `odin3-flow --timing-attr`, `odin3-timing`):
  <https://github.com/drpaj12/odin3/blob/main/docs/V1.1.1.md>
- Release log v1.1.0 (SystemVerilog through the vendored slang adapter, structural Verilog netlists, the
  VerilogEval run): <https://github.com/drpaj12/odin3/blob/main/docs/V1.1.0.md>
- Release notes v1.0: <https://github.com/drpaj12/odin3/blob/main/docs/RELEASE-NOTES-1.0.md>
- Tokens, models and time spent building it: <https://github.com/drpaj12/odin3/blob/main/docs/log_cost_of_tokens_and_time.md>

How it plugs in: Wyrd III runs it as programs (`odin3`, `odin3-flow`); Bifrost III and Loki III use
its Python binding and C ABI. Nothing in the suite changes the Odin III core.
