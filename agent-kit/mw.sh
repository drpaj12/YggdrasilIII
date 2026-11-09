#!/usr/bin/env bash
# mw.sh <owner/repo> <pr> <expected-head-sha>
# Wait for CI on a pull request, then squash-merge it only if every check passed, at least one check really
# passed (a draft-era run where every check is "skipping" is refused) and the head is the reviewed commit.
# Needs the GitHub CLI (gh auth login). Polls every 120 s on purpose: run it as ONE background task and wait
# for its exit notification. Keep it in your workspace, not in /tmp (a restart wipes /tmp).
# If a repository's CI skips documentation-only changes, no checks ever appear: merge those by hand with
#   gh pr merge <pr> -R <owner/repo> --squash --match-head-commit <sha>
R=${1:?usage: mw.sh <owner/repo> <pr> <expected-head-sha>}
PR=${2:?pr number}
SHA=${3:?expected head sha}
cd /tmp || exit 2
while :; do
  out=$(gh pr checks "$PR" -R "$R" 2>/dev/null)
  if [ -n "$out" ] && ! grep -qE $'\t(pending|queued|in_progress)\t' <<<"$out"; then break; fi
  sleep 120
done
date +%H:%M; echo "$out"
head=$(gh pr view "$PR" -R "$R" --json headRefOid -q .headRefOid)
[ "$head" = "$SHA" ] || { echo "HEAD MISMATCH $head != $SHA"; exit 1; }
grep -qE $'\t(fail|cancel)' <<<"$out" && { echo "CHECKS FAILED"; exit 1; }
grep -qE $'\t(pass)\t' <<<"$out" || { echo "NO CHECK PASSED (all skipping?): mark the pull request ready to run CI"; exit 1; }
gh pr merge "$PR" -R "$R" --squash --match-head-commit "$SHA" \
  && gh pr view "$PR" -R "$R" --json state,mergeCommit -q '.state+" "+.mergeCommit.oid'
