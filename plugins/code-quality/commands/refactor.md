---
name: refactor
description: Analyze code and suggest refactoring improvements
---

Examine the files the user specifies (or the current working directory if none are given) and identify concrete refactoring opportunities. Focus on the following areas:

1. **DRY violations** -- Find duplicated logic or repeated code blocks that should be extracted into shared functions, utilities, or constants.
2. **Long methods** -- Identify functions or methods that are doing too much. Suggest how to break them into smaller, single-responsibility units.
3. **Complex conditionals** -- Spot deeply nested if/else chains, long switch statements, or boolean expressions that could be simplified with early returns, guard clauses, strategy patterns, or lookup tables.
4. **Poor abstractions** -- Look for leaky abstractions, god classes, classes or modules with too many responsibilities, and suggest better boundaries.
5. **Opportunities for patterns** -- Where applicable, recommend well-known design patterns (factory, strategy, observer, etc.) that would improve clarity and maintainability.

For each refactoring opportunity, provide:

```
## Refactoring Opportunities

### 1. [Title of refactoring] (file:line-range)
**Problem:** What is wrong and why it matters.
**Approach:** Which refactoring technique to apply (e.g., Extract Method, Replace Conditional with Polymorphism).
**Before:**
\`\`\`
<current code snippet>
\`\`\`
**After:**
\`\`\`
<refactored code snippet>
\`\`\`
**Impact:** Brief explanation of the improvement (readability, testability, performance, etc.).
```

Prioritize suggestions by impact -- list the highest-value refactors first. Be pragmatic: do not suggest refactors that add unnecessary complexity or abstraction for the sake of it. If the code is already well-structured, acknowledge that and note any minor polish opportunities.
