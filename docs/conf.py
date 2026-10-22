"""Sphinx configuration of the Yggdrasil III hub documentation.

Build: ``sphinx-build -W -b html docs build/docs`` (CI job ``docs``). No submodule is needed.
"""

project = "Yggdrasil III"
author = "Yggdrasil III contributors"
copyright = "Yggdrasil III contributors"

extensions = ["myst_parser", "sphinxcontrib.mermaid"]
source_suffix = {".md": "markdown"}
root_doc = "index"
exclude_patterns = ["_build"]
html_static_path = ["_static"]
myst_enable_extensions = ["colon_fence"]
myst_heading_anchors = 3
html_theme = "alabaster"
