# Leman Russ III

Tool & Experiment: HT detection tools. Higher-level detection on netlists, including the detection of hardware Trojans. It works on Odin III's
IR and its graph and provenance data, next to Loki III.

It holds a Hardware Trojan Library (triggers and payloads), insertion at HDL and netlist level, a pipeline of random ABC scripts,
mapping, shuffling and renaming so that no file carries a label, and release gates (witness replay in Odin III, equivalence by ABC,
label-leak checks). The releases are Seeker-Comb v2.0-rc5, Seeker-Seq v2.0-rc6 and a Seeker-Proc pilot of six circuits. Detector
baselines find almost nothing on Seeker-Comb and almost everything on Seeker-Seq, which traces to the Trojans' extra flip-flops
and is stated as an open benchmark problem. The repository is private.
