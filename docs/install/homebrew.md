# Homebrew Install

`Spec Prosecutor` can be distributed on macOS through a Homebrew tap.

## Target Install Flow

Once the release assets and tap are published, the install path will be:

```bash
brew tap <owner>/tap
brew install spec-prosecutor
spec-prosecutor doctor
spec-prosecutor init -g --mode off
spec-prosecutor init -g --codex --mode off
spec-prosecutor init --agent cursor --mode off --cursor-workspace /path/to/project
```

`<owner>/tap` is still a placeholder here. Replace it with the real published tap.

For phrase-gated auto mode:

```bash
spec-prosecutor init -g --mode on
spec-prosecutor init -g --codex --mode on
spec-prosecutor init --agent cursor --mode on --cursor-workspace /path/to/project
```

## Release Assets Required

Homebrew distribution expects:

- a versioned macOS release archive
- a `sha256` checksum for that archive
- a Homebrew formula pointing at the release URL

This repository includes helpers for all three:

- `scripts/package-release.sh`
- `scripts/render-homebrew-formula.sh`
- `Formula/spec-prosecutor.rb.template`

## Packaging

Build the macOS release archive:

```bash
bash scripts/package-release.sh
```

This generates files under `dist/release/`, including:

- `spec-prosecutor-v<version>-macos.tar.gz`
- `spec-prosecutor-v<version>-macos.tar.gz.sha256`

## Formula Rendering

After the GitHub repository and release tag are known, render the formula with:

```bash
bash scripts/render-homebrew-formula.sh <owner> <repo>
```

That writes:

- `dist/release/homebrew/spec-prosecutor.rb`

The rendered formula points to:

```text
https://github.com/<owner>/<repo>/releases/download/v<version>/spec-prosecutor-v<version>-macos.tar.gz
```

## Tap Publishing

Recommended structure:

```text
<owner>/homebrew-tap
  Formula/
    spec-prosecutor.rb
```

Then users can install with:

```bash
brew tap <owner>/tap
brew install spec-prosecutor
```
