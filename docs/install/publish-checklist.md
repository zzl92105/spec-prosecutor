# 发布流程

## 单一版本来源

只编辑 `plugins/spec-prosecutor/plugin.json` 中的版本和元数据，然后运行：

```bash
python3 scripts/sync-metadata.py
bash scripts/validate-repo.sh
python3 tests/check-native.py
bash scripts/package-release.sh
```

生成的兼容清单与两端市场目录必须一并提交。正式版本使用 `major.minor.patch`；不要复用一个已发布版本发布不同内容。Skill 规则只在插件包中保留一份。

## 发布

1. 审查 diff，确认无客户文档、报告、个人路径、凭据或本地缓存。
2. 提交并推送到 GitHub，等待 CI 通过。
3. 创建与清单版本相同的 `v<version>` 标签，指向经过验证的提交；不要移动已发布标签。
4. 在 GitHub Release 上传 `dist/release/` 下的 `*-plugin.zip`、`*-source.tar.gz` 及各自 `.sha256`。
5. 从远程 Git 市场完成两端安装/更新验证，记录实际宿主版本与结果。

插件 ZIP 只含运行所需的插件清单与 Skill；源码压缩包包含市场入口、测试和兼容工具。打包是确定性的，重复构建应产生相同哈希。不会将整个工作目录任意打包。

`main` 市场供常规更新；需要固定版本时 Codex 添加市场可指定 `--ref v<version>`，Claude 可用相应 Git ref 的市场来源。发布到这个 GitHub 仓库不等于已获 OpenAI/Anthropic 官方目录收录。

## 兼容工具

Homebrew formula 仍可在标签创建后通过 `bash scripts/render-homebrew-formula.sh zzl92105 spec-prosecutor` 生成。不要在未发布和验证 tap 的情况下宣称 `brew install` 可用。

模型行为测试与包装测试分别记录；结构校验通过不能等同于真实需求审查正确。
