# result/case33bw/figures

Case-specific folder for formal case33bw figures.

Use `ProjectName_utils.plotting.create_figure(...)` for profile-sized figures
and `ProjectName_utils.plotting.save_figure(fig, caseConfig.figureDir, figName, ...)`
for the formal export bundle.
Each formal figure should include complete metadata, exported plot data, a
manifest row, and a quality-check report.

Minimum metadata: reader question, engineering object, visible result, compared
methods, story contribution, claim id, scientific question, audit evidence
role, named metric, data files, field/unit/dimension description, visual encoding, target
layout, command, key parameters, and random seed/status. Use
`physicsReproduction=not_applicable` when no trusted-reference comparison is
part of the figure.

`evidenceRole` must be one of `scenario-setup`, `physical-reproduction`,
`sota-comparison`, or `sensitivity-ablation`. It is an audit field, not a fixed
story order or a requirement to generate one figure of each type.

Keep original data unchanged. Diagnostic point handling, log-axis zero handling, or
other transforms must be recorded in `figure_manifest.jsonl` and
`figure_check_report.md`.

The default figure profile is `ieee`, and `create_figure()` opens visibly at
one-column width. Select `half-column`, `single-column`, or `double-column`, then adjust
the aspect ratio, axes, legend, and spacing manually. `save_figure` preserves
the current dimensions by default and records the actual width and height.
Batch jobs may use `Visible="off"`; the saved `.fig` still opens visibly.
Complex small figures may explicitly use 8 pt text if the manifest records that
choice. Target-journal instructions may override these defaults.

For line charts and bar charts, prefer an in-axes legend with automatic `best`
placement through `ProjectName_utils.plotting.place_legend(ax)`. Move it
manually only when it covers important curves, bars, peaks, or uncertainty
bands.

Plan the case story in `01_IDEA/figure_plan.md` before export: make the concrete
problem, proposed-method action, direct comparison, and engineering effect
visible through physical or operational quantities. `save_figure` validates
metadata and artifacts but does not require a physical-reproduction figure
before a direct comparison. See
`.cursor/rules/04-case-figure-and-metric-plan.mdc`.
