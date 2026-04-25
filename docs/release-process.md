# EKC Release Process

This document describes how EKC (Everything Kimi Code) versions are managed and released.

## How Versioning Works

### Commits and Push

- **Commits** record changes in the local Git history.
- **Push** sends those commits to the remote repository on GitHub.

Commits and push alone do **not** create a release. They only update the source code.

### Tags and Releases

- **Tags** mark specific points in Git history as version milestones.
- **GitHub Releases** are created from tags and provide downloadable artifacts, release notes, and a stable reference for users.

EKC uses **semantic versioning** in the format `vX.Y.Z`:

| Position | Name | When to Increase | Examples |
|----------|------|------------------|----------|
| `X` | Major | Large changes, breaking modifications, or significant repositioning of the project | Removing deprecated flows, changing install paths, major architectural shifts |
| `Y` | Minor | New compatible features, capabilities, or modules | Adding `ekc-cli`, a new dashboard, a bootstrap installer, new flow categories |
| `Z` | Patch | Bug fixes, small corrections, documentation fixes, script adjustments | Fixing a dead node in a flow, correcting a validation script, updating README wording |

## Version Examples

| Version | Meaning | Example Scenario |
|---------|---------|------------------|
| `v0.1.0` | First consolidated foundation | Global install scripts, 4 validated flows, user-facing README and CHANGELOG |
| `v0.2.0` | New compatible feature | Adding `ekc-cli` interactive installer or a new flow category |
| `v0.1.1` | Patch fix | Correcting a bug in a flow diagram, fixing a script edge case, or updating docs |
| `v1.0.0` | First stable release | Project considered ready for broad use with stable APIs, install paths, and flows |

## Release Checklist

Before creating a release, verify:

1. **Working tree is clean**
   ```bash
   git status
   ```

2. **All changes are committed and pushed**
   ```bash
   git pull
   git push
   ```

3. **CHANGELOG.md is updated**
   - The version section exists (e.g., `## [v0.1.0] - YYYY-MM-DD`).
   - `[Unreleased]` is empty or contains only items that will be part of the next release.

4. **Validators pass**
   ```powershell
   .\scripts\validate-global-install.ps1
   .\scripts\validate-project-install.ps1
   ```

5. **Flows work in both environments**
   - Kimi CLI
   - VS Code Extension (with global install)

## Creating a Release

### Step 1: Create a Local Tag

```bash
git tag -a v0.1.0 -m "v0.1.0"
```

The `-a` flag creates an annotated tag. The message should match the version.

### Step 2: Push the Tag to GitHub

```bash
git push origin v0.1.0
```

This makes the tag available on the remote repository.

### Step 3: Create a GitHub Release

1. Go to the repository on GitHub.
2. Navigate to **Releases**.
3. Click **Draft a new release**.
4. Choose the tag you just pushed (e.g., `v0.1.0`).
5. Use the corresponding section from `CHANGELOG.md` as the release notes.
6. Publish the release.

## Release Notes Source

`CHANGELOG.md` is the primary source for release notes. When creating a GitHub Release, copy the relevant version section from the CHANGELOG into the release description.

## Removing a Tag (if needed)

If a tag was created incorrectly:

```bash
# Delete local tag
git tag -d v0.1.0

# Delete remote tag
git push origin --delete v0.1.0
```

## Pre-Releases

For versions that are not yet stable, use a pre-release suffix:

```
v0.2.0-alpha.1
v0.2.0-beta.1
```

Mark the GitHub Release as a **pre-release** when publishing.
