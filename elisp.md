## Elisp Best Practices

### No Side Effects on Load

Loading a file must not alter Emacs behavior. Activation must be explicit (user calls a command or enables a mode).

### Naming

- **Public functions**: use a consistent package prefix (e.g., `clutch-`, `my-`). No double dash for public API.
- **Private/internal**: double-dash prefix (e.g., `clutch--helper`). Never call from outside the defining file.
- **Predicates**: multi-word names end in `-p`.
- **Unused args**: prefix with `_`.

### Control Flow

- Avoid deep `let` -> `if` -> `let` chains. Favor flat, linear control flow.
- Use `if-let*`, `when-let*` for conditional binding.
- Use `pcase` / `pcase-let` for structured destructuring instead of nested `car`/`cdr`/`nth`.
- Prefer `cl-loop` over `dolist` + manual accumulators for non-trivial iteration. `cl-reduce` is acceptable for simple single-operation folds.

### Error Handling

- **`user-error`** for user-caused problems. Does NOT trigger `debug-on-error`.
- **`error`** for programmer bugs only.
- **`condition-case`** for recoverable failures. Wrap non-essential operations so errors never block primary results.
- Error messages should state what is wrong, not what should be (e.g., "Not connected" not "Must be connected").

### State Management

- **`defvar-local`** for all per-buffer state. Set with `setq-local` in mode bodies.
- **Plain `defvar`** for global/shared state.
- **`defcustom`** for user-configurable values. Always specify `:type` precisely (`natnum`, `string`, `boolean`, `(choice ...)`) and `:group`.
- Major modes must make their state buffer-local.

### Mode Definitions

- Read-only UI buffers derive from `special-mode`.
- Editing buffers derive from the right parent (`sql-mode`, `comint-mode`, etc.).
- Register buffer-local hooks in the mode body with LOCAL=`t`.

### Rendering

- Use text properties for data-bearing annotations; overlays only for ephemeral visuals.
- Build render buffers from cached data, not by reparsing displayed text.

### Autoloads

- Add `;;;###autoload` to user-facing commands (entry points users call via `M-x`) and user-facing minor modes.
- Do NOT autoload internal helpers, variables, or private modes.
- Internal modes that are not part of the user-facing API should use double-dash prefix (`pkg--foo-mode`).

### Dependencies

- `cl-lib` functions require `(require 'cl-lib)` — do not rely on transitive loading.
- Avoid `eval-when-compile` for runtime-needed dependencies.

### Quality Checks

- Every file starts with `;;; -*- lexical-binding: t; -*-`.
- Every file ends with `(provide 'pkg)` / `;;; pkg.el ends here`.
- Byte-compile with zero warnings.
- Run `checkdoc` with zero warnings.
- Run `package-lint` with zero warnings for distributable package files.
- Treat byte-compilation, `checkdoc`, and `package-lint` as mandatory pre-commit quality gates for MELPA/ELPA-style packages.
- All public functions must have docstrings.
- Docstring first line must be a complete sentence ending with a period.
- Argument names in docstrings should be UPPERCASED.

### MELPA / Package Conventions

- First line: `;;; file.el --- Short description -*- lexical-binding: t; -*-`
  - Description must NOT contain "for Emacs" or the package name — both are redundant.
  - Keep the description under 60 characters.
- Required headers for the main package file: `;; Author:`, `;; URL:`, `;; Version:`, `;; Package-Requires:` (list all direct dependencies with minimum versions).
- Last line: `;;; file.el ends here`
- Before using a newer Emacs API, verify when the symbol was introduced (`M-x find-function`). Guard or avoid symbols above the project's declared baseline.
