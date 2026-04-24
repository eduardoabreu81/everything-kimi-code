#!/usr/bin/env pwsh
# EKC Project Install Validation
# Usage: .\validate-project-install.ps1 [-Quiet]

[CmdletBinding()]
param(
    [switch]$Quiet
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Resolve-Path "$ScriptDir\.." | Select-Object -ExpandProperty Path
$Target = Join-Path (Join-Path $RepoRoot ".kimi") "skills"
$StampFile = Join-Path $Target ".ekc-installed"

function Write-Info($msg) { if (-not $Quiet) { Write-Host $msg } }
function Write-Pass($msg) { if (-not $Quiet) { Write-Host "  [PASS] $msg" -ForegroundColor Green } }
function Write-Fail($msg) { Write-Host "  [FAIL] $msg" -ForegroundColor Red }
function Write-Warn($msg) { if (-not $Quiet) { Write-Host "  [WARN] $msg" -ForegroundColor Yellow } }

$Failures = 0
$Warnings = 0

Write-Info "EKC Project Install Validation"
Write-Info "=============================="
Write-Info "Target: $Target"
Write-Info ""

# 1. Target directory exists
if (Test-Path $Target) {
    Write-Pass "Directory exists"
} else {
    Write-Fail "Directory not found: $Target"
    $Failures++
    Write-Info ""
    Write-Info "Result: CRITICAL FAILURE"
    exit 1
}

# 2. Stamp file exists
if (Test-Path $StampFile) {
    Write-Pass "Stamp file found"
} else {
    Write-Warn "Stamp file not found (.ekc-installed)"
    $Warnings++
}

# 3. Each skill has SKILL.md
$SkillDirs = Get-ChildItem -Path $Target -Directory | Sort-Object Name
$TotalSkills = $SkillDirs.Count
$MissingSkillMd = 0

foreach ($Dir in $SkillDirs) {
    $MdPath = Join-Path $Dir.FullName "SKILL.md"
    if (-not (Test-Path $MdPath)) {
        Write-Fail "$($Dir.Name): missing SKILL.md"
        $MissingSkillMd++
        $Failures++
    }
}

if ($MissingSkillMd -eq 0) {
    Write-Pass "All $TotalSkills skills have SKILL.md"
} else {
    Write-Fail "$MissingSkillMd skills missing SKILL.md"
}

# 4. YAML frontmatter check
$MissingFrontmatter = 0
foreach ($Dir in $SkillDirs) {
    $MdPath = Join-Path $Dir.FullName "SKILL.md"
    $Content = Get-Content -Path $MdPath -Raw
    if (-not ($Content -match "^---")) {
        $MissingFrontmatter++
    }
}

if ($MissingFrontmatter -eq 0) {
    Write-Pass "All skills have YAML frontmatter"
} else {
    Write-Warn "$MissingFrontmatter skills missing YAML frontmatter"
    $Warnings++
}

# 5. Flow skill validation
$FlowNames = @("code-review", "feature-dev", "github-code-reviewer", "pr-review")
Write-Info ""
Write-Info "Flow Skill Validation:"

foreach ($FlowName in $FlowNames) {
    $FlowDir = Join-Path $Target $FlowName
    $FlowMd = Join-Path $FlowDir "SKILL.md"

    if (-not (Test-Path $FlowMd)) {
        Write-Fail "${FlowName}: SKILL.md not found"
        $Failures++
        continue
    }

    $Content = Get-Content -Path $FlowMd -Raw
    $HasTypeFlow = $Content -match "type:\s*flow"
    $HasDiagram = $Content -match "```mermaid|```d2"
    $HasBegin = $Content -match "\(\[BEGIN\]\)|BEGIN\s*->|->\s*BEGIN|:BEGIN"
    $HasEnd = $Content -match "\(\[END\]\)|->\s*END|END\s*:"

    $Ok = $true
    $Details = @()

    if ($HasTypeFlow) { $Details += "type=flow" } else { $Details += "type=MISSING"; $Ok = $false }
    if ($HasDiagram) { $Details += "diagram=YES" } else { $Details += "diagram=MISSING"; $Ok = $false }
    if ($HasBegin) { $Details += "begin=YES" } else { $Details += "begin=MISSING"; $Ok = $false }
    if ($HasEnd) { $Details += "end=YES" } else { $Details += "end=MISSING"; $Ok = $false }

    if ($Ok) {
        Write-Pass "${FlowName}: $($Details -join ', ')"
    } else {
        Write-Fail "${FlowName}: $($Details -join ', ')"
        $Failures++
    }
}

# Summary
Write-Info ""
Write-Info "=============================="
if ($Failures -eq 0 -and $Warnings -eq 0) {
    Write-Info "Result: ALL CHECKS PASSED"
    Write-Info "  Skills: $TotalSkills"
    Write-Info "  Flows:  4/4 valid"
} elseif ($Failures -eq 0) {
    Write-Info "Result: PASSED WITH WARNINGS ($Warnings)"
} else {
    Write-Info "Result: $Failures CRITICAL FAILURE(S), $Warnings WARNING(S)"
}

Write-Info ""
Write-Info "Manual Test Required"
Write-Info "===================="
Write-Info "1. Run: kimi"
Write-Info "2. Type: /help"
Write-Info "3. Look for 'Project' skills section"
Write-Info "4. Type: /flow"
Write-Info "5. Confirm these 4 flows appear in autocomplete:"
Write-Info "     /flow:code-review"
Write-Info "     /flow:feature-dev"
Write-Info "     /flow:github-code-reviewer"
Write-Info "     /flow:pr-review"
Write-Info "6. Run one: /flow:hello-flow (or /flow:feature-dev)"
Write-Info ""

exit $Failures
