# coding-guidelines

Shared coding guidelines for AI-assisted development. Referenced by project-level instruction files (`CLAUDE.md`, `AGENTS.md`, etc.).

## Structure

- **`general.md`** — Language-agnostic engineering principles: simplicity, diagnosis discipline, testing, pre-commit checks, postmortem conventions.
- **`elisp.md`** — Emacs Lisp conventions: naming, control flow, error handling, state management, mode definitions, quality checks.
- **`java.md`** — Java conventions: naming, control flow, error handling, logging, version baseline discipline, quality checks.

## Usage

In a project's AI instruction file (e.g., `CLAUDE.md`, `AGENTS.md`), reference the relevant guideline files by path:

```markdown
Follow the guidelines in:
- ~/repos/coding-guidelines/general.md
- ~/repos/coding-guidelines/elisp.md
```

The AI agent reads these files on demand — no syncing or copying needed. Each project's instruction file only needs to contain project-specific rules (architecture, workflows, domain logic) that are not covered here.

## Maintenance

- Keep each file focused on **reusable, language-level or discipline-level** rules.
- Project-specific rules (architecture boundaries, protocol details, release workflows) stay in the project's own instruction file.
- When a rule applies to multiple projects, extract it here. When it only applies to one, leave it in that project.
