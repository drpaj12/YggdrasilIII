# YggdrasilIII

The hub of Yggdrasil III: the overall documentation (Sphinx and MyST in `docs/`), the tree picture
(`images/`) and the submodules `components/{odin3,wyrd,heimdall,loki,verdandi,norns,mimir}`, plus `agent-kit/` (templates for driving the suite with Claude Code). The code lives in those repositories; this
one never changes them.

## Build the documentation

    python3 -m venv .venv && .venv/bin/pip install -r requirements-docs.txt
    .venv/bin/sphinx-build -W -b html docs build/docs
    make -C images        # regenerate the tree picture (needs latexmk from the system TeX Live and pymupdf; see images/Makefile)

## Rules

- Never commit to main. Open a PR; merge (squash) only with green CI.
- Docs carry no status words (no built, in progress, planned); a future piece is just named. The one exception is
  `docs/features.md`, whose Noted tables list planned, deferred and dropped items on purpose, with the reason.
- Every command in the docs must exist in the piece's own docs or code; link instead of copying long
  instructions. Bibliography entries come from `odin3/docs/paper/joined.bib`; never invent one.
- Update submodule pins with `git submodule update --remote` and commit them.
- No emojis or em-dashes.
