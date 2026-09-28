# 安装索引

推荐使用原生插件市场：

- [Codex](codex-local.md)
- [Claude Code](claude-code.md)
- [旧版迁移与恢复](migration.md)
- [GitHub 与本地源码](github-direct.md)
- [发布流程](publish-checklist.md)

兼容入口：独立 Skill 安装器需要 Bash 与 Python 3.9+。`bash bin/spec-prosecutor add --codex --claude-code --project /path/to/project` 安装项目副本；省略 `--project` 使用用户目录。`on/off` 切换的也是这些副本。它不会登记原生插件。

[Homebrew](homebrew.md) 和 [Cursor](cursor.md) 仅是历史兼容方式，不是本插件两端的推荐安装入口。
