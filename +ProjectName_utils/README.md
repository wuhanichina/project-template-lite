# +ProjectName_utils

Non-core utilities for the project template.

Keep this package for implementation support that should not define the paper's core contribution:

- `+mc/`: Monte Carlo seeds, sampling helpers, empirical validation drivers, and cache keys.
- `+io/`: directory creation, result export, summary writing, table IO, and cache IO helpers.
- `+plotting/`: paper figure style and export helpers. Formal figures should use
  `methodStyle`, `plot_method_line`, and `save_figure`, and should be written to
  `result/<case>/figures/`.

`save_figure` is intentionally strict. Formal exports must provide metadata for
the scientific question, data files, field/unit/dimension description, visual
encoding, target layout, command, key parameters, and random seed/status. Keep
data transformations, excluded points, and log-axis zero handling explicit in
the manifest and check report.

Prefer adding shared helpers to this package instead of creating a separate
`scripts/`, `tools/`, or parallel utility folder. Create a new folder only when
the project author explicitly chooses that organization.

Do not put model formulation, solver logic, contribution-defining algorithms, or SOTA baseline implementations here. Those belong in `+ProjectName_core/` and `+ProjectName_sota/`.
