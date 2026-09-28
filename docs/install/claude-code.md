# Claude Code

[README](../../README.md#claude-code) 提供公开 GitHub 市场安装命令。

本地开发：

```bash
claude plugin validate . --strict
claude plugin validate ./plugins/spec-prosecutor --strict
claude plugin marketplace add .
claude plugin install spec-prosecutor@spec-prosecutor-marketplace
```

查看 `claude plugin list` 与 `claude plugin details spec-prosecutor`，确认 Skill 已发现。新会话用 `/spec-prosecutor:spec-prosecutor` 调用。`agents/openai.yaml` 随同共享 Skill 分发，但不是 Claude 运行依赖。

## 项目范围

在目标项目内执行：

```bash
claude plugin marketplace add zzl92105/spec-prosecutor --scope project
claude plugin install spec-prosecutor@spec-prosecutor-marketplace --scope project
```

项目设置可能需要提交供团队共享；不要提交个人认证信息。具体信任与启用仍由宿主管理。

## 管理

```bash
claude plugin disable spec-prosecutor@spec-prosecutor-marketplace
claude plugin enable spec-prosecutor@spec-prosecutor-marketplace
claude plugin marketplace update spec-prosecutor-marketplace
claude plugin update spec-prosecutor@spec-prosecutor-marketplace
```

项目安装的管理操作需使用对应 `--scope project`。更新后新建会话。卸载会移除安装注册与缓存：

```bash
claude plugin uninstall spec-prosecutor@spec-prosecutor-marketplace
```

## 独立 Skill

复制完整 `plugins/spec-prosecutor/skills/spec-prosecutor/` 到 `.claude/skills/` 或 `~/.claude/skills/`。这种方式使用 `/spec-prosecutor`，不带插件命名空间。不要与原生插件保留重复副本。

[官方插件市场文档](https://code.claude.com/docs/en/plugin-marketplaces)
