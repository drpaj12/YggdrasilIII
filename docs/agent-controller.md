# Running the suite with Claude Code

This page reproduces, on a clean Linux or Windows machine, the way Yggdrasil III was driven: one
controller session of Claude Code that plans, writes briefs and merges, and lane subagents that each do one
brief in a git worktree. {doc}`ai-agent` covers the Windows side, the agent basics and CLAUDE.md;
{doc}`getting-started` installs the tools. The templates used below are in the
[agent-kit](https://github.com/drpaj12/YggdrasilIII/tree/main/agent-kit) folder of the hub repository.

## 1. Install Claude Code and log in

The official page is <https://code.claude.com/docs/en/setup>. Claude Code needs a Pro, Max, Team,
Enterprise or Console account; the free claude.ai plan does not include it. A controller that runs lanes
for hours is limited by the plan's usage, so choose the plan with that in mind.

**Linux (Ubuntu 24.04).** The native installer:

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

Open a new terminal, then:

```bash
claude --version     # prints a version number
claude doctor        # read-only diagnostics of the installation and settings
claude               # first start: follow the browser prompts to log in
```

**Windows 11.** Install WSL 2 with Ubuntu 24.04 ({doc}`ai-agent` section 1), open the Ubuntu terminal and run
the Linux installer above inside it. The setup page says to install and launch `claude` inside the WSL
terminal, not from PowerShell or CMD. (The same page also documents a native Windows install; the suite
needs the Linux toolchain, so this page uses WSL.) The authentication page,
<https://code.claude.com/docs/en/authentication>, covers every account type.

## 2. Get the repositories and the workspace layout

Install the GitHub CLI and log in; the controller uses it for pull requests and merging. On Ubuntu the
install steps are in <https://github.com/cli/cli/blob/trunk/docs/install_linux.md> (Debian and Ubuntu
section); then:

```bash
gh auth login
```

The controller expects one workspace folder with the repositories side by side, a `work/` folder for lane
worktrees and a `work/controller-scripts/` folder for briefs, the ledger and the hand-off note:

```text
~/<ws>/
  CLAUDE.md                      workspace instructions (agent-kit/CLAUDE.md)
  YggdrasilIII/                  the hub; components/ holds odin3, wyrd, loki, verdandi, norns
  external/vtr-verilog-to-routing   VTR, read only (getting-started section 6)
  work/
    <repo>-<lane>/               one git worktree per lane
    controller-scripts/
      HANDOFF.md  controller-todo.md  merge-wait.sh  heavy-lock.sh
      briefs/TEMPLATE.md  briefs/<lane>.md
```

```bash
mkdir -p ~/<ws>/work/controller-scripts/briefs ~/<ws>/external && cd ~/<ws>
git clone --recurse-submodules https://github.com/drpaj12/YggdrasilIII.git
K=YggdrasilIII/agent-kit
cp $K/CLAUDE.md CLAUDE.md
cp $K/HANDOFF.md $K/controller-todo.md $K/merge-wait.sh $K/heavy-lock.sh work/controller-scripts/
cp $K/briefs/TEMPLATE.md work/controller-scripts/briefs/
```

Edit `CLAUDE.md`: replace `<ws>` and `<user>`. Lanes work in worktrees of the repositories, never in the
main checkouts:

```bash
git -C ~/<ws>/YggdrasilIII/components/wyrd worktree add -b docs/example ~/<ws>/work/wyrd-example origin/main
```

Run the clones and builds of {doc}`getting-started` first, so lanes find a working toolchain.

## 3. Start the controller

```bash
cd ~/<ws>
claude
```

Claude Code reads the `CLAUDE.md` in the working directory and the folders above it at the start of a
session ({doc}`ai-agent` explains the memory files). The workspace file tells the controller to read
section 6 of `HANDOFF.md` and the bottom of `controller-todo.md` before acting, so a new session picks up
where the last one stopped. On the very first start, give it a goal and a first prompt such as:

> You are the controller of this workspace. Read CLAUDE.md, then the repository READMEs under
> YggdrasilIII/components. Write a brief in work/controller-scripts/briefs/ for <goal>, using TEMPLATE.md.
> Do not dispatch a lane until I approve the brief.

For a later session use the prompt in section 5 of `HANDOFF.md`.

## 4. The controller and lane model

**The controller** is the interactive session. It plans, writes one brief per lane, dispatches the lanes,
reviews their results, opens the pull requests and merges them. It holds the ledger
(`controller-todo.md`) and writes the hand-off note. It does not do long implementation work itself, so
its context stays small.

**A lane** is a subagent, started through the Agent tool of Claude Code
(<https://code.claude.com/docs/en/sub-agents>). Each lane:

- gets one brief (`briefs/TEMPLATE.md`: Where, Job, Gates, Report, Rules) and nothing else of the
  controller's context, so the brief must be complete;
- works in its own git worktree on its own branch, created by the controller (the sub-agents page
  documents `isolation: worktree` for a worktree made by Claude Code);
- runs on a smaller model than the controller (Sonnet in this suite) to keep the usage of the plan down;
- commits and pushes after every step, so a dead session loses at most one step;
- appends `## Result` to its brief when done: the pushed head (checked with `git ls-remote`), files
  changed, gate output, deviations and open issues;
- never opens the pull request and never merges.

**Review.** A second lane, with a fresh context and the diff but not the first lane's reasoning, reviews
the result. Fixes go to a fresh small lane, not back to the original implementer, whose context is large.

**Merge on green.** The controller opens the pull request, checks that the remote branch head equals the
commit it reviewed, and runs `merge-wait.sh` as one background task:

```bash
bash work/controller-scripts/merge-wait.sh <owner>/<repo> <pr> <head-sha>
```

The script (https://github.com/drpaj12/YggdrasilIII/blob/main/agent-kit/merge-wait.sh) waits for CI, then squash-merges only if every check passed and the head
still matches. Protect `main` on GitHub (pull request plus green CI, no direct pushes) so the rule holds
even when an agent forgets it. A pull request in conflict gets no CI, so recheck the open pull requests
after each merge. Update a branch by merging `origin/main` into it; do not rebase or force push.

**The lane cap.** Run at most two lanes at a time (review and fix rounds count as a lane). More lanes
burn the plan's usage faster than the controller can review them, and builds in parallel exhaust memory.

**The heavy lock.** A sweep, a large benchmark or a VPR matrix can use all the memory of the machine, and a
full disk or an out-of-memory condition stops the whole WSL 2 virtual machine ({doc}`ai-agent` section 1).
Every such job goes through one exclusive lock so only one runs at a time:

```bash
work/controller-scripts/heavy-lock.sh .venv/bin/wyrd run --project datasets/l0 --jobs 3 --mem-budget 8G
```

`heavy-lock.sh` (https://github.com/drpaj12/YggdrasilIII/blob/main/agent-kit/heavy-lock.sh) wraps `flock -x` on one lock file. Odin III's own
`tools/heavy-run` adds a memory-capped systemd slice on top of the same idea. Wyrd III's own memory
budget (`mem_budget`, in `machine.toml`) caps the runs inside one project.

## 5. Hand-off between sessions

A session ends when its context or quota runs out. `HANDOFF.md` (https://github.com/drpaj12/YggdrasilIII/blob/main/agent-kit/HANDOFF.md) gives the steps for
leaving (drain the lanes, check every push, write the note, add a ledger line) and for starting (read the
note and the ledger, check the pull requests and worktrees, report before dispatching). The same steps hand
the controller role to another session on another machine or another model: everything it needs is in the
repositories, the ledger and the note.

## 6. Usage habits

- One task per lane, one goal per session; start a new session for a new goal.
- Put the specifics in the brief and the repository's `CLAUDE.md`, not in a long prompt; keep briefs under
  two pages and point to line ranges.
- Output of builds and tests goes to a file; the agent reads the tail and the summary.
- Ask for evidence: the command, the log path and the numbers.
- Keep secrets out of prompts, briefs and repositories. Never let a lane push to `main`.
- Check the plan's usage regularly (`/usage` inside Claude Code) and agree thresholds for pausing new
  lanes and for a hand-off before you start.

## 7. The agent kit

The [agent-kit](https://github.com/drpaj12/YggdrasilIII/tree/main/agent-kit) folder holds only templates:
[`CLAUDE.md`](https://github.com/drpaj12/YggdrasilIII/blob/main/agent-kit/CLAUDE.md), [`HANDOFF.md`](https://github.com/drpaj12/YggdrasilIII/blob/main/agent-kit/HANDOFF.md),
[`controller-todo.md`](https://github.com/drpaj12/YggdrasilIII/blob/main/agent-kit/controller-todo.md), [`briefs/TEMPLATE.md`](https://github.com/drpaj12/YggdrasilIII/blob/main/agent-kit/briefs/TEMPLATE.md),
[`merge-wait.sh`](https://github.com/drpaj12/YggdrasilIII/blob/main/agent-kit/merge-wait.sh) and [`heavy-lock.sh`](https://github.com/drpaj12/YggdrasilIII/blob/main/agent-kit/heavy-lock.sh). It holds no credentials,
no session links and no personal memory. Fill `<ws>`, `<user>` and `<owner>` yourself.
