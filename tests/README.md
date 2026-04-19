# Tests

The test corpus is organized as case directories under [tests/cases/](/Users/lm/个人资料/spec-prosecutor-bootstrap/tests/cases).

Each case should contain:

- `prd.md`
- `expected-report.md`

The expected report is a review baseline.
It is intended for qualitative regression, not exact string matching.

Run the automated fixture and export checks with:

```bash
bash scripts/run-regression-checks.sh
```

When adding a new case:

1. Pick a realistic PRD fragment.
2. Ensure it exercises at least one important ambiguity or dependency gap.
3. Write an expected report that follows the shared contract exactly.
4. Check whether the new case adds new coverage rather than duplicating an existing one.
