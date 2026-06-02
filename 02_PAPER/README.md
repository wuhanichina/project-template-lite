# 02_PAPER

Put manuscript-facing material here.

Drafts in this folder should be distilled from `ProjectName_note.md`,
`01_IDEA/claims.md`, `01_IDEA/evidence_map.md`, `01_IDEA/research_trace.yaml`,
and registered outputs under `result/`. Do not introduce claims, figures,
numbers, references, or Git/version statements that cannot be traced back to
those files.

Formal manuscript figures should come from `result/<case>/figures/` bundles
exported by `ProjectName_utils.plotting.save_figure`, not screenshots, manual
redraws, or external plotting tools.

The tracked author profile is only an example:

```text
02_PAPER/config/author-profile.example.yaml
```

Copy it to `02_PAPER/config/author-profile.yaml` for local use. The real
`author-profile.yaml` is ignored because it may contain personal information.
