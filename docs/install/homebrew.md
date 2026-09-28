# Homebrew（历史兼容）

原生插件安装不需要 Homebrew，也不需要本项目 CLI。使用 [README](../../README.md) 的两端市场安装命令。

仓库保留 `Formula/spec-prosecutor.rb.template` 和 `scripts/render-homebrew-formula.sh`，供维护者发布独立 Skill 安装器。只有 tap 实际发布并验证后，才能提供其安装命令；本仓库不承诺外部 tap 当前可用。

生成 formula 前需存在与插件版本一致的 Git 标签：

```bash
bash scripts/render-homebrew-formula.sh zzl92105 spec-prosecutor
```

formula 固定标签与提交哈希。源码归档由 `bash scripts/package-release.sh` 输出至 `dist/release/`，名称为 `spec-prosecutor-v<version>-source.tar.gz`。
