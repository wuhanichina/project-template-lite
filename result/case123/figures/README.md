# result/case123/figures

Case-specific folder for formal case123 figures.

Use `ProjectName_utils.plotting.create_figure(...)` for profile-sized figures
and `ProjectName_utils.plotting.save_figure(fig, caseConfig.figureDir, figName, ...)`
for the formal export bundle.
Each formal figure should include complete metadata, exported plot data, a
manifest row, and a quality-check report.

Minimum metadata: claim id, scientific question, physical reproduction target,
figure evidence role, data files, field/unit/dimension description, visual
encoding, target layout, command, key parameters, and random seed/status.

`evidenceRole` must be one of `scenario-setup`, `physical-reproduction`,
`sota-comparison`, or `sensitivity-ablation`. `save_figure` rejects other values
for formal figures.

Keep original data unchanged. Diagnostic exclusions, log-axis zero handling, or
other transforms must be recorded in `figure_manifest.jsonl` and
`figure_check_report.md`.

The default figure profile is `ieee`. It uses 10 pt figure text and limits
formal figures to one IEEE column width by default. Complex small figures may
explicitly use 8 pt text if the manifest records that choice. Treat it as the
project default unless the target journal gives stricter instructions for size,
font, resolution, format, or axis conventions.

For line charts and bar charts, prefer an in-axes legend with automatic `best`
placement through `ProjectName_utils.plotting.place_legend(ax)`. Move it
manually only when it covers important curves, bars, peaks, or uncertainty
bands.

Plan figures in `01_IDEA/figure_plan.md` before export: pin the contribution and
claim id, then list each figure with its evidence role, metric, and figure type.
A `sota-comparison` or `sensitivity-ablation` figure must not be exported for a
claim before a `physical-reproduction` figure exists for that claim;
`save_figure` enforces this ordering. The physical-reproduction figure must
compare against actual or trusted-reference data, not a self-defined index. See
`.cursor/rules/04-case-figure-and-metric-plan.mdc`.
