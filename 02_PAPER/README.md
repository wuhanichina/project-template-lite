# 02_PAPER

Put manuscript-facing material here.

Drafts in this folder should be distilled from `ProjectName_note.md`,
`01_IDEA/claims.md`, `01_IDEA/evidence_map.md`, `01_IDEA/research_trace.yaml`,
and registered outputs under `result/`. Keep conclusions, figures, numbers,
references, engineering scenarios, and Git/version statements traceable to
those files.

AI-generated manuscript text, captions, review responses, and author-facing
notes should pass the writing style gate in
`.cursor/rules/03-public-note-and-paper-skill-bridge.mdc` and the project
wording scan in `.cursor/rules/lexicon.md` before release.

Formal manuscript figures should come from `result/<case>/figures/` bundles
exported by `ProjectName_utils.plotting.save_figure`, so source figures,
preview images, vector outputs, plot data, manifest rows, and check reports stay
synchronized.

The tracked author profile is only an example:

```text
02_PAPER/config/author-profile.example.yaml
```

Copy it to `02_PAPER/config/author-profile.yaml` for local use. The real
`author-profile.yaml` is ignored because it may contain personal information.
