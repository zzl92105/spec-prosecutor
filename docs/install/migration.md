# 从旧版迁移

0.2.0 的主安装方式是原生插件市场。旧版 `bin/spec-prosecutor add`、`install.sh` 和 Homebrew 安装的是独立 Skill 与兼容 CLI，仍保留其含义，不会暗中变成原生插件安装。

1. 用 README 中的命令安装原生插件，并确认插件列表与组件发现正常。
2. 在本仓库执行 `python3 scripts/migrate-install.py`，只查看要迁移的内容。
3. 确认后执行 `python3 scripts/migrate-install.py --apply`。
4. 项目副本须另行指定：`python3 scripts/migrate-install.py --project /path/to/project`；确认后加 `--apply`。
5. 新建会话，通过新插件调用。Codex 为 `$spec-prosecutor`，Claude 为 `/spec-prosecutor:spec-prosecutor`。

迁移会把匹配的 `.agents/skills/spec-prosecutor`、`.codex/skills/spec-prosecutor`、`.claude/skills/spec-prosecutor` 移至备份目录；个人市场中旧的 `spec-prosecutor` 条目会在保存完整配置副本后移除。其他插件条目不变。不会删除旧文件或更改其他项目。遇到符号链接或无法识别的目录会停止，避免移动未知内容。

用户级备份在 `~/.local/share/spec-prosecutor/backups/legacy-*`；项目级备份在项目的 `.spec-prosecutor-backups/legacy-*`。项目备份含原文件，勿提交到业务仓库。需要回退时先停用新插件，再将备份中的 Skill 目录移回原位置。市场配置回退需合并旧条目，避免覆盖迁移后新增的其他插件。

旧 `off` 副本也应迁移，否则可能让调用命中已禁用入口。`on/off` 仅控制独立 Skill；原生插件启停交给宿主。

如果只想继续独立 Skill，可更新整个 Skill 目录而不迁移。Git 拉取本仓库不会自动更新已复制或缓存的安装。
