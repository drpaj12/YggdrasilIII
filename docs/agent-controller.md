# Running the suite with Claude Code

This page takes a clean machine to a working Claude Code controller: one interactive session that plans, writes
briefs and merges, and lane subagents that each do one brief in a git worktree. It is the way Yggdrasil III was
built. Versions are those of 2026-11-09 (Claude Code 2.1.316); the tools around it are listed with their versions
on {doc}`tools`. {doc}`ai-agent` is the general introduction (the Windows side, agent basics, `CLAUDE.md`);
{doc}`getting-started` installs the suite itself. The templates are in the
[agent-kit](https://github.com/drpaj12/YggdrasilIII/tree/main/agent-kit) folder of the hub.

## 1. Install Claude Code and log in

The official page is <https://code.claude.com/docs/en/setup>. Claude Code needs a Pro, Max, Team, Enterprise or
Console account; the free claude.ai plan does not include it. A controller that runs lanes for hours is limited by
the usage of the plan, so choose the plan with that in mind.

**Linux (Ubuntu 24.04).**

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

Open a new terminal, then:

```bash
claude --version     # 2.1.316 when this page was written
claude doctor        # read-only diagnostics of the installation and settings
claude               # first start: follow the browser prompts to log in
```

**Windows 11.** Install WSL 2 with Ubuntu 24.04 ({doc}`ai-agent` section 1) and run the Linux installer inside it. The
setup page says to launch `claude` inside the WSL terminal, not from PowerShell. Authentication for every account
type: <https://code.claude.com/docs/en/authentication>.

## 2. Models and effort

The controller runs on the strongest model and the lanes on a smaller one. In this suite the controller was Opus 5.5
at high effort and the lanes were Sonnet 5.5, which keeps the usage of the plan down. Set the controller model in
`~/.claude/settings.json` (`"model": "opus"`) or with `/model` inside a session. A lane gets its model from the
Agent tool call (`model: "sonnet"`) or from an agent definition in `.claude/agents/`
(<https://code.claude.com/docs/en/sub-agents>). Say in each brief or dispatch which model and effort the work needs;
long edits and fix rounds are Sonnet work, review and planning are controller work.

## 3. Permission modes

Claude Code asks before it runs commands or edits files. The modes are listed in the settings page,
<https://code.claude.com/docs/en/settings>. This suite used `"permissions": {"defaultMode": "auto"}` in
`~/.claude/settings.json`, with allow rules for the safe commands (`cmake`, `ctest`, `git status`, `git diff`,
`git push`, `gh pr view`, `gh pr checks`) in the project `.claude/settings.json` of each repository, and no allow
rule for deleting files. A mode that does not stop for each command suits unattended lane work only inside a
disposable or well-guarded environment; branch protection on GitHub (pull request plus green CI, no direct pushes)
is the guard rail that holds even when an agent forgets a rule.

## 4. The workspace layout and the CLAUDE.md files

The controller expects one workspace folder with the repositories side by side, a `work/` folder for lane worktrees
and a `work/controller-scripts/` folder for briefs, the ledger and the hand-off note. In examples below the
folder is `~/odin3-ws`; use any name.

```text
~/odin3-ws/
  CLAUDE.md                      workspace instructions (agent-kit/CLAUDE.md)
  YggdrasilIII/                  the hub; read-only main checkout
  odin3/ wyrd/ loki/ ...         one main checkout per repository, read-only
  external/vtr-verilog-to-routing   VTR, read only (getting-started section 6)
  work/
    <repo>-<lane>/               one git worktree per lane
    controller-scripts/
      HANDOFF.md  controller-todo.md  mw.sh  heavy-lock.sh
      usage-statusline.sh  usage-nudge.sh
      briefs/TEMPLATE.md  briefs/<lane>.md
```

```bash
mkdir -p ~/odin3-ws/work/controller-scripts/briefs ~/odin3-ws/external && cd ~/odin3-ws
git clone --recurse-submodules https://github.com/drpaj12/YggdrasilIII.git
K=YggdrasilIII/agent-kit
cp $K/CLAUDE.md CLAUDE.md
cp $K/HANDOFF.md $K/controller-todo.md $K/mw.sh $K/heavy-lock.sh $K/usage-statusline.sh $K/usage-nudge.sh work/controller-scripts/
cp $K/briefs/TEMPLATE.md work/controller-scripts/briefs/
chmod +x work/controller-scripts/*.sh
```

Edit `CLAUDE.md`: replace `<ws>`, `<user>` and `<owner>`. Install the GitHub CLI and log in
(<https://github.com/cli/cli/blob/trunk/docs/install_linux.md>, then `gh auth login`); the controller uses it for
pull requests and merging. Run the clones and builds of {doc}`getting-started` first, so lanes find a working
toolchain.

Claude Code reads `CLAUDE.md` files at the start of a session: the one in the working directory, the ones above it,
and the one of each repository it works in. Three levels are used here:

- the workspace `CLAUDE.md`: layout, the lane and merge rules, what to read first;
- each repository's `CLAUDE.md`: its build, test and lint commands (read it before changing that repository);
- the memory directory of the user (`~/.claude/projects/<project>/memory/MEMORY.md`): standing preferences that
  survive between sessions.

Lanes work in worktrees of the repositories, never in the main checkouts:

```bash
git -C ~/odin3-ws/wyrd worktree add -b docs/example ~/odin3-ws/work/wyrd-example origin/main
```

## 5. Plugins, MCP servers and hooks

Configured here, and what each does. All are optional; the suite builds and runs without them.

| Item | What it does | How it was installed |
|---|---|---|
| superpowers plugin (6.4.2) | Skills for planning, test-first work, review and finishing a branch | `claude plugin marketplace add obra/superpowers-marketplace`, then `claude plugin install superpowers@superpowers-marketplace` |
| caveman plugin (4.0.1) | Terse output style that cuts output tokens; enabled for the workspace project only | `claude plugin marketplace add JuliusBrussee/caveman`, then `claude plugin install caveman@caveman --scope project` |
| clangd-lsp plugin (1.0.0) | A C language server so the agent can ask for definitions and references in Odin III | `claude plugin install clangd-lsp@claude-plugins-official`; needs `clangd` |
| code-review-graph (2.3.9), an MCP server | A tree-sitter code graph per worktree; the agent queries callers, callees, tests and impact instead of reading whole files | `pipx install code-review-graph`, then `claude mcp add code-review-graph -- code-review-graph serve --repo ~/odin3-ws/odin3` |

Check them with `claude plugin list` and `claude mcp list`. The plugin commands are described in
<https://code.claude.com/docs/en/plugins>, MCP servers in <https://code.claude.com/docs/en/mcp>.

**Hooks.** Hooks are commands the harness runs on events (<https://code.claude.com/docs/en/hooks>). Two are used,
set in the workspace `.claude/settings.json`:

```json
{
  "hooks": {
    "PostToolUse": [
      {"matcher": "Edit|Write",
       "hooks": [{"type": "command", "command": "~/odin3-ws/work/controller-scripts/crg-hook.sh", "timeout": 10}]}
    ],
    "UserPromptSubmit": [
      {"hooks": [{"type": "command", "command": "~/odin3-ws/work/controller-scripts/usage-nudge.sh", "timeout": 5}]}
    ]
  },
  "statusLine": {"type": "command", "command": "~/odin3-ws/work/controller-scripts/usage-statusline.sh", "padding": 0}
}
```

- `crg-hook.sh` (PostToolUse on `Edit|Write`) runs `code-review-graph update` detached in whichever worktree was
  edited, so the code graph is built on the first edit and kept current. It never fails the hook, and it skips when the
  host disk is low. It is a few lines around `code-review-graph update --skip-flows --repo <worktree>`.
- `usage-nudge.sh` (UserPromptSubmit) adds a line to the controller's context when the context window or the weekly
  limit passes a threshold, so the controller asks you to `/compact` before the context is full.

## 6. The usage meter

`usage-statusline.sh` is the status line. Claude Code passes it a JSON document with the context size and the
plan's rate limits; the script prints one line (`model | ctx 41% | 5h 12% | wk 7%`) and saves the numbers to
`~/.claude/usage-state/latest.json`. The controller reads that file (`cat ~/.claude/usage-state/latest.json`) to
decide how many lanes to run and when to stop. Agree thresholds before you start: for example no new lanes at 90% of the
weekly limit and a hand-off at 95%. `/usage` inside Claude Code shows the same numbers by hand.

## 7. Start the controller

```bash
cd ~/odin3-ws
claude
```

The workspace file tells the controller to read section 6 of `HANDOFF.md` and the bottom of `controller-todo.md`
before acting, so a new session picks up where the last one stopped. On the very first start give it a goal and a
first prompt such as:

> You are the controller of this workspace. Read CLAUDE.md, then the repository READMEs under YggdrasilIII/components.
> Write a brief in work/controller-scripts/briefs/ for <goal>, using TEMPLATE.md. Do not dispatch a lane until I approve the brief.

For a later session use the prompt in section 5 of `HANDOFF.md`.

## 8. The controller and lane model

**The controller** is the interactive session. It plans, writes one brief per lane, dispatches the lanes, reviews
their results, opens the pull requests and merges them. It holds the ledger (`controller-todo.md`) and writes the
hand-off note. It does not do long implementation work itself, so its context stays small.

**A lane** is a subagent started through the Agent tool (<https://code.claude.com/docs/en/sub-agents>). Each lane:

- gets one brief (`briefs/TEMPLATE.md`: Problem, Where, Tasks, Checks, Rules, Result) and nothing else of the
  controller's context, so the brief must be complete;
- works in its own git worktree on its own branch, created by the controller;
- runs on a smaller model than the controller (Sonnet) to keep the usage down;
- commits and pushes after every step, so a dead session loses at most one step;
- appends `## Result` to its brief when done: the pushed head (checked with `git ls-remote`), files changed, gate
  output, deviations and open issues;
- never opens the pull request to `main` without the brief saying so, and never merges.

**Review.** A second lane, with a fresh context and the diff but not the first lane's reasoning, reviews the result.
Fixes go to a fresh small lane, never back to the original implementer, whose context is large. Before opening a
pull request or merging, check that the remote branch head equals the commit that was reviewed: a lane's "pushed"
can be false.

**Merge on green.** Open pull requests as drafts while the work goes on and let CI run once, when the pull request
is marked ready (Actions minutes are limited). Then run `mw.sh` as one background task:

```bash
bash work/controller-scripts/mw.sh <owner>/<repo> <pr> <head-sha>
```

The script waits for CI, then squash-merges only if every check passed, at least one check really ran (a draft-era
run in which every check is "skipping" is refused) and the head still equals the reviewed commit. Protect `main` on
GitHub. A pull request in conflict gets no CI, so recheck the open pull requests after each merge. Update a branch by
merging `origin/main` into it; do not rebase or force push.

**The lane cap.** Run at most two or three lanes at a time (review and fix rounds count as a lane). More lanes burn
the usage of the plan faster than the controller can review them, and builds in parallel exhaust memory.

**The heavy lock.** A sweep, a large benchmark or a VPR matrix can use all the memory of the machine, and a full
disk or an out-of-memory condition stops the whole WSL 2 virtual machine ({doc}`ai-agent` section 1). Every such job
goes through one exclusive lock, so only one runs at a time:

```bash
work/controller-scripts/heavy-lock.sh .venv/bin/wyrd run --project datasets/l0 --jobs 3 --mem-budget 8G
```

`heavy-lock.sh` wraps `flock -x` on one lock file. Odin III's own `tools/heavy-run` builds on the same idea with
two memory-capped systemd slices (5 GB each) beside a build lock, so on a 23 GB machine the parallel memory stays under
60%. Wyrd III's `mem_budget` (in `machine.toml`) caps the runs inside one project.

## 9. Hand-off between sessions

A session ends when its context or quota runs out. `HANDOFF.md` gives the steps for leaving (drain the lanes, check
every push, write the note, add a ledger line) and for starting (read the note and the ledger, check the pull requests
and worktrees, report before dispatching). The same steps hand the controller role to another session on another
machine or another model: everything it needs is in the repositories, the ledger and the note. The briefs, ledger and
scripts live in a separate private repository, so the history of the work is never only in a chat.

## 10. Usage habits and lessons

- One task per lane, one goal per session; start a new session for a new goal.
- Put the specifics in the brief and the repository's `CLAUDE.md`, not in a long prompt; keep briefs under two pages
  and point to line ranges.
- Output of builds and tests goes to a file; the agent reads the tail and the summary.
- Ask for evidence: the command, the log path and the numbers.
- Keep secrets out of prompts, briefs and repositories. Never let a lane push to `main`.
- **Never wait with `pgrep -f "<pattern>"` in a loop.** The pattern matches the command line of the loop itself, so the
  loop never ends. Run the job in the foreground, or as one background task, and wait for its notification.
- **Fresh agents for fix rounds.** A review fix goes to a new small lane; resuming a lane at several hundred thousand
  tokens of context is slow and costly. An agent that "waits on its own background job" can resume itself, so check
  before you dispatch a replacement.
- **Draft pull requests, CI once at ready.** CI minutes are limited.
- Use `git -C <path>` and absolute paths; `cd X && git commit` chains force a permission prompt.
- Check the usage meter regularly and agree thresholds for pausing new lanes and for a hand-off before you start.

## 11. The agent kit

The [agent-kit](https://github.com/drpaj12/YggdrasilIII/tree/main/agent-kit) folder holds only templates: `CLAUDE.md`,
`HANDOFF.md`, `controller-todo.md`, `briefs/TEMPLATE.md`, `mw.sh`, `heavy-lock.sh`, `usage-statusline.sh`,
`usage-nudge.sh` and `settings.example.json`. It holds no credentials, no session links, no private repository
names and no personal memory. Fill `<ws>`, `<user>` and `<owner>` yourself.
