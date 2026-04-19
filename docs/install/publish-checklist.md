# Publish Checklist

Use this checklist before announcing GitHub direct installation or Homebrew installation.

## Pre-Publish

1. Choose the final GitHub repository slug.
2. Run:

```bash
bash scripts/set-github-repo.sh <owner> <repo>
```

3. Re-run:

```bash
bash scripts/validate-repo.sh
bash scripts/export-all.sh
bash scripts/package-release.sh
bash scripts/render-homebrew-formula.sh <owner> <repo>
```

4. Verify the direct-install docs now show the real repository:

- [README.md](../../README.md)
- [docs/install/github-direct.md](github-direct.md)
- [docs/install/homebrew.md](homebrew.md)
- [/.codex-plugin/plugin.json](../../.codex-plugin/plugin.json)

## GitHub Publish

1. Push the repository to the final GitHub remote.
2. Confirm the repository is public if you want `npx skills add <owner>/<repo>` to work for others.
3. Create a GitHub release tagged `v<version>` and upload:

- `spec-prosecutor-v<version>-macos.tar.gz`
- `spec-prosecutor-v<version>-macos.tar.gz.sha256`
- `dist/release/homebrew/spec-prosecutor.rb`

4. Push the rendered formula to your tap repository under `Formula/spec-prosecutor.rb`.
5. Test both install paths from a clean environment after publish:

- `npx skills add <owner>/<repo> --skill spec-prosecutor -a claude-code -a codex -a cursor`
- `brew tap <owner>/tap`
- `brew install spec-prosecutor`

Do not leave `<owner>/tap` as a placeholder in user-facing docs once the tap is published.
