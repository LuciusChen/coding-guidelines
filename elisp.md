## Elisp Best Practices

### No Side Effects on Load

Loading a file must not alter Emacs behavior. Activation must be explicit (user calls a command or enables a mode).

### Naming

- **Public functions**: use a consistent package prefix (e.g., `clutch-`, `my-`). No double dash for public API.
- **Private/internal**: double-dash prefix (e.g., `clutch--helper`). Never call from outside the owning subsystem.
- **Predicates**: multi-word names end in `-p`.
- **Unused args**: prefix with `_`.

### Control Flow

- Avoid deep `let` -> `if` -> `let` chains. Favor flat, linear control flow.
- Use `if-let*`, `when-let*` for conditional binding.
- Use `pcase` / `pcase-let` for structured destructuring instead of nested `car`/`cdr`/`nth`.
- Prefer `cl-loop` over `dolist` + manual accumulators for non-trivial iteration. `cl-reduce` is acceptable for simple single-operation folds.

### Data Shape and Abstraction

- Prefer `let*`, `pcase-let`, alists/plists, small helpers, or table-driven mappings for short-lived context.
- Reserve `cl-defstruct` or object-style layers for stable data that crosses module or lifecycle boundaries, such as connection, result, request, or protocol state.
- A short, linear `let*` is often clearer than a one-use context object plus accessors.
- Treat helper piles as design debt. If several private functions only rename, strip, forward, or wrap data for one call path, collapse them into direct code or a table-driven mapping. If the helpers are hiding a larger ownership problem, extract the whole workflow with its state and commands instead of creating a vague `utils` module.

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
- Rendering should be deterministic from structured buffer-local state. Do not derive behavior from visible strings when text properties or cached data can carry the state.

### Autoloads

- Add `;;;###autoload` to user-facing commands (entry points users call via `M-x`) and user-facing minor modes.
- Do NOT autoload internal helpers, variables, or private modes.
- Internal modes that are not part of the user-facing API should use double-dash prefix (`pkg--foo-mode`).

### Completion

- Completion-at-point functions should stay close to the Emacs protocol: compute bounds and candidates directly, return the standard completion list, and avoid a separate completion context model unless multiple real call paths share it.
- CAPFs should return quickly and avoid synchronous work that can re-enter or block the UI unless the backend explicitly supports it.

### Dependencies

- `cl-lib` functions require `(require 'cl-lib)` — do not rely on transitive loading.
- Avoid `eval-when-compile` for runtime-needed dependencies.
- When split modules use functions or variables from sibling files, add explicit `declare-function` or `defvar` forms so byte-compilation remains honest.

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
