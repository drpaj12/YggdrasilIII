# Leman Russ III

Tool & Experiment: HT detection tools. Higher-level detection on netlists, including the detection of hardware Trojans. It works on Odin III's
IR and its graph and provenance data, next to Loki III.

It holds a Hardware Trojan Library (triggers and payloads), insertion at HDL and netlist level, a pipeline of random ABC scripts,
mapping, shuffling and renaming so that no file carries a label, and release gates (witness replay in Odin III, equivalence by ABC,
label-leak checks). The release is Seeker's Dilemma v2.0 (tag `seeker-v2.0`): Seeker-Comb (7,638 circuits, 19 benchmarks), Seeker-Seq (14,474 circuits, 38 benchmarks) and Seeker-Proc (1,200 circuits, three processor cores), each with sets of exactly 100 circuits per target (LUT k=4, LUT k=6, gates, SKY130 standard cells). Detector
baselines find almost nothing on Seeker-Comb and almost everything on Seeker-Seq, which traces to the Trojans' extra flip-flops
and is stated as an open benchmark problem. The repository is public: <https://github.com/drpaj12/lemanrussIII>; released answer keys and generator seeds are not in it.

Forward path for fab-side checking: Odin III 1.4 runs a design to a routed SKY130 layout without Yosys and writes provenance at every stage, so a recovered layout can be joined back to the HDL; inserting a Trojan into spare layout space and showing the check flags it is the next step and is not built.
