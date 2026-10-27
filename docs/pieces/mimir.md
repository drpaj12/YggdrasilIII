# Mímir III

Knowledge base: the circuit dataset to be mined. Mímir III holds the characteristics of designs
(Hutton-style structure statistics and Rent's rule), design meta and lineage (provenance), the flow
configurations and runs that produced each result, and the quality of result per placer family, in
one tidy store where every value records how it was obtained. Its questions are in
{ref}`its section of the purpose page <mimir-purposes>`.

- Repository: <https://github.com/drpaj12/mimirIII>
- Documentation: <https://github.com/drpaj12/mimirIII/tree/main/docs> (specs, draft questions, citations)

## What is built

- Schema version 2: the `records` table of v1 (design, level, metric, value, unit, measurer) plus the
  tables `design`, `design_meta`, `design_lineage`, `flow_config`, `flow_param`, `run`, `partition`
  and `analysis_result`. A v1 store migrates when opened.
- Measurers: the structural characterisation of Hutton (thesis, and Hutton, Rose and Corneil, TCAD
  2002), checked against constructions with known answers and against the published MCNC tables where
  the netlists allow it; and Rent's rule by recursive bisection.
- Importers for the Norns, Loki and atlas data, for MCNC design meta, and for the flow configurations
  and runs behind the stored records.
- An xz blob store for large artifacts, and verified snapshots (an xz SQL dump with a manifest, the
  restore compared byte for byte).

## What is next

- Structures lane (lane 3): the structure and structure-to-mapping tables, filled from the Odin III
  v2 map, prov-post and the Loki detectors (E9).
- The parameter sweep over Odin ABC script, LUT size, architecture, packer options and the five
  placer arms (E10), and clustering analyses over the results (E11).
- Classification, QoR prediction per placer family, and profile-matched generators after the
  papers of Hutton, of Kundarewich and Rose, and of Stroobandt et al.

How it plugs in: it reads the output of Odin III, VTR, The Norns III and Loki III and changes none
of them. Papers it draws on are cited by title and venue in the repository's `docs/CITATIONS.md`.
