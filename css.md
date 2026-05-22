## CSS Best Practices

### Tooling and Scope

- Use a formatter and Stylelint or equivalent checks for mechanical consistency, invalid syntax, and obvious mistakes.
- Prefer classes for styling. Reserve IDs for anchors, browser behavior, or JavaScript integration unless the project has a deliberate specificity strategy.
- Keep global CSS small and intentional: resets, base element rules, design tokens, utilities, and truly global layout primitives.
- Co-locate component styles with the component when the stack supports it. If styles are global, use a naming convention that makes ownership obvious.

### Selectors and Specificity

- Keep selectors shallow and specificity low. Prefer a class selector over long descendant chains.
- Avoid styling through incidental DOM structure. A selector should describe the component, part, state, or utility it owns.
- Avoid `!important`. Use it only for narrow utility layers, external overrides, or accessibility fixes where the override boundary is explicit.
- Do not style elements by framework-generated class names, unstable IDs, or third-party DOM internals unless the integration boundary documents that dependency.
- Use state classes, ARIA attributes, data attributes, or parent state selectors intentionally. Do not infer important state from visual-only class names.

### Naming and Ownership

- Follow the project's existing naming convention. If there is no convention for global CSS, use component-scoped names with clear block, element, and modifier/state relationships.
- Name classes for role, ownership, or state, not for the current visual value. Prefer `.filter-panel` or `.is-active` over `.blue-box`.
- Do not encode long chains of nested parts into class names. If a part needs independent ownership, make it a new component or block.
- Keep utility classes small and single-purpose. Do not turn a utility into a hidden component by adding many unrelated declarations.

### Cascade Architecture

- Define source order deliberately: tokens and resets first, then base rules, layout primitives, components, utilities, and overrides.
- Use cascade layers when the project already uses them or when they clarify large-scale ordering. Do not introduce layers for a small stylesheet without a real ordering problem.
- Keep responsive rules near the component or layout they modify unless the project has a clear breakpoint architecture.
- Keep browser hacks, compatibility fallbacks, and third-party overrides isolated and commented with the reason they exist.

### Values and Design Tokens

- Use design tokens or CSS custom properties for repeated colors, spacing, typography, elevation, and motion values.
- Avoid magic numbers. If a value encodes a layout constraint, name the constraint or put it in the owning component.
- Prefer relative units for typography and scalable spacing where user settings should matter. Use pixels for borders, hairlines, and fixed assets when appropriate.
- Use logical properties (`margin-inline`, `padding-block`, etc.) when directionality could matter.
- Prefer modern layout primitives (`grid`, `flex`, intrinsic sizing, `minmax`, `clamp`) over fixed viewport assumptions.

### Responsive and Accessible UI

- Design styles for a range of container and viewport sizes. Avoid rules that only work at one fixed width.
- Do not remove focus indicators unless you provide an equally visible replacement.
- Respect `prefers-reduced-motion` for non-essential animation and transitions.
- Do not rely on color alone to communicate state. Pair color with text, shape, iconography, or ARIA state where appropriate.
- Maintain readable contrast and hit targets when changing color, spacing, or density.

### Maintainability

- Remove unused selectors when deleting markup or components.
- Keep comments for non-obvious constraints, browser workarounds, and cross-file ordering rules. Do not comment ordinary declarations.
- Test styles in the real rendering context for layout-sensitive changes. Static linting does not prove that content wraps, focus states remain visible, or responsive layouts hold.
