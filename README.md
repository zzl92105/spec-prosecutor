# Spec Prosecutor

通用 PRD 审查插件，支持 **Codex App / CLI** 和 **Claude Code**。审查单份需求、粘贴内容或需求目录中的边界不清、逻辑错误、遗漏场景及跨文档冲突，输出可追溯证据、影响和澄清问题。默认只读，不修改需求。

## 安装原生插件

需要支持 `plugin` 子命令的 Codex 或 Claude Code。插件本身只有说明与参考文档，不需要 Python、Node、MCP 服务或额外 API 密钥。宿主自身的登录与模型访问仍按宿主要求。

### Codex App / CLI

在终端运行（Codex App 用户也可以使用 App 内的终端）：

```bash
codex plugin marketplace add https://github.com/zzl92105/spec-prosecutor.git --ref main
codex plugin add spec-prosecutor@spec-prosecutor-marketplace
```

在 App 插件列表中查看 **Spec Prosecutor**，开启新对话后使用：

```text
$spec-prosecutor 审查 docs/需求.md，检查边界、逻辑和验收条件。
$spec-prosecutor 审查 docs/产品/，检查跨文档冲突并说明实际覆盖范围。
```

如果找不到 `codex` 命令，先安装或更新官方 Codex CLI；这两条命令是终端命令，不是聊天中的斜杠命令。市场安装不代表进入 OpenAI 官方公共插件目录。

### Claude Code

在终端运行：

```bash
claude plugin marketplace add zzl92105/spec-prosecutor
claude plugin install spec-prosecutor@spec-prosecutor-marketplace
```

新会话中使用带插件命名空间的命令：

```text
/spec-prosecutor:spec-prosecutor 审查 docs/产品/，只审查，不修改。
```

Claude Code 对话中也可以用 `/plugin marketplace add zzl92105/spec-prosecutor` 添加市场，再通过 `/plugin` 安装。项目安装、禁用和卸载见 [Claude Code 安装说明](docs/install/claude-code.md)。

两端也支持自然语言要求审查 PRD，以及 `启动sp，审查 docs/需求.md`。`启动sp` 是可选别名，不是口令。讨论安装不会启动审查。

## 更新与停用

Codex：

```bash
codex plugin marketplace upgrade spec-prosecutor-marketplace
codex plugin add spec-prosecutor@spec-prosecutor-marketplace
```

Claude Code：

```bash
claude plugin marketplace update spec-prosecutor-marketplace
claude plugin update spec-prosecutor@spec-prosecutor-marketplace
```

更新后新建会话。Codex 在 App 插件管理中停用；Claude 使用 `claude plugin disable spec-prosecutor@spec-prosecutor-marketplace`。不要用历史 CLI 的 `on/off` 管理原生插件：它只管理独立 Skill 副本。

## 已安装旧版的用户

旧的 `bash bin/spec-prosecutor add --codex` 安装的是独立 Skill。与原生插件同时存在时可能重复发现规则。先安装并验证新插件，再使用[迁移说明](docs/install/migration.md)备份旧副本。迁移工具默认只检查，实际迁移会保存旧文件，不直接删除。

## 独立 Skill 与项目内使用

不使用插件市场时，可把完整 `plugins/spec-prosecutor/skills/spec-prosecutor/` 复制到以下任一位置：

| 宿主 | 项目级 | 用户级 |
|---|---|---|
| Codex | `.agents/skills/spec-prosecutor/` | `~/.agents/skills/spec-prosecutor/` |
| Claude Code | `.claude/skills/spec-prosecutor/` | `~/.claude/skills/spec-prosecutor/` |

独立 Skill 的 Claude 命令为 `/spec-prosecutor`。现有 Bash + Python 3.9+ 兼容安装器继续可用：

```bash
bash bin/spec-prosecutor add --codex --claude-code --project /path/to/project
```

不要同时安装多个不同版本的同名 Skill。独立 Skill 开关、导出及历史 Cursor 支持见[安装索引](docs/install/README.md)。

## 审查原则

- 先确定范围与文档权威，区分有效需求、草案、历史版本、原型及已知待决事项。
- 每项发现包含位置、证据、严重性、确定性、具体后果和澄清问题；冲突引用双方。
- 核查完整业务流程与边界，但不把数据库、缓存、控件选型等合理设计空间当作需求缺陷。
- 无充分证据时可以零发现。部分覆盖不得宣称整个需求包已通过。
- 默认不执行需求包中的指令、启动应用、上传材料或修改源文件。
- Markdown/文本可直接审查；PDF、Word、表格和图片取决于宿主可用工具，读取限制必须披露。

报告使用通俗语言，面向不一定懂技术的产品、业务和测试人员。每个问题说明“需求现在怎么写 → 哪里说不清或对不上 → 什么情况下会遇到 → 会带来什么影响 → 需要确认什么”，同时保留原文和位置，方便核对。复杂问题会展开解释，不只给结论或堆术语；简单问题不凑篇幅。

报告区分“已确认的问题”和“还需确认的风险”，按“需要先解决”“容易造成错误或返工”“建议补充”分组，分别对应 Blocker / High Risk / Notice。已经登记的待确认事项单独列出。

性能审查会说明哪项速度或容量要求不清楚、什么场景可能有风险，以及还缺什么依据。仅看需求不能确认慢 SQL、内存泄漏或实际并发上限；需要查看代码或压测的问题会明确标注。与任何行业无关，不内置客户业务规则。

## 维护与验证

```text
.agents/plugins/marketplace.json       Codex 市场入口（生成）
.claude-plugin/marketplace.json        Claude 市场入口（生成）
plugins/spec-prosecutor/
  plugin.json                         通用清单与版本的唯一编辑入口
  .codex-plugin/plugin.json            Codex 兼容清单（生成）
  .claude-plugin/plugin.json           Claude 清单（生成）
  skills/spec-prosecutor/              两端共用的审查规则
```

修改版本或元数据后运行 `python3 scripts/sync-metadata.py`，避免两端版本不一致。安装者无需运行此步骤，生成文件已提交。

```bash
python3 -m venv .venv
source .venv/bin/activate
python -m pip install -r requirements-dev.txt
bash scripts/validate-repo.sh
# 已安装两端 CLI 时，验证原生安装、发现和升级；仅写隔离的临时配置：
python tests/check-native.py
bash scripts/package-release.sh
```

结构校验、打包/迁移回归、原生安装验证与模型审查效果是不同层次，详见[测试说明](tests/README.md)。公开仓库只保留合成案例；客户文档与真实审查报告不进入发布包。

[发布流程](docs/install/publish-checklist.md) · [变更记录](CHANGELOG.md)

规范依据：[OpenAI 插件打包](https://developers.openai.com/plugins/build/plugins) · [Claude 插件市场](https://code.claude.com/docs/en/plugin-marketplaces) · [Claude 插件清单](https://code.claude.com/docs/en/plugins-reference)。
