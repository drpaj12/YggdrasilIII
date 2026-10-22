# Wyrd III

The experiment runner and workbench around Odin III. A TOML project file (`wyrd.toml`) names designs,
recipes and architectures; `wyrd run` expands the sweep, runs it under a memory budget, keeps every run
directory and indexes the results in `wyrd.db`; `wyrd table` and `wyrd compare` print them. `wyrd-gui`
is a desktop window (PySide6) with the project tree, a report per run and a project editor.

- Repository: <https://github.com/drpaj12/wyrd>
- Manual: <https://drpaj12.github.io/wyrd/> (source `docs/user/` in the repository)
- PDF tutorial: <https://drpaj12.github.io/wyrd/wyrd-tutorial.pdf> (source `docs/tutorial/`)
- PDF GUI tutorial: <https://drpaj12.github.io/wyrd/wyrd-gui-tutorial.pdf> (source `docs/tutorial-gui/`)

How it plugs in: it calls Odin III as programs (`odin3`, `odin3-flow`, `vpr`, `abc`). The one exception
is Bifrost III, which imports the `odin3` Python package. Loki III is a Wyrd III step plugin.
