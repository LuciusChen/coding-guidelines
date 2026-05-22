## TypeScript Best Practices

### Compiler and Lint Baseline

- Use `strict` TypeScript for new projects. Do not weaken compiler options to get one change through; narrow the type problem or isolate the compatibility boundary.
- Use `typescript-eslint` or equivalent typed linting for rules that require type information. Disable a typed rule only with a local explanation.
- Keep the TypeScript version and emitted JavaScript target explicit. Do not use syntax, library types, or compiler features above the project baseline without updating build and documentation together.

### Type Strategy

- Prefer `unknown` for untrusted boundary data and narrow it with runtime checks. Use `any` only at compatibility boundaries, and keep it from flowing into domain code.
- Do not use type assertions as validation. `value as T` changes the compiler's view, not the runtime value.
- Keep assertions local and justified by nearby evidence. Avoid double assertions such as `value as unknown as T`.
- Avoid non-null assertions (`!`) unless the invariant is established in the same scope or by a documented framework lifecycle guarantee.
- Use discriminated unions for values that have modes, states, or variants. Avoid parallel booleans that can represent impossible combinations.
- Prefer readonly data shapes for values that should not be mutated by consumers.

### Inference and Annotations

- Let TypeScript infer trivially local types from literals, constructors, and function returns when the inferred type is clear.
- Annotate exported functions, public class members, reusable object shapes, and callbacks that form an API boundary.
- Name types after the domain concept they model, not after their current storage or transport format.
- Use `interface` for object shapes intended to be extended or implemented; use `type` for unions, intersections, mapped types, and aliases. Follow the existing project convention when one exists.
- Do not use `{}` to mean "object with fields." Prefer `object`, `Record<string, unknown>`, a named interface, or `unknown`, depending on what is actually known.

### Generics and Type-Level Code

- Add a generic parameter only when it connects at least two positions or preserves information for the caller.
- Prefer simple named types over deeply nested conditional, mapped, or template literal types. Complex type-level code needs the same ownership and tests as runtime code.
- Use overloads or discriminated options when they make call sites clearer than a single wide generic.
- Keep utility types close to the domain that needs them until multiple real call paths share the same rule.

### Modules and Runtime Boundaries

- Use `import type` / `export type` when an import or export is type-only and the project tooling preserves that distinction.
- Keep public API types near the runtime code that enforces them. A type definition without matching runtime validation is only a compile-time promise.
- Validate JSON, environment variables, URL params, local storage, postMessage payloads, and external API responses before treating them as typed data.
- Avoid ambient globals and declaration merging except at explicit platform or library integration boundaries.

### Classes and Objects

- Prefer plain objects, functions, and discriminated unions for data transformations.
- Use classes when they protect invariants, manage resources, or provide a stable stateful abstraction.
- Keep constructors cheap and unsurprising. Put async work, I/O, and registration in explicit factory or start methods.
- Mark fields and methods `private`, `protected`, or `public` intentionally. Do not expose state just to make tests reach it.

### Error Handling

- Narrow caught values before using them. A caught value is not guaranteed to be an `Error`.
- Preserve causes when wrapping errors and include the domain context needed by the boundary handler.
- Model expected domain failures explicitly when callers should branch on them; reserve thrown errors for exceptional or boundary-level failures.

### Testing

- Add type-level tests for exported utility types, library APIs, or public overloads when runtime tests cannot prove the contract.
- Include at least one runtime test for each boundary validator. Type-only checks do not prove external data is valid.
- Do not satisfy TypeScript by weakening assertions in tests. Test helpers should keep the same strictness as production code.
