# Brief: <lane name>

Keep this file under 2 pages. The lane reads this instead of whole specs, plans and transcripts.

## Problem
<2-5 lines: what to build or fix, and why. Name the purpose and the measure.>

## Where
- Worktree: ~/<ws>/work/<dir>   Branch: <branch>   Base: origin/main @ <sha>
- Spec: <path> lines <a-b> (read with `sed -n 'a,bp'`, not the whole file)
- Plan: <path> lines <a-b>
- Files to touch: <list>
- Results and data: <paths of logs, tables, reports>

## Tasks (numbered)
1. <file:line> <what> <expected fix>

## Checks (run in this order; output to files, read only summaries)
- Build: `cmake --build --preset debug > /tmp/<user>-agent/<lane>-build.log 2>&1; tail -3 <log>`
- Lint: `tools/lint.sh > /tmp/<user>-agent/<lane>-lint.log 2>&1; tail -15 <log>`
- Tests: `ctest --preset debug -j6 > /tmp/<user>-agent/<lane>-ctest.log 2>&1; grep -E "tests passed|Failed" <log> | tail -20`
  Then only for failures: `ctest --preset debug -R <name> --output-on-failure | tail -40`

## Rules
Never commit to main; `git -C <path>`, no `cd X && git ...`; merge `origin/main`, never rebase, no force push;
no gate weakening (no NOLINT or noqa to pass a check); kill only processes you started, by PID; heavy runs only
through the heavy lock; never run a formatter over files you did not change; no `until` or `while` loops that poll
with `pgrep -f` (the pattern matches the loop's own command line and it never exits: run the command in the
foreground, or as one background task, and wait for its notification); commit and push after each step; do not open
pull requests unless this brief says so. Read code by symbol or line range, never whole large files; never print
whole netlists, logs or diffs into the context. Commits end with the co-author trailer of your agent.

## Report (the lane appends `## Result` here at the end)
- Head SHA (checked with `git ls-remote origin <branch>`):
- Test counts:
- Deviations:
- Open issues:
