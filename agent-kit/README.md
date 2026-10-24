# Agent kit

Templates for driving Yggdrasil III with Claude Code as a controller session with lane subagents.
Copy them into your workspace and fill the placeholders. The method is described in
`docs/agent-controller.md` (published at <https://drpaj12.github.io/YggdrasilIII/agent-controller.html>).

| File | Copy to | Purpose |
|---|---|---|
| `CLAUDE.md` | `<ws>/CLAUDE.md` | Workspace instructions: repos, layout, what to read first |
| `HANDOFF.md` | `<ws>/work/controller-scripts/HANDOFF.md` | How to leave and start a controller session; the hand-off note |
| `controller-todo.md` | `<ws>/work/controller-scripts/controller-todo.md` | The ledger: lanes, PRs, decisions |
| `briefs/TEMPLATE.md` | `<ws>/work/controller-scripts/briefs/TEMPLATE.md` | One brief per lane |
| `merge-wait.sh` | `<ws>/work/controller-scripts/merge-wait.sh` | Wait for CI, then squash-merge one PR |
| `heavy-lock.sh` | `<ws>/work/controller-scripts/heavy-lock.sh` | Run one memory-heavy job at a time |

Placeholders: `<ws>` the workspace folder, `<user>` your login name, `<owner>` the GitHub account that
owns the repositories. The kit holds no credentials; log in with `claude` and `gh auth login`.
