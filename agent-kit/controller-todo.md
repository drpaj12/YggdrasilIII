# Controller ledger

Newest entries at the bottom. Add a dated line for every dispatch, merge, decision and hand-off.

## Standing decisions
- Lane cap: 2. Review and fix rounds count as a lane.
- Merge on green CI when the remote head equals the reviewed commit.

## Lanes
| Lane | Brief | Worktree | Branch | State | Head |
|---|---|---|---|---|---|
| <name> | briefs/<name>.md | work/<repo>-<lane> | <branch> | running / result in / merged | <sha> |

## Open pull requests
| Repo | PR | Head | CI | Next step |
|---|---|---|---|---|

## Build directories to delete when the PR merges
- work/<repo>-<lane>/build

## Questions for the human
1. <question> (recommended: <answer>)

## Log
- <YYYY-MM-DD HH:MM> <event>
