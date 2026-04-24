#!/usr/bin/env pwsh
# EKC Project Clean — Remove .kimi/skills/ created by install-project
# Usage: .\clean-project-install.ps1 [-Yes] [-DryRun]

[CmdletBinding()]
param(
    [switch]$Yes,
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Resolve-Path "$ScriptDir\.." | Select-Object -ExpandProperty Path
$Target = Join-Path (Join-Path $RepoRoot ".kimi") "skills"
$StampFile = Join-Path $Target ".ekc-installed"

function Write-Info($msg) { Write-Host $msg }
function Write-Warn($msg) { Write-Host "  [WARN] $msg" -ForegroundColor Yellow }
function Write-Ok($msg) { Write-Host "  [OK] $msg" -ForegroundColor Green }

Write-Info "EKC Project Clean"
Write-Info "================="
Write-Info "Target: $Target"
Write-Info ""

# Check target exists
if (-not (Test-Path $Target)) {
    Write-Warn "Target does not exist. Nothing to clean."
    exit 0
}

# Check stamp file
if (-not (Test-Path $StampFile)) {
    Write-Host "  [ERROR] Refusing to delete $Target" -ForegroundColor Red
    Write-Host "  Reason: .ekc-installed stamp not found." -ForegroundColor Red
    Write-Host "  This directory may contain user-managed skills not created by EKC." -ForegroundColor Red
    Write-Host "  If you are sure, remove manually: Remove-Item -Recurse -Force '$Target'" -ForegroundColor Red
    exit 1
}

# Count skills
$SkillCount = (Get-ChildItem -Path $Target -Directory).Count

# Show what will be removed
Write-Info "WARNING: This will delete $SkillCount skills installed by EKC."
Write-Info "Your source directory (skills/) will NOT be touched."
Write-Info ""

if ($DryRun) {
    Write-Info "[DRY-RUN] Would remove: $Target"
    Write-Info "[DRY-RUN] No files were deleted."
    exit 0
}

# Confirmation
if (-not $Yes) {
    $Response = Read-Host "Remove .kimi/skills/ and all EKC installed skills? [y/N]"
    if ($Response -notmatch "^\s*y(es)?\s*$") {
        Write-Info "Cancelled."
        exit 0
    }
}

# Remove only .kimi/skills/, never .kimi/
Remove-Item -Path $Target -Recurse -Force
Write-Ok "Removed: $Target"

Write-Info ""
Write-Info "Result: Clean complete."
Write-Info "To reinstall, run: .\install-project.ps1"
