# Odin III

The trunk of the suite. An open-source (MIT) HDL elaboration and front-end synthesis framework for FPGA
CAD research, the successor to Odin (FPL 2005) and Odin II (FCCM 2010). It reads Verilog-2005, BLIF,
Yosys JSON, structural gate-level Verilog and VPR architecture files into one hierarchical,
provenance-tracked IR, maps it, links ABC for soft logic, and writes BLIF for VPR, LPM Verilog and
dot and JSON for analysis.

- Repository: <https://github.com/drpaj12/odin3>
- Manual: <https://drpaj12.github.io/odin3/> (source `docs/user/` in the repository)
- Paper source: `docs/paper/` in the repository

How it plugs in: Wyrd III runs it as programs (`odin3`, `odin3-flow`); Bifrost III and Loki III use
its Python binding and C ABI. Nothing in the suite changes the Odin III core.
