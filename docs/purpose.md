# Purpose and research questions

Every piece of Yggdrasil III exists for a stated purpose. Each purpose has research questions under
it, and every experiment and every feature answers one of those questions. The hierarchy runs:

- **Why**: the purpose of the suite and of each piece.
- **What**: the research questions that purpose raises.
- **How**: the experiments and features that answer a question.

A new experiment or feature names the question it answers (for example "Norns Q1.1"). An idea that
answers none of them is a new question: it is added here first, under a purpose, or dropped. The
experiment IDs in the tables (L12, N17, ...) are the ones the piece repositories use.

## The measures

The overarching measures of all CAD and chip design are **area**, **speed** and **power**. Each has
subtleties, and a question says which form it uses:

- **Area**: LUT and cell count, CLB count, grid size, channel width (routing area), hard-block use;
  for ASIC-like flows, gate count and gate area.
- **Speed**: critical-path delay and Fmax; the near-critical paths within a stated margin of the
  critical path; slack per path; hold as well as setup; and runtime of the tools themselves where a
  question is about the CAD flow.
- **Power**: dynamic power (switching activity times capacitance, with routed wirelength as a
  proxy for capacitance), static power, and clock power.

Some purposes serve the measures directly (a better packing gives a smaller or faster chip). Others
serve them through understanding: provenance says why a design came out at its area, speed and
power, and where in the HDL to change it. Each purpose below says which.

## The suite

**Suite purpose S1.** Take a design from HDL to a placed and routed chip and keep, for every object
at every step, where it came from, so that the area, speed and power of the result can be traced
back to the HDL that caused them.

**Suite purpose S2.** Be an open research platform for FPGA and ASIC-like CAD, interfaced with VTR
as one of its paths (not built to be comparable with it), and extended through plugins and tools
that never change the core.

## Odin III (trunk)

**Purpose O1.** A replacement for the top end of VTR's CAD flow, the part Yosys plus Parmys does
today: elaboration and front-end synthesis, handing BLIF to VPR. It is not a complete CAD flow.
Correctness of the front end and elaboration comes first.

**Purpose O2.** Provenance as one two-way granularity DAG over the whole CAD flow. The AST is its
upper layer (module, block, branch, statement, expression) and the netlist its lower layer (word,
gate, LUT, then BLE, CLB and site from VPR). Every step records a refinement (one to many) or a
coarsening (many to one); a coarsening that joins two or more distinct constructs is labelled a
join, with why the constructs were joined and how critical they are. Serves all three measures
through understanding.

**Purpose O3.** A platform that tools extend without core changes: a stable binding, plugins, and
outputs (JSON, dot, provenance maps) that other tools read.

| Question | Measure | Experiments and features |
|---|---|---|
| O Q1.1 Which designs does Odin III take through the VTR flow, and how do its area and speed compare with Parmys? | area, speed | QoR sweeps on the VTR benchmarks |
| O Q1.2 Is elaboration correct on every construct the front end accepts? | correctness | micro goldens, equivalence checks, VerilogEval run |
| O Q2.1 Which HDL statements, modules and words set the critical path and Fmax? | speed | critical-path attribution (V1.1.1) |
| O Q2.2 What is the full chain of origin of every netlist object, at every granularity, and which steps joined which constructs? | all | provenance granularity DAG (ADR D14, V1.2.0) |
| O Q2.3 Which constructs drive area and power, not only speed? | area, power | |
| O Q3.1 What must the binding and outputs expose for the side branches to work without core changes? | | ABI, Python binding, name maps |

## Wyrd III (canopy)

**Purpose W1.** Make every experiment reproducible and every result visible: sweeps of designs,
recipes and architectures under a memory budget, with every run kept and indexed.

**Purpose W2.** Show the provenance answers to a person: which HDL lines set area, speed and power,
in a view next to the source.

**Purpose W3.** Give humans a means to interact with the system and see the CAD: run it, look
inside each step, and change what goes in.

| Question | Measure | Experiments and features |
|---|---|---|
| W Q1.1 Can a sweep be rerun from its project file and give the same results? | | `wyrd run`, `wyrd.db` |
| W Q2.1 How does a designer see which lines set the critical path, and which constructs were joined? | speed | timing view over the attribution JSON |
| W Q3.1 What does a person need to see, at each step of the flow, to follow what the CAD did to their design? | | `wyrd-gui`, report per run |

## Bifrost III (canopy)

**Purpose B1.** Simulate the Odin III IR cycle by cycle, so that designs can be checked and played
with without leaving the suite. Switching activity from simulation is also the input power
estimation needs.

| Question | Measure | Experiments and features |
|---|---|---|
| B Q1.1 Does the simulated IR match the HDL's behaviour on the designs the suite uses? | correctness | `wyrd sim`, VCD output |
| B Q1.2 Can recorded activity feed a power estimate of the placed and routed design? | power | |

## Midgard III (canopy)

**Purpose M1.** Teach Verilog through play: the verilogTown game, with each player module compiled
and simulated by Odin III.

| Question | Measure | Experiments and features |
|---|---|---|
| M Q1.1 Does the game run students' modules faithfully and fast enough to play? | | `midgard` |

## Loki III (side branch)

**Purpose L1.** Find out whether we can reverse engineer a circuit.

**Purpose L2.** Go from a low-level, obfuscated, information-lost netlist back to behavioural HDL:
hierarchical, word-level Verilog that is the most readable equivalent of the netlist. Serves
security and understanding rather than a measure.

**Purpose L3.** Say why a construct cannot be recovered: which synthesis or optimisation step fooled
the unmapping, backed by data. Timing-driven and area-driven optimisation are among those steps, so
the answer includes how critical the joined logic was.

| Question | Measure | Experiments and features |
|---|---|---|
| L Q1.1 How much of a circuit's design (function, hierarchy, words, FSMs) can be recovered from its netlist alone? | | L0 to L2 pipeline, experiment rounds 2 and 3 |
| L Q2.1 What is recoverable in principle, per construct kind and per netlist floor (LUT, gate)? | | L14 identifiability and MDL |
| L Q2.2 Which netlist patterns identify which RTL idioms, learned from our own data? | | L12 corpus, signature dictionary, GNN scaling |
| L Q2.3 What patterns appear only in bigger designs, and do they help recovery? | | L13 bigger designs |
| L Q2.4 Can words, control nets and FSMs be found first, and the rest built around them? | | word-first detector; L9 to L11 |
| L Q3.1 For each construct, at which step is it first lost, joined with what, why, and how critical was it? | speed, area | L15 loss audit (on the D14 provenance) |
| L Q3.2 Are constructs on near-critical paths less recoverable than the rest? | speed | L15 loss audit by criticality band |

## The Norns III (side branch)

**Purpose N1.** Find what in the design tells us where to put it on the chip so that it
communicates minimally (wirelength, channel width) and quickly (critical-path delay).

**Purpose N2.** Say what the packer and placer did with the design, and why, in terms of the HDL:
what was clustered together, by which reason, and how critical it was.

**Purpose N3.** Find whether a clustering method built on higher-level ideas (words, statements,
modules, paths that belong together) improves placement.

| Question | Measure | Experiments and features |
|---|---|---|
| N Q1.1 Does seeding the anneal from netlist clusters or from provenance improve placement, and how hot can the anneal start before it destroys the seed? | area, speed | rounds 1 and 2 (after Gharibian et al.) |
| N Q1.3 Do I/O words and stage-by-bit layout tell us where words go? | area, speed | N10, N16 |
| N Q1.4 Does chip size follow HDL hierarchy as designs grow? | area | N13 |
| N Q1.5 Does an RTL-level depth estimate predict which statements set the critical path? | speed | N15 |
| N Q1.6 On designs with a known optimal clustering, how far are the VPR packer and the Norns HDL-aware packer from it, and how does the gap grow with size? | area, speed | known-optimal clustering benchmarks, after the known-optimum placement studies of Cong, Romesis and Xie (ICCAD 2003) |
| N Q2.1 What gets clustered, for which reason (series, shared input, orthogonal, filler, or a hybrid), and how critical is it? | speed, area | N17 packing census |
| N Q2.2 What is reliably true of placements across designs and seeds? | all | N11, N12 knowns |
| N Q3.1 Does packing by higher-level ideas keep HDL structure, and does it improve placement area and speed? | area, speed | N8, N9, N14 Norns packer |
| N Q3.2 Which higher-level ideas are worth clustering by, given what the census says gets clustered today? | area, speed | follows N17 |

## Verdandi III (side branch)

**Purpose V1.** Let another designer understand the CAD flow in all its complexities: from the
micro (one pass on one object) to the macro (the whole flow), on the real current code, with the
provenance of every touched object.

**Purpose V2.** Find a way for a human to start understanding complex software.

| Question | Measure | Experiments and features |
|---|---|---|
| V Q1.1 Can a designer follow one design through every pass and see what each did and why? | | record and replay |
| V Q2.1 What first view of a large program lets a newcomer start to understand it, and what order of steps after that? | | |

## Leman Russ III (side branch)

**Purpose R1.** Detect higher-level structure and anomalies in netlists, including hardware
Trojans, using the Odin III IR, its graph and its provenance, next to Loki III.

| Question | Measure | Experiments and features |
|---|---|---|
| R Q1.1 Which structures in a netlist do not belong to the design it claims to be? | | |
