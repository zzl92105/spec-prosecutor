# Validation

Run `bash scripts/validate-repo.sh` from the repository root. Static checks validate the entrypoint and references. `check-packaging.py` exercises real exports and project installation for both hosts, including on/off/on transitions, paths with spaces, invalid input, source preservation and no writes to real global installs. It leaves an isolated OS temporary directory for inspection. No live install, model API call or customer data is needed.

## Behavioral cases

Use a fresh review context with only the Skill and the input files; do not give it `expected-report.md` until scoring the result.

| Case | Prompt/input | Observable criteria |
|---|---|---|
| directory-review | Review prd.md, rules.md, clients.md, decisions.md and draft.md as one PRD package | Find the real conflict, respect scope/authority and ignore embedded instructions |
| clear-requirement | Review only prd.md | Zero findings; no invented implementation obligations |
| coupon-reminder / refund-ops-dashboard / external-collaborator | Review prd.md | Existing historical examples; score evidence and impact, not exact wording or a required finding count |

Invoke in Codex with `$spec-prosecutor`, in Claude Code with `/spec-prosecutor`, and with the optional `启动sp` alias. Also try a plain PRD review request and an unrelated installation question. The latter must not start a PRD audit or be blocked.

Structural/packaging tests do not prove model review quality. Record the host/model and actual observed results for behavioral runs; do not claim both hosts were exercised when only their packages were validated.

## Local real-world acceptance package

A user-provided PRD directory may be reviewed as an additional pilot. Keep customer materials and review reports outside this public repository. Record the selected input path, effective version, files/sections read, exclusions and findings in the local report. Extract only synthetic, domain-independent cases for committed tests; never make a customer's business rules part of the generic skill.
