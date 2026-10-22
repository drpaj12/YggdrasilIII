# Getting started

This page installs the whole suite. It links to each piece's own manual for details instead of
repeating them. To set the suite up and use it through an AI coding agent on Windows, see
{doc}`ai-agent`.

## Get the sources

The hub repository holds the three code repositories as git submodules under `components/`:

```bash
git clone --recursive https://github.com/drpaj12/YggdrasilIII.git
cd YggdrasilIII
```

You can also clone each repository on its own: <https://github.com/drpaj12/odin3>,
<https://github.com/drpaj12/wyrd>, <https://github.com/drpaj12/loki>.

## Odin III

Needs CMake 3.25 or later, Ninja, a C compiler, `bison`, `flex` and `libreadline-dev` (Ubuntu 24.04,
native or WSL2). Build from source:

```bash
cd components/odin3
cmake --preset release && cmake --build --preset release
```

Or install the Python wheel from the Odin III GitHub release: `pip install odin3-1.0.0-py3-none-linux_x86_64.whl`.
The wheel bundles `libodin3`, ABC, the `odin3` command and `odin3-flow`. Odin III is not on PyPI.
See the [Odin III getting-started page](https://drpaj12.github.io/odin3/getting-started.html).

## VTR

The VPR step of the flow and the Wyrd III `vtr` flow need a VTR checkout: the `vpr` binary and the
architecture files. Set `VTR_ROOT` to it. Without `VTR_ROOT`, `odin3-flow` stops after Odin III and
says so.

## Wyrd III

After installing, follow the PDF tutorial, <https://drpaj12.github.io/wyrd/wyrd-tutorial.pdf>, for a first project. The same work done in the graphical interface, a figure for each step, is in the GUI
tutorial, <https://drpaj12.github.io/wyrd/wyrd-gui-tutorial.pdf>.

Needs Python 3.11 or later. In a virtual environment, from `components/wyrd`:

```bash
python3 -m venv .venv && .venv/bin/pip install -e ".[gui,sim,midgard]"
```

The extras add the GUI (`gui`), simulation through Bifrost III (`sim`) and Midgard III (`midgard`).
The `sim` and `midgard` extras need the `odin3` package (1.0.3 or later); point `PYTHONPATH` at
`odin3/plugins/python` and `ODIN3_LIB` at `libodin3.so` of your Odin III build, or install the wheel.
See the [Wyrd III getting-started page](https://drpaj12.github.io/wyrd/getting-started.html).

## Loki III

Install it in the same virtual environment as Wyrd III, from `components/loki`:

```bash
.venv/bin/pip install --no-deps -e .
```

It needs `cffi` and the Odin III environment variables `ODIN3_ROOT`, `ODIN3_LIB` and `PYTHONPATH`.
See the [Loki III manual](https://drpaj12.github.io/loki/install.html) and the
[L0 runbook](https://github.com/drpaj12/loki/blob/main/docs/runbook-l0.md).

## The machine configuration

Tool locations and resource limits belong to the machine, not to a project:

```bash
wyrd config init     # write ~/.config/wyrd/machine.toml with detected values
wyrd config show     # print every effective setting and where it came from
```

Set `vtr_root` in that file (or `$VTR_ROOT` before `wyrd config init`). The path of the file can be
changed with `$WYRD_CONFIG`.

## Updating the components

The pins of the submodules are the commits the hub was last tested against. To move them to the
current `main` of each repository:

```bash
git submodule update --remote
git add components
git commit -m "components: update pins"
```
