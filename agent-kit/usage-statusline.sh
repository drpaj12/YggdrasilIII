#!/usr/bin/env bash
# usage-statusline.sh: Claude Code statusLine command for <ws>.
# /usage cannot be captured, but the statusline JSON carries the same numbers:
# context_window.used_percentage and rate_limits.{five_hour,seven_day}.used_percentage.
# Prints a one-line meter and saves the numbers to ~/.claude/usage-state/<session>.json
# and latest.json, so usage-nudge.sh and the controller (cat latest.json) can read them.
set -u
in=$(cat)
dir="$HOME/.claude/usage-state"
mkdir -p "$dir"
sid=$(jq -r '.session_id // "unknown"' <<<"$in")
state=$(jq -c --arg t "$(date -u +%FT%TZ)" '{
    at: $t,
    session_id,
    model: (.model.display_name // .model.id // null),
    ctx: (.context_window.used_percentage // null),
    ctx_size: (.context_window.context_window_size // null),
    five_hour: (.rate_limits.five_hour.used_percentage // null),
    five_hour_resets: (.rate_limits.five_hour.resets_at // null | if type == "number" then todate else . end),
    week: (.rate_limits.seven_day.used_percentage // null),
    week_resets: (.rate_limits.seven_day.resets_at // null | if type == "number" then todate else . end)
}' <<<"$in")
printf '%s\n' "$state" >"$dir/$sid.json.tmp" && mv "$dir/$sid.json.tmp" "$dir/$sid.json"
cp "$dir/$sid.json" "$dir/latest.json.tmp" && mv "$dir/latest.json.tmp" "$dir/latest.json"
jq -r 'def p: if . == null then "-" else (floor | tostring) end;
    "\(.model // "?") | ctx \(.ctx | p)% | 5h \(.five_hour | p)% | wk \(.week | p)%"' <<<"$state"
