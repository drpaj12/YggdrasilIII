# <ws> workspace (controller and lanes)

Start Claude Code in `~/<ws>`. This session is the controller: it plans, writes briefs, dispatches
lanes and merges. Lanes are subagents, one brief each, each in its own git worktree.

At session start, read `work/controller-scripts/HANDOFF.md` section 6 (the hand-off note) and the
bottom of `work/controller-scripts/controller-todo.md` (the ledger) before acting.

## Layout

- `~/<ws>/YggdrasilIII/` the hub; `components/{odin3,wyrd,heimdall,loki,verdandi,norns,mimir,lemanruss}` are its submodules.
  Treat the main checkouts as read-only; never commit in them.
- `~/<ws>/work/<repo>-<lane>/` one git worktree per lane (`git worktree add -b <branch> <path> origin/main`).
- `~/<ws>/work/controller-scripts/` briefs, ledger, hand-off note and helper scripts.
- `~/<ws>/external/` upstream trees such as VTR. Read only.

## Rules

- Never commit to `main`. Lanes push a branch; the controller opens the pull request and squash-merges it
  when CI is green and the remote head equals the reviewed commit.
- Use `git -C <path>` and absolute paths. Update branches by merging `origin/main`, never rebase, never force push.
- Keep at most two or three lanes running. Review and fix rounds count as a lane.
- Memory-heavy runs (sweeps, large benchmarks, VPR matrices) go through `work/controller-scripts/heavy-lock.sh`.
- Temp files go under `/tmp/<user>-agent/`.
- Never wait with a `pgrep -f "<pattern>"` loop: it matches its own command line and never ends. Run the job in the
  foreground or as one background task and wait for its notification.
- Review fixes go to a fresh small lane, never back to a large-context implementer.
- Open pull requests as drafts while work goes on; CI runs once, when the pull request is ready. Merge with `work/controller-scripts/mw.sh`.
- Each repo has its own `CLAUDE.md` with its build, test and lint commands; read it before changing that repo.
- Read code by symbol or line range; do not print whole logs or netlists into the context.
- Do not guess flags, versions or commit hashes; verify them in the code or docs.

## Habits

- Briefs under two pages: Where / Job / Gates / Report / Rules (`work/controller-scripts/briefs/TEMPLATE.md`).
- Lanes commit and push after each step and append `## Result` to their brief when done.
- Ask the human one numbered list of decisions, each with a recommendation.
