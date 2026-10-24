# Hand-off between controller sessions

A controller session ends when its context or your plan quota runs out, or when you stop work. This file
says how to leave a session cleanly and how to start the next one, so no lane or decision is lost.
Background agents, merge waiters and heavy runs are children of the session and die with it.

## 3. Where the context lives (read in this order)

1. `~/<ws>/CLAUDE.md` (loaded on its own) and the `CLAUDE.md` of each worktree (repo rules).
2. Your memory files, if you keep any (`~/.claude/projects/<project>/memory/MEMORY.md` is loaded on its own).
3. `work/controller-scripts/controller-todo.md`: the ledger. Newest entries at the bottom. It covers
   lanes, worktrees, open pull requests, the heavy queue and your decisions.
4. Section 6 of this file: the hand-off note from the last session.
5. Lane reports: the `## Result` section at the end of each brief in `work/controller-scripts/briefs/`.
6. Git: `gh pr list -R <owner>/<repo>`, `git -C ~/<ws>/<repo> worktree list`, and for each lane worktree
   `git -C <worktree> status --short` and `git -C <worktree> log --oneline -3`.

## 4. Steps: leaving a session

Decide a threshold in advance (for example: at 90% of the weekly quota the controller stops dispatching
new lanes and tells you; at about 95% you ask for a hand-off). Draining takes 30 to 60 minutes of lane
time, so do not wait past it.

1. Tell the controller: "Prepare a hand-off."
2. The controller then:
   1. Stops dispatching new work.
   2. Lets each running lane finish its current step, commit and push. It checks that
      `git ls-remote origin <branch>` equals each worktree HEAD, and stops any agent that cannot finish
      soon (unpushed work is noted).
   3. Lets the merge waiters (`merge-wait.sh`) finish, or notes which pull requests are open, green or pending.
   4. Lets no heavy run be in flight, or notes the run and its output folder so it can be redone.
   5. Writes section 6 below: lanes, branches and commits, open pull requests, what is half done, the next
      three actions, and any pending question for you.
   6. Adds a dated line to the ledger pointing at it.
3. You type `/exit`.

## 5. Steps: starting a session

1. Open a terminal and start the controller in the workspace:

   ```bash
   cd ~/<ws> && claude
   ```

   Claude Code asks before it runs commands or edits files. Choose a permission mode that suits you
   (`docs/ai-agent.md` in the hub lists them). Unattended lane work needs a mode that does not stop for
   each command; use it only inside a disposable or well-guarded environment, with branch protection on
   GitHub (pull request plus green CI, no direct pushes) as the guard rail.
2. First prompt:

   > You are the controller of <ws>. Read work/controller-scripts/HANDOFF.md section 6 and the bottom of
   > work/controller-scripts/controller-todo.md, then check `gh pr list -R <owner>/<repo>`,
   > `git -C ~/<ws>/<repo> worktree list` and each lane worktree's status. Tell me what changed since the
   > hand-off and what you will do next. Do not start lanes until I say go.

3. Check its summary against section 6, then say go.

## 6. Hand-off note (overwrite each time)

_<date and time>, <who wrote it>. Ledger: bottom of `controller-todo.md`. Lane cap in force: <n>._

DONE this session:
- <what merged, with the pull request numbers>

IN FLIGHT:
- <lane>: brief `briefs/<name>.md`, worktree `work/<repo>-<lane>`, branch `<branch>`, head `<sha>`.
  If the brief has no `## Result`, check `git ls-remote origin <branch>` and re-dispatch a fresh lane.
- <open pull request>: if still open, re-run
  `bash work/controller-scripts/merge-wait.sh <owner>/<repo> <pr> <sha>`.

NEXT (three actions):
1. <action>
2. <action>
3. <action>

Worktrees present: <list, and which to keep>.
Pending for you: <questions as one numbered list, each with a recommendation>.
