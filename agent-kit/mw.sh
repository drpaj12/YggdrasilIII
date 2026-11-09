#!/usr/bin/env bash
# merge-wait.sh <repo> <pr> <expected-head-sha>
# Wait for CI on a pull request, then squash-merge it only if every check passed and the head is the
# reviewed commit. <repo> is owner/name, for example <owner>/odin3. Needs the GitHub CLI (gh auth login).
# This script polls every 120 s on purpose: run it as one background task and wait for it to exit.
set -u
REPO=${1:?usage: merge-wait.sh <owner/repo> <pr> <expected-head-sha>}
PR=${2:?pr number}
SHA=${3:?expected head sha}
cd /tmp || exit 2
while :; do
  out=$(gh pr checks "$PR" -R "$REPO" 2>/dev/null)
  if [ -n "$out" ] && ! grep -qE $'\t(pending|queued|in_progress)\t' <<<"$out"; then break; fi
  sleep 120
done
date +%H:%M; echo "$out"
head=$(gh pr view "$PR" -R "$REPO" --json headRefOid -q .headRefOid)
[ "$head" = "$SHA" ] || { echo "HEAD MISMATCH $head != $SHA"; exit 1; }
grep -qE $'\t(fail|cancel)' <<<"$out" && { echo "CHECKS FAILED"; exit 1; }
gh pr merge "$PR" -R "$REPO" --squash --match-head-commit "$SHA" \
  && gh pr view "$PR" -R "$REPO" --json state,mergeCommit -q '.state+" "+.mergeCommit.oid'
