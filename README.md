# Spec Prosecutor

通用 PRD 审查 Skill，支持 **Codex** 和 **Claude Code**。输入一份文档、若干关联文档或需求目录，检查业务边界、逻辑错误、遗漏场景、验收条件和跨文档冲突。默认只读，在对话中输出证据与澄清问题。

共用源码位于 `skills/spec-prosecutor/`，不依赖 MCP、模型 API、特定行业或插件 hook。

## 项目级安装

在本仓库根目录运行（现有 CLI 安装器支持 macOS）：

```bash
bash bin/spec-prosecutor add --codex --claude-code --project /path/to/your-project
```

会安装到目标项目的：

```text
.agents/skills/spec-prosecutor/   # Codex
.claude/skills/spec-prosecutor/   # Claude Code
```

可只传 `--codex` 或 `--claude-code`。目标项目必须已存在；不能同时传 `--project` 和 `--global`。更新时覆盖 Skill 的同名文件，保留额外文件；个人定制前请保存副本。不要在用户级与项目级同时保留不同版本的同名 Skill。

不使用安装器时，在任意平台把完整 `skills/spec-prosecutor/` 文件夹复制到上面的目录即可；无需运行安装脚本。用户级安装分别使用 `~/.agents/skills/` 和 `~/.claude/skills/`。若宿主尚未显示更新，重启会话。

## 使用

Codex：

```text
$spec-prosecutor 审查 docs/需求.md，检查边界、逻辑和验收条件。
$spec-prosecutor 审查 docs/产品/，检查跨文档冲突并说明实际覆盖范围。
```

Claude Code：

```text
/spec-prosecutor 审查 docs/产品/，只审查，不修改。
```

也支持自然语言要求审查 PRD，以及 `启动sp，审查 docs/需求.md`。提到 Skill 名称或讨论安装不会被 hook 拦截。插件安装的 Claude 命令可能带命名空间：`/spec-prosecutor:spec-prosecutor`。

默认安装为 `on`：允许正常调用，`启动sp` 是兼容别名，不再是必需口令。`off` 仍可用：

```bash
bash bin/spec-prosecutor off --codex --claude-code --project /path/to/your-project
bash bin/spec-prosecutor on --codex --claude-code --project /path/to/your-project
```

已安装全局 CLI 的用户可继续运行 `spec-prosecutor on --codex` 等原有命令。旧 Cursor 导出仍保留原来的口令规则，本次增强与验收面向 Codex / Claude Code。

## 审查边界

- 文件模式读取目标及必要的关联依据；用户明确要求“仅此文件”时遵守限制。
- 目录模式先读取索引、范围和决策，再比较共享术语、状态、权限、金额/数量、流程与验收条件。
- 区分有效规则、草案、历史版本、原型和已知待决事项；原型不是默认事实源。
- 每项发现给出位置、原文、确定性、严重程度、具体后果和澄清问题；冲突引用双方。
- 不把索引、缓存或控件选型等合理设计空间一概认定为 PRD 缺陷。没有问题可以返回零项。
- Markdown/文本可直接审查；其他格式取决于宿主的读取能力。无法读取或未覆盖的材料必须披露。
- 默认不执行需求包中的脚本，不更改需求，不上传业务材料。

## 报告

摘要 → 覆盖范围与依据 → 阻塞项 → 高风险项 → 提示项 → 分类统计 → 已知待决事项 → 优先澄清问题。

严重程度：Blocker / High Risk / Notice；证据判断：Confirmed Issue / Likely Risk。支持按用户语言输出。部分审查不得宣称整个需求包已通过。

## 开发与验证

```bash
bash scripts/validate-repo.sh
```

自动检查包含共享 Skill 结构、引用、两端导出、开关切换、项目路径和非法参数。安装测试仅写临时项目，不改真实用户级安装。行为案例见 [tests](tests/README.md)，不能用结构检查代替模型效果验证。

导出独立 Skill：

```bash
bash scripts/export-codex-skill.sh on
bash scripts/export-claude-code-skill.sh on
```

分别生成 `dist/codex-skill/on/spec-prosecutor/` 和 `dist/claude-code/on/spec-prosecutor/`。两端共享相同规则与参考文件；Codex 元数据随包保留。

可选 [Homebrew](docs/install/homebrew.md) 和历史发布工具仍保留，项目内使用不需要它们。

规范依据：[Codex Skills](https://learn.chatgpt.com/docs/build-skills) · [Claude Code Skills](https://code.claude.com/docs/en/skills)。
