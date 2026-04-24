# coding-guidelines

Shared coding guidelines for AI-assisted development. Use them as source material for project-level instruction files (`CLAUDE.md`, `AGENTS.md`, etc.).

## Structure

- **`general.md`** — Language-agnostic engineering principles: simplicity, diagnosis discipline, testing, pre-commit checks, postmortem conventions.
- **`elisp.md`** — Emacs Lisp conventions: naming, control flow, error handling, state management, mode definitions, quality checks.
- **`java.md`** — Java conventions: naming, control flow, error handling, logging, version baseline discipline, quality checks.

## Usage

For each project, copy the rules you actually want into that project's own AI instruction file (e.g., `CLAUDE.md`, `AGENTS.md`) and adapt the wording to the project.

```markdown
## Shared Rules

- Prefer simple solutions over clever abstractions.
- Run the full test suite before committing.
- Run `checkdoc` and `package-lint` with zero warnings for Emacs Lisp packages.
```

Do not treat this repository as something the agent must reference at runtime. The project's own instruction file should be self-contained, with shared rules copied in and project-specific rules added alongside them.

## Maintenance

- Keep each file focused on **reusable, language-level or discipline-level** rules.
- Project-specific rules (architecture boundaries, protocol details, release workflows) stay in the project's own instruction file.
- When a rule applies to multiple projects, extract it here. When it only applies to one, leave it in that project.
