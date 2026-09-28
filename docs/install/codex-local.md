# Codex

推荐使用 [README 中的 Git 市场安装](../../README.md#codex-app--cli)。

## 本地开发

在本仓库根目录执行：

```bash
codex plugin marketplace add .
codex plugin add spec-prosecutor@spec-prosecutor-marketplace
```

`source.path` 相对仓库根目录解析，真实插件在 `plugins/spec-prosecutor/`。安装后通过 `codex plugin list` 或 App 插件页检查，然后新建对话调用 `$spec-prosecutor`。

本地市场与 Git 市场使用同一个市场名称。切换来源前用 `codex plugin marketplace list` 确认当前来源；不要把一次本地安装误认为会自动跟踪 GitHub 更新。官方 CLI 若拒绝替换同名来源，先用 `codex plugin marketplace remove spec-prosecutor-marketplace` 移除该来源，再添加目标来源。

Git 市场版本更新：先 `marketplace upgrade`，再执行 `plugin add`。本地市场不支持 `marketplace upgrade`，直接重新执行 `plugin add`。开发中的同版本缓存问题可用临时构建元数据版本解决；正式发布始终递增版本并同步所有清单。

## 管理

App 插件页可开启或停用插件。卸载命令（会移除安装缓存）：

```bash
codex plugin remove spec-prosecutor@spec-prosecutor-marketplace
```

项目启用策略由受信任项目的 `.codex/config.toml` 控制：

```toml
[plugins."spec-prosecutor@spec-prosecutor-marketplace"]
enabled = true
```

## 独立 Skill

复制 `plugins/spec-prosecutor/skills/spec-prosecutor/` 到项目 `.agents/skills/` 或用户 `~/.agents/skills/`。保持整个目录完整。这种安装不出现在插件管理列表中；开关使用历史 CLI 的 `on/off`，不要与原生插件同时保留。

[官方插件文档](https://developers.openai.com/plugins/build/plugins)
