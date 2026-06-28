# +ProjectName_utils

Non-core utilities for the project template.

Keep this package for implementation support that should not define the paper's core contribution:

- `+mc/`: Monte Carlo seeds, sampling helpers, empirical validation drivers, and cache keys.
- `+io/`: directory creation, result export, summary writing, table IO, and cache IO helpers.
- `+workflow/`: case-run preparation, terminal step tracking, and run finalization helpers.
- `+ui/`: local task progress UI for long-running package functions such as Monte Carlo or batch scenario evaluation.
- `+plotting/`: paper figure style and export helpers. Formal figures should use
  `figure_profile`, `create_figure`, `methodStyle`, `plot_method_line`,
  `place_legend`, and `save_figure`, and should be written to
  `result/<case>/figures/`.
  Default `methodStyle` labels are Chinese placeholders with explicit physical
  meaning; translate them only after the manuscript language is fixed.

Add new utilities by support process, not as generic loose helpers. Good
subpackage names describe the workflow support they provide, such as `+cache/`,
`+logging/`, `+validation/`, or `+tables/`. File names should describe the
actual IO, export, plotting, sampling, or validation step they perform.

`save_figure` is intentionally strict. Formal exports must provide metadata for
the scientific question, data files, field/unit/dimension description, visual
encoding, target layout, command, key parameters, and random seed/status. Keep
data transformations, excluded points, and log-axis zero handling explicit in
the manifest and check report.

The default figure profile is `ieee`. It records IEEE-oriented column widths,
10 pt figure text, optional 8 pt text for complex small figures,
one-column maximum width for IEEE two-column manuscripts,
font candidates, preview resolution, accepted submission formats, and the rule
that color must not be the only visual distinction. Profile values are defaults,
not a substitute for checking the target journal's current author instructions.
Use a venue-specific profile when a journal requires different sizes, fonts,
formats, or axis conventions.

Prefer adding shared helpers to this package instead of creating a separate
`scripts/`, `tools/`, or parallel utility folder. Create a new folder only when
the project author explicitly chooses that organization.

Do not put model formulation, solver logic, contribution-defining algorithms, or SOTA baseline implementations here. Those belong in `+ProjectName_core/` and `+ProjectName_sota/`.
