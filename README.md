# Spec Prosecutor

`Spec Prosecutor` is a PRD review skill for engineers before implementation starts.

It reviews one explicitly provided Markdown PRD and returns a structured prosecutor-style report focused on implementation readiness: ambiguity, vague scope, inaccurate definitions, missing scenarios, unverifiable requirements, and missing implementation dependencies.

## What It Does

- Reviews one explicit Markdown PRD at a time
- Outputs a structured indictment-style report for engineering self-check
- Distinguishes `Confirmed Issue` from `Likely Risk`
- Supports `off` mode and phrase-gated `on` mode
- Can be installed into Claude Code, Codex, and Cursor on macOS

## Install

Homebrew install after the tap is published:

```bash
brew tap <owner>/tap
brew install spec-prosecutor
```

The tap name is still a placeholder here. Replace `<owner>/tap` with the real published tap before using it.

Check the installation:

```bash
spec-prosecutor doctor
spec-prosecutor version
```

Single-command install for CLI plus selected hosts:

```bash
bash install.sh --codex --mode on
bash install.sh --claude-code --mode on
bash install.sh --codex --claude-code --mode on
```

Install into Claude Code, Codex, and Cursor:

```bash
spec-prosecutor add -g                     # Claude Code
spec-prosecutor add -g --codex            # Codex
spec-prosecutor add --agent cursor --mode off --cursor-workspace /path/to/project
```

Phrase-gated auto mode:

```bash
spec-prosecutor add -g --mode on          # Claude Code
spec-prosecutor add -g --codex --mode on  # Codex
spec-prosecutor add --agent cursor --mode on --cursor-workspace /path/to/project
```

After Codex installation, start a new Codex session so the new skill is included in the next session's skill list.

Natural mode switching:

```bash
spec-prosecutor on -g
spec-prosecutor on --codex
spec-prosecutor 开启 --agent cursor --cursor-workspace /path/to/project

spec-prosecutor off -g
spec-prosecutor off --codex
spec-prosecutor 关闭 --agent cursor --cursor-workspace /path/to/project
```

Uninstall:

```bash
spec-prosecutor remove -g
spec-prosecutor remove --codex
spec-prosecutor remove --codex --claude-code --cli
spec-prosecutor remove --all --cli
spec-prosecutor remove --agent cursor --cursor-workspace /path/to/project
```

## Usage

Use `Spec Prosecutor` inside Codex, Claude Code, or Cursor.

在 Codex、Claude Code 或 Cursor 中使用 `Spec Prosecutor`。

After installation, inside the agent conversation:

安装完成后，在 agent 对话里这样使用：

`off` mode:

- disabled
- 不生效，也不提供手动触发
- example:

```text
Spec Prosecutor 当前处于 off 模式，不执行审查。请切换到 on 模式后再使用。
```

```text
Spec Prosecutor is disabled in off mode. Switch to on mode before using it.
```

`on` mode:

- the prompt must include the exact trigger phrase `启动sp`
- 必须带精确触发短语 `启动sp`
- example:

```text
启动sp，审查这份 PRD，并输出结构化起诉书。
```

```text
启动sp，review this PRD and return a structured indictment report.
```

Default scope:

- review one explicitly provided Markdown PRD at a time
- do not expand to unrelated files unless the user asks
- 默认一次只审一份用户显式提供的 Markdown PRD
- 除非用户明确扩展范围，否则不要扫描无关文件

For Codex CLI, the local install target is:

- `~/.agents/skills/spec-prosecutor/`

## Modes

- `off`
  Disabled mode. No implicit activation and no manual activation.
- `on`
  Armed auto mode. Activation requires the exact phrase `启动sp`.

Mode preambles:

- `on`: `Spec Prosecutor 已启动。接下来，这份 PRD 将失去被含糊其辞保护的权利。`

## Review Contract

- Input: one Markdown PRD explicitly provided by the user
- Output: one report with fixed sections and fixed finding fields
- Required finding fields: `source_excerpt`, `charge`, `severity`, `assessment`, `problem`, `implementation_risk`, `follow_up_question`
- Required charge categories:
  - `Ambiguity`
  - `Vagueness`
  - `Inaccurate Definition`
  - `Missing Scenarios`
  - `Unverifiable Requirement`
  - `Missing Implementation Dependency`
- Required severity levels:
  - `Blocker`
  - `High Risk`
  - `Notice`

Core references:

- [skills/spec-prosecutor/SKILL.md](skills/spec-prosecutor/SKILL.md)
- [skills/spec-prosecutor/references/contract.md](skills/spec-prosecutor/references/contract.md)
- [skills/spec-prosecutor/references/checklists.md](skills/spec-prosecutor/references/checklists.md)
- [skills/spec-prosecutor/references/report-template.md](skills/spec-prosecutor/references/report-template.md)
- [skills/spec-prosecutor/references/modes.md](skills/spec-prosecutor/references/modes.md)

## Homebrew Packaging

This repository already includes the assets needed to prepare a Homebrew release:

```bash
bash scripts/package-release.sh
bash scripts/render-homebrew-formula.sh <owner> <repo>
```

See [docs/install/homebrew.md](docs/install/homebrew.md).

## Development

Validation:

```bash
bash scripts/validate-repo.sh
bash scripts/run-regression-checks.sh
```

Regression fixtures:

- [tests/cases/](tests/cases)
