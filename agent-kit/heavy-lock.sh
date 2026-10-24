#!/usr/bin/env bash
# heavy-lock.sh <command...>
# Run one memory-heavy job (a sweep, a large benchmark, a VPR matrix) alone on the machine.
# An exclusive flock(2) on one lock file serialises every caller; the job inherits the lock
# descriptor, so the lock lives as long as the job's processes. Waits up to 4 hours, then exits 77.
# Builds that should not overlap a heavy job can take the same lock shared: flock -s <lockfile> <build>.
# Example:  work/controller-scripts/heavy-lock.sh .venv/bin/wyrd run --project datasets/l0 --jobs 3
set -u
DIR=${HEAVY_DIR:-/tmp/${USER}-agent}
LOCK=$DIR/heavy.lock
mkdir -p "$DIR"
[ "$#" -ge 1 ] || { echo "usage: heavy-lock.sh <command...>" >&2; exit 2; }
exec 9>"$LOCK"
flock -x -w "${HEAVY_WAIT:-14400}" 9 || { echo "heavy-lock: busy for ${HEAVY_WAIT:-14400} s; skipped" >&2; exit 77; }
exec "$@"
