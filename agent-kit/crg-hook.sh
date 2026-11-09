#!/usr/bin/env bash
# crg-hook.sh: PostToolUse (Edit|Write) hook. Keeps a code-review-graph database current in whichever
# worktree of your repositories was edited (first edit builds it, later edits update it). Runs detached, so the
# agent's tool call is never delayed, and never fails the hook. Needs `pipx install code-review-graph`.
# Set WS to your workspace folder; only worktrees under $WS/<repo>* are handled (edit the case pattern).
WS=${WS:-$HOME/<ws>}
f=$(python3 -I -c 'import json,sys; print(json.load(sys.stdin).get("tool_input",{}).get("file_path",""))' 2>/dev/null)
[ -n "$f" ] || exit 0
command -v code-review-graph >/dev/null 2>&1 || exit 0
top=$(git -C "$(dirname "$f")" rev-parse --show-toplevel 2>/dev/null) || exit 0
case "$top" in "$WS"/odin3*) ;; *) exit 0 ;; esac
# A full graph is large; do not start a new one when the disk is low (on WSL, check /mnt/c).
if [ ! -f "$top/.code-review-graph/graph.db" ]; then
  free_gb=$(df -BG --output=avail "$top" 2>/dev/null | tail -1 | tr -dc 0-9)
  [ "${free_gb:-0}" -ge 15 ] || exit 0
fi
mkdir -p "$top/.code-review-graph"
setsid nohup flock -n "$top/.code-review-graph/.hook.lock" \
  code-review-graph update --skip-flows --repo "$top" >/dev/null 2>&1 </dev/null &
exit 0
