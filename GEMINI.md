# GEMINI.md

## Project Rules

This file is a thin compatibility entry for Gemini CLI and Google Antigravity
contexts that read `GEMINI.md` at the workspace root.

Before editing code, documentation, comments, generated prose, or template
structure in this repository, read and follow:

- `AGENTS.md`
- `.cursor/rules/00-lightweight-research-coding.mdc`
- `.cursor/rules/01-matlab-code-style.mdc`
- `.cursor/rules/02-local-optimizer-first.mdc`
- `.cursor/rules/03-public-note-and-paper-skill-bridge.mdc`
- `.cursor/rules/04-case-figure-and-metric-plan.mdc`
- `.cursor/rules/lexicon.md`

Treat `AGENTS.md` and `.cursor/rules/` as the shared source of truth. Keep this
file short so Antigravity, Gemini, Codex, and Claude entrypoints do not drift.

## Sync Policy

Commit and push `.cursor/`, `AGENTS.md`, `GEMINI.md`, `CLAUDE.md`, `.agents/`,
and `.agent/` changes together with template changes. Do not treat agent rule
files as editor-only local state.
