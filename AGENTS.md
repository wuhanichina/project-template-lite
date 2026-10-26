# AGENTS.md

## Project Rules

Before editing code, documentation, comments, generated prose, or template
structure in this repository, read and follow:

- `.cursor/rules/00-lightweight-research-coding.mdc`
- `.cursor/rules/01-matlab-code-style.mdc`
- `.cursor/rules/02-local-optimizer-first.mdc`
- `.cursor/rules/03-public-note-and-paper-skill-bridge.mdc`
- `.cursor/rules/04-case-figure-and-metric-plan.mdc`
- `.cursor/rules/lexicon.md`

Treat these files as repository policy for Codex, Gemini CLI, Antigravity, and
other coding-agent work in this template. Antigravity compatibility is routed
through `GEMINI.md`.

For PowerLit writing/review handoff, also read
`.cursor/contracts/project-template-handoff.schema.yaml` and the active
`02_PAPER/config/paper-profile.yaml` (or its example). Keep reasoning policy in
the Skill and persistent state, MATLAB execution, manifests, and audit artifacts
in this template.

## Sync Policy

Paper sources follow rule 03: Markdown drafts live in `02_PAPER/manuscript/`;
formal LaTeX sources and publication figures live in `02_PAPER/latex/`.
Read `02_PAPER/formatting_rules.md` for the default IEEE PES journal template
and manuscript formatting conventions.

Rule 03 requires literature-backed engineering motivation, at least 40 verified
high-quality non-Chinese references for each concrete project, and maintained
`03_REFERENCE/Powerlit相关论文本地地址.txt` and `03_REFERENCE/专业术语表.md`.

Commit and push `.cursor/`, `AGENTS.md`, `GEMINI.md`, and `CLAUDE.md` changes
together with template changes. Do not treat agent rule files as editor-only
local state.

## Validation

All MATLAB plots must retain white backgrounds independently of the desktop
theme; follow the shared figure creation and export rules in rule 01.

This template intentionally ships without a default executable test runner.
Do not launch MATLAB automatically when copying or deploying the template.
Run only the project-specific checks explicitly selected by the author.
