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

`save_figure` is intentionally strict about traceability, but it does not decide
the case-study story. Formal exports must record the reader question,
engineering object, visible result, compared methods, story contribution, claim
id, scientific question, audit evidence role, named metric, data files,
field/unit/dimension description, visual encoding, target layout, command, key
parameters, and random seed/status. Record `physicsReproduction` only when a
trusted-reference comparison applies; otherwise use `not_applicable`.
`evidenceRole` remains one of `scenario-setup`, `physical-reproduction`,
`sota-comparison`, or `sensitivity-ablation` for contract compatibility, but it
does not impose a fixed export order or require one figure of each type. Plan
the reader-facing engineering story in `01_IDEA/figure_plan.md` and follow
`.cursor/rules/04-case-figure-and-metric-plan.mdc`. Keep data transformations,
excluded points, and log-axis zero handling explicit in the manifest and check
report.
The exporter records `templateFigureContractVersion` automatically so the
template-side reader-story extension remains distinguishable from the canonical
PowerLit contract version.

The default figure profile is `ieee`. `create_figure()` starts at one-column
width and opens visibly for manual adjustment. The author may select `half-column`, `single-column`, or
`double-column`, then adjust the aspect ratio, axes, legend, and spacing
manually. `save_figure` preserves the current figure dimensions by default and
records the actual width and height in the manifest; set
`ApplyProfileSize=true` only when an explicit reset to the selected layout is
wanted. Batch jobs may create figures with `Visible="off"`; `save_figure`
restores that source state after export while saving the `.fig` artifact with
visible-on-open behavior. The profile also records 10 pt text, optional 8 pt text for complex
small figures, font candidates, preview resolution, accepted submission
formats, and the rule that color must not be the only visual distinction.

Prefer adding shared helpers to this package instead of creating a separate
`scripts/`, `tools/`, or parallel utility folder. Create a new folder only when
the project author explicitly chooses that organization.

Do not put model formulation, solver logic, contribution-defining algorithms, or SOTA baseline implementations here. Those belong in `+ProjectName_core/` and `+ProjectName_sota/`.
