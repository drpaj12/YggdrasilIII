#!/usr/bin/env bash
# usage-nudge.sh: UserPromptSubmit hook. Reads the numbers usage-statusline.sh saved for this session and, past
# the thresholds, adds a line to the model's context so it asks you to /compact (before 65% context) or /clear at
# a good break point, and warns before the weekly limit. Silent below the thresholds. The model cannot run
# /compact or /clear itself; only you can. Adjust the numbers to your plan.
set -u
in=$(cat)
dir="$HOME/.claude/usage-state"
sid=$(jq -r '.session_id // empty' <<<"$in")
f="$dir/$sid.json"
[ -n "$sid" ] && [ -f "$f" ] || exit 0
ctx=$(jq -r '.ctx // empty | floor' "$f")
week=$(jq -r '.week // empty | floor' "$f")
resets=$(jq -r '.week_resets // empty' "$f")
seen="$dir/$sid.nudged" # bands already announced once
touch "$seen"
msg=""
once() { grep -qx "$1" "$seen" && return 1; echo "$1" >>"$seen"; }
if [ -n "$ctx" ]; then
    if [ "$ctx" -ge 80 ]; then
        msg+="Context ${ctx}%: past the 65% target. Ask the user to /compact now, or /clear after updating the ledger if the task is done. "
    elif [ "$ctx" -ge 65 ]; then
        msg+="Context ${ctx}%: at the 65% target. At the next break point update the ledger and ask the user to /compact. "
    elif [ "$ctx" -ge 50 ] && once ctx50; then
        msg+="Context ${ctx}%: plan a /compact break point before 65%. "
    fi
fi
if [ -n "$week" ]; then
    if [ "$week" -ge 85 ]; then
        msg+="Weekly plan usage ${week}% (resets ${resets:-?}): pause dispatching new lanes around 90%. "
    elif [ "$week" -ge 70 ] && once week70; then
        msg+="Weekly plan usage ${week}% (resets ${resets:-?}): prefer the smaller model and scripts over agents. "
    fi
fi
[ -n "$msg" ] || exit 0
jq -n --arg m "${msg% }" '{hookSpecificOutput: {hookEventName: "UserPromptSubmit", additionalContext: $m}}'
