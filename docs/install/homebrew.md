# Homebrew Install

`Spec Prosecutor` can be distributed on macOS through a Homebrew tap.
The recommended formula source is the GitHub tag archive for the main repository.

## Target Install Flow

Once the release assets and tap are published, the install path will be:

```bash
brew tap zzl92105/tap
brew install spec-prosecutor
spec-prosecutor doctor
spec-prosecutor init -g --mode off
spec-prosecutor init -g --codex --mode off
spec-prosecutor init --agent cursor --mode off --cursor-workspace /path/to/project
```

For phrase-gated auto mode:

```bash
spec-prosecutor init -g --mode on
spec-prosecutor init -g --codex --mode on
spec-prosecutor init --agent cursor --mode on --cursor-workspace /path/to/project
```

## Tag Required

Before rendering the formula:

- push the source repository commit
- create and push the version tag, for example `v0.1.2`
- make sure the tag archive URL is reachable on GitHub

The formula renderer downloads the tag archive directly and computes the `sha256` for you.

## Optional Release Archive

This repository still includes release packaging helpers if you also want a standalone macOS archive:

- `scripts/package-release.sh`
- `scripts/render-homebrew-formula.sh`
- `Formula/spec-prosecutor.rb.template`

## Optional Packaging

Build the macOS release archive:

```bash
bash scripts/package-release.sh
```

This generates files under `dist/release/`, including:

- `spec-prosecutor-v<version>-macos.tar.gz`
- `spec-prosecutor-v<version>-macos.tar.gz.sha256`

## Formula Rendering

After the GitHub repository and tag are pushed, render the formula with:

```bash
bash scripts/render-homebrew-formula.sh zzl92105 spec-prosecutor
```

That writes:

- `dist/release/homebrew/spec-prosecutor.rb`

The rendered formula points to:

```text
https://github.com/zzl92105/spec-prosecutor/archive/refs/tags/v<version>.tar.gz
```

## Tap Publishing

Recommended structure:

```text
zzl92105/homebrew-tap
  Formula/
    spec-prosecutor.rb
```

Then users can install with:

```bash
brew tap zzl92105/tap
brew install spec-prosecutor
```
