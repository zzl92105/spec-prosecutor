# Activation Modes

`Spec Prosecutor` supports two install modes.

## Trigger Phrase

Auto mode uses one exact trigger phrase:

`启动sp`

If the user prompt does not contain that phrase, auto mode should stay inactive.

## Off Mode

- Disabled mode
- No implicit activation
- No manual activation
- Do not review PRDs while the package is installed in `off` mode
- If invoked anyway, respond that Spec Prosecutor is disabled and must be switched to `on` mode

## On Mode

- Implicit activation is enabled
- The skill should only activate when the prompt contains `启动sp`
- The phrase is a gate, not a suggestion
- Opening line: `Spec Prosecutor 已启动。接下来，这份 PRD 将失去被含糊其辞保护的权利。`

## Scope Rule In Both Modes

- Review only one explicitly provided Markdown PRD by default
- Do not scan unrelated files unless the user expands scope
