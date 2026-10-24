# Brief: <lane name>

One page or two. The lane reads this instead of whole specs and transcripts. Push only; the
controller opens the pull request.

## Where

- Worktree: `<ws>/work/<repo>-<lane>`   Branch: `<branch>`   Base: `origin/main` at `<sha>`
- Spec or plan: `<path>` lines <a-b> (read with `sed -n 'a,bp'`, not the whole file)
- Files to touch: <list>
- Data and logs: <paths>

## Job

1. <file:line> <what to do> <expected result>
2. ...

## Gates

- Build: `<command>` (output to a file under `/tmp/<user>-agent/`, read the tail)
- Lint: `<command>`
- Tests: `<command>`
- Docs: `<sphinx-build -W command>`
- Anything else that must be true before the final push (for example: a grep that must be empty).

## Report

Append `## Result` to this brief when done:

- Pushed head per repo (`git ls-remote origin <branch>`, equal to the worktree HEAD).
- Files changed, test counts, gate output summaries.
- Deviations from the brief, with the reason.
- Open issues and anything left for the human.

## Rules

Never commit to `main`; use `git -C` and absolute paths; merge, never rebase; no force push; never
`pkill` or `killall`; kill only PIDs you started; no polling loops on `pgrep`; heavy runs only through
`work/controller-scripts/heavy-lock.sh`; commit and push after each step; do not open pull requests;
do not weaken a lint or test gate; read code by symbol or line range.
Commit trailer: `Co-Authored-By: <the model name Claude Code shows> <noreply@anthropic.com>`
