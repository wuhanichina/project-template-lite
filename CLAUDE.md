# CLAUDE.md

## Project Rules

Before editing code, documentation, comments, generated prose, or template
structure in this repository, read and follow:

- @.cursor/rules/00-lightweight-research-coding.mdc
- @.cursor/rules/01-matlab-code-style.mdc
- @.cursor/rules/02-local-optimizer-first.mdc
- @.cursor/rules/03-public-note-and-paper-skill-bridge.mdc
- @.cursor/rules/04-case-figure-and-metric-plan.mdc
- @.cursor/rules/lexicon.md

Treat the imported files as repository policy for Claude Code work in this
template. `AGENTS.md` is the shared coding-agent source of truth. PowerLit
handoff contracts live under `.cursor/contracts/`; do not create root-level
`.codex/` or `contracts/` directories for AI policy.

## Sync Policy

Follow rule 03 for `02_PAPER/manuscript/` Markdown drafts and the self-contained
formal manuscript under `02_PAPER/latex/`.
Read `02_PAPER/formatting_rules.md` for the default IEEE PES journal template
and manuscript formatting conventions.

Commit and push `.cursor/`, `AGENTS.md`, `GEMINI.md`, and `CLAUDE.md` changes
together with template changes. Keep these files as shared repository policy,
rather than editor-only local state.

## Validation

This template intentionally ships without a default executable test runner.
Do not launch MATLAB automatically when copying or deploying the template.
Run only the project-specific checks explicitly selected by the author.
