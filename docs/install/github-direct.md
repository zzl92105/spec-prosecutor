# GitHub 与本地源码

公开源代码：[zzl92105/spec-prosecutor](https://github.com/zzl92105/spec-prosecutor)。

直接使用 README 中的原生市场命令即可安装，无需克隆、运行本项目安装脚本或配置作者机器路径。

需要开发或独立 Skill 时：

```bash
git clone https://github.com/zzl92105/spec-prosecutor.git
cd spec-prosecutor
```

插件根目录：`plugins/spec-prosecutor/`。共享 Skill：`plugins/spec-prosecutor/skills/spec-prosecutor/`。仅复制 `SKILL.md` 会丢失参考文档，应复制完整目录。

本地原生插件安装见 [Codex](codex-local.md) 和 [Claude Code](claude-code.md)。安装后的缓存与源码分开，修改源码后要按宿主更新流程刷新。
