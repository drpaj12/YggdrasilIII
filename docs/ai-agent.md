# Working with an AI coding agent

This page sets up the whole suite on a Windows 11 PC and then works through it with an AI coding
agent that runs in a terminal. You describe the goal in plain words; the agent reads the manuals and
the code, runs the tools and reports back. The page gives the order of the steps and the commands
that the manuals themselves document, and links to those manuals for the details.

## 1. The Windows side

The tools run on Linux. On Windows 11 the Linux side is WSL 2 with Ubuntu 24.04. The graphical
windows (the Wyrd III GUI, the VPR floorplan) appear through WSLg, so no X server is needed.

Open PowerShell as administrator and install a distribution. The Microsoft page,
<https://learn.microsoft.com/en-us/windows/wsl/install>, gives `wsl --install` for the default
distribution (Ubuntu), `wsl --list --online` to list the distributions and
`wsl --install -d <DistroName>` to pick one. For this suite:

```powershell
wsl --install -d Ubuntu-24.04
```

Restart when asked. The first launch asks for a Linux user name and password.

Three practical points:

- **Where the files live.** Keep the work in the Linux file system, for example
  `/home/<user>/ws`, not under `/mnt/c`: Microsoft recommends this for speed
  (<https://learn.microsoft.com/en-us/windows/wsl/filesystems>). From Windows, open the Linux files
  in File Explorer at `\\wsl.localhost\Ubuntu-24.04\home\<user>` (the same page shows the older form
  `\\wsl$`). From a Linux shell, `explorer.exe .` opens the current folder.
- **Memory and swap.** WSL 2 is a virtual machine and takes half of the memory of the PC by default.
  Large runs can use more than you expect, and a full disk or an out-of-memory condition stops the
  whole virtual machine. Limit it in `%UserProfile%\.wslconfig`
  (<https://learn.microsoft.com/en-us/windows/wsl/wsl-config>):

  ```ini
  [wsl2]
  memory=16GB
  processors=6
  swap=8GB
  ```

  Choose values for your PC, then run `wsl --shutdown` in PowerShell and open Ubuntu again.
- **Free space on C:.** The Linux disk of WSL 2 is a file on C:. The Wyrd III preflight checks the
  free space on `/mnt/c` when it runs under WSL and refuses to start a run below 20 GB
  (`disk_min_free = "20G"`, `disk_check_path`; see the
  [Wyrd III getting-started page](https://drpaj12.github.io/wyrd/getting-started.html)).

## 2. The environment, inside Ubuntu

Everything from here runs in the Ubuntu terminal. {doc}`getting-started` has the full procedure; this
is the order.

1. Packages. Odin III needs CMake 3.25 or later, Ninja, a C compiler, `bison`, `flex` and
   `libreadline-dev`. The Odin III CI installs them on Ubuntu with
   `sudo apt-get install -y --no-install-recommends ninja-build libreadline-dev bison flex`; add
   `git`, `cmake`, `build-essential` and `python3-venv` if they are missing.
2. Sources. Clone the hub with its submodules:

   ```bash
   git clone --recursive https://github.com/drpaj12/YggdrasilIII.git
   cd YggdrasilIII
   ```

3. Odin III, built from source:

   ```bash
   cd components/odin3
   cmake --preset release && cmake --build --preset release
   ```

   Put `build/release` on `PATH` (the [Odin III manual](https://drpaj12.github.io/odin3/getting-started.html)
   does it with `export PATH="$PWD/build/release:$PATH"`) and check with `odin3 --version`.
4. VTR. The VPR step needs a VTR checkout with the `vpr` binary and the architecture files. Build it by
   the instructions of the VTR project, <https://github.com/verilog-to-routing/vtr-verilog-to-routing>,
   and set `VTR_ROOT` to it. Without `VTR_ROOT`, `odin3-flow` stops after Odin III and says so.
5. Wyrd III and Loki III, in a virtual environment, from the hub folder:

   ```bash
   python3 -m venv .venv && .venv/bin/pip install -e "components/wyrd[gui,sim,midgard]"
   .venv/bin/pip install --no-deps -e components/loki
   ```

   The `sim` and `midgard` extras need the `odin3` package; the setup of `PYTHONPATH` and `ODIN3_LIB`
   is in {doc}`getting-started`.
6. The machine file, which holds tool locations and resource limits:

   ```bash
   wyrd config init     # write ~/.config/wyrd/machine.toml with detected values
   wyrd config show     # print every effective setting and where it came from
   ```

   Check that `vtr_root` is set. The samples in the Wyrd III repository then check the whole chain:
   `wyrd run --project ~/wyrd-samples` (see the [Wyrd III manual](https://drpaj12.github.io/wyrd/)).

The floorplan viewer needs a second VPR built with graphics; the Wyrd III getting-started page gives the
steps.

## 3. The AI agent

Any command-line coding agent will do. This page uses Claude Code as the example. Its documentation is
at <https://code.claude.com/docs/en/setup> (the older address
<https://docs.claude.com/en/docs/claude-code/setup> redirects there).

**Install it inside WSL**, not from PowerShell. The setup page says: "Open your WSL distribution and
run the Linux installer from the install instructions. You install and launch `claude` inside the WSL
terminal, not from PowerShell or CMD." The command for macOS, Linux and WSL is:

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

Open a new terminal window and check it:

```bash
claude --version
```

A working installation prints a version number. `claude doctor` prints read-only diagnostics of the
installation and its settings. If the shell says `claude` is not found, the install directory is not
on `PATH` yet; the page links a troubleshooting section for that.

**Log in.** Claude Code needs a Pro, Max, Team, Enterprise or Console account; the free claude.ai plan
does not include it. The setup page says: "After installing, log in by running `claude` and following
the browser prompts." Details for every account type are in the authentication page of the same
documentation.

**Start it in the workspace folder.** Go to the folder that holds the suite and start the agent there:

```bash
cd ~/ws/YggdrasilIII
claude
```

### How CLAUDE.md steers the agent

At the start of a session the agent reads `CLAUDE.md` files: instructions that you or the project
write down once, so that you do not repeat them in every prompt
(<https://code.claude.com/docs/en/memory>). A project file is `./CLAUDE.md` or
`./.claude/CLAUDE.md`; a personal file for all projects is `~/.claude/CLAUDE.md`. The command `/init`
writes a first project file from what the agent finds in the code, and `/context` shows which memory
files were loaded. The agent reads the files in the working directory and in the directories above it.

Each Yggdrasil III repository has its own `CLAUDE.md` with its build and test commands and its rules.
When you work across several repositories, put a short `CLAUDE.md` in the folder above them that lists
the repositories, where VTR is, and your own rules (for example: work on branches, never push to
`main`). A file is context, not enforcement: it is followed best when it is short and specific.

### Permission modes

By default the agent asks before it changes a file or runs a command. The modes, from
<https://code.claude.com/docs/en/permission-modes>, are `default`, `acceptEdits`, `plan`, `auto`,
`dontAsk` and `bypassPermissions`. Press `Shift+Tab` in the session to cycle through them, or start in
one:

```bash
claude --permission-mode plan
```

`plan` reads and proposes without changing anything: a good start for a big task. Keep `default` or
`acceptEdits` while you are learning. Use `bypassPermissions` only in a disposable environment.

### Other agents

Other command-line coding agents work the same way: install the tool inside WSL, log in, start it in
the workspace folder, and give it a plain-words goal. Most read a project instruction file as well
(`AGENTS.md` is a common name; Claude Code can read it in place of `CLAUDE.md`). Follow the
installation page of whichever agent you choose.

## 4. How to interact

Describe the goal and the data; do not describe the commands. The agent reads the manuals and the
code, finds the commands (`odin3`, `odin3-flow`, `wyrd run`, `wyrd sim`, VPR), runs them, reads the
logs and reports. Examples for this suite:

- "Synthesize my design in `~/proj` with Odin III and run it through VTR on k6_frac; give me LUTs and
  Fmax."
  The agent uses `odin3-flow` with the design files, `--top` and `--arch`, and reads the numbers from
  `summary.json` and the VPR logs.
- "Make a Wyrd III project sweeping two architectures and compare."
  The agent runs `wyrd init`, edits `wyrd.toml`, runs `wyrd run` and prints the result with
  `wyrd table` or `wyrd compare`.
- "Simulate `counter.v` for 100 cycles and show the waveform."
  The agent uses `wyrd sim counter.v --random 100 --vcd counter.vcd` and opens the VCD in GTKWave.
- "Open the floorplan of the last run."
  This is the Floorplan button of the Wyrd III GUI, `wyrd-gui <project>`; the window appears through
  WSLg and needs the VPR built with graphics (section 2).
- "Reverse-engineer the structure of this netlist with Loki III and tell me what you found."

Habits that work well:

- One task per session. Start a new session for a new goal, so that the context stays small.
- Ask for a plan first on anything big (`plan` mode), read it, then let the agent go on.
- Read the diffs. Let the agent commit on a branch and open a pull request; never let it push to
  `main`.
- Keep secrets, such as tokens, passwords and licence keys, out of prompts and out of the repositories.
- Ask for evidence: the command that ran, the log path and the numbers, not only a summary.

## 5. How Yggdrasil III was built this way

Yggdrasil III itself was built with agents. A human architect wrote the specifications and made the
decisions. A controller agent split the work into lanes and dispatched a lane agent for each one in its
own git worktree; the lane agents wrote code and tests on branches, the controller reviewed the
results, and a branch merged when the continuous-integration checks were green. The method and the
suite are described in the paper listed under {doc}`publications`. {doc}`agent-controller` reproduces that
setup on a clean Windows or Linux machine, with the templates in the
[agent-kit](https://github.com/drpaj12/YggdrasilIII/tree/main/agent-kit) folder.
