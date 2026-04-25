# EKC Project Install - Copy skills/ and agents/ to .kimi/
# Usage: .\install-project.ps1 [-Force] [-DryRun] [-Quiet]

[CmdletBinding()]
param(
    [switch]$Force,
    [switch]$DryRun,
    [switch]$Quiet
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Resolve-Path "$ScriptDir\.." | Select-Object -ExpandProperty Path
$Source = Join-Path $RepoRoot "skills"
$Target = Join-Path (Join-Path $RepoRoot ".kimi") "skills"
$StampFile = Join-Path $Target ".ekc-installed"

$AgentSource = Join-Path $RepoRoot "agents"
$AgentTarget = Join-Path (Join-Path $RepoRoot ".kimi") "agents"

function Write-Info($msg) { if (-not $Quiet) { Write-Host $msg } }
function Write-Ok($msg) { if (-not $Quiet) { Write-Host "  [OK] $msg" -ForegroundColor Green } }
function Write-Warn($msg) { Write-Warning $msg }

if (-not (Test-Path $Source)) {
    Write-Error "Source directory not found: $Source"
    exit 1
}

$TargetParent = Split-Path -Parent $Target
if (-not (Test-Path $TargetParent)) {
    if ($DryRun) {
        Write-Info "[DRY-RUN] Would create: $TargetParent"
    } else {
        New-Item -ItemType Directory -Path $TargetParent -Force | Out-Null
    }
}

if (-not (Test-Path $AgentTarget)) {
    if ($DryRun) {
        Write-Info "[DRY-RUN] Would create: $AgentTarget"
    } else {
        New-Item -ItemType Directory -Path $AgentTarget -Force | Out-Null
    }
}

if ($DryRun) {
    Write-Info "[DRY-RUN] Mode enabled. No files will be copied."
}

$Copied = 0
$Updated = 0
$Skipped = 0
$SourceSkills = Get-ChildItem -Path $Source -Directory | Sort-Object Name

foreach ($SkillDir in $SourceSkills) {
    $SkillName = $SkillDir.Name
    $SkillSource = $SkillDir.FullName
    $SkillDest = Join-Path $Target $SkillName
    $SkillMdSource = Join-Path $SkillSource "SKILL.md"

    if (-not (Test-Path $SkillMdSource)) {
        Write-Warn "Skipping '$SkillName': no SKILL.md found"
        continue
    }

    $Exists = Test-Path $SkillDest
    $ShouldCopy = $false
    $Action = ""

    if (-not $Exists) {
        $ShouldCopy = $true
        $Action = "copy"
    } elseif ($Force) {
        $ShouldCopy = $true
        $Action = "overwrite"
    } else {
        $Skipped++
        continue
    }

    if ($DryRun) {
        Write-Info "[DRY-RUN] Would ${Action}: $SkillName"
        if ($Action -eq "copy") { $Copied++ } else { $Updated++ }
        continue
    }

    if ($Action -eq "overwrite") {
        Remove-Item -Path $SkillDest -Recurse -Force
    }

    Copy-Item -Path $SkillSource -Destination $SkillDest -Recurse -Force
    if ($Action -eq "copy") { $Copied++ } else { $Updated++ }
    Write-Ok "$Action $SkillName"
}

# Copy agents
$AgentCopied = 0
$AgentUpdated = 0
$AgentSkipped = 0
if (Test-Path $AgentSource) {
    $SourceAgents = Get-ChildItem -Path $AgentSource -Directory | Sort-Object Name
    foreach ($AgentDir in $SourceAgents) {
        $AgentName = $AgentDir.Name
        $AgentSourcePath = $AgentDir.FullName
        $AgentDestPath = Join-Path $AgentTarget $AgentName
        $AgentYamlSource = Join-Path $AgentSourcePath "agent.yaml"
        $AgentMdSource = Join-Path $AgentSourcePath "agent.md"
        $IsAgentDir = (Test-Path $AgentYamlSource) -or (Test-Path $AgentMdSource)

        if (-not $IsAgentDir) {
            continue
        }

        $AgentExists = Test-Path $AgentDestPath
        $AgentShouldCopy = $false
        $AgentAction = ""

        if (-not $AgentExists) {
            $AgentShouldCopy = $true
            $AgentAction = "copy"
        } elseif ($Force) {
            $AgentShouldCopy = $true
            $AgentAction = "overwrite"
        } else {
            $AgentSkipped++
            continue
        }

        if ($DryRun) {
            Write-Info "[DRY-RUN] Would ${AgentAction} agent: $AgentName"
            if ($AgentAction -eq "copy") { $AgentCopied++ } else { $AgentUpdated++ }
            continue
        }

        if ($AgentAction -eq "overwrite") {
            Remove-Item -Path $AgentDestPath -Recurse -Force
        }

        Copy-Item -Path $AgentSourcePath -Destination $AgentDestPath -Recurse -Force
        if ($AgentAction -eq "copy") { $AgentCopied++ } else { $AgentUpdated++ }
        Write-Ok "$AgentAction agent $AgentName"
    }

    # Copy main agent files (ekc.yaml, ekc.md)
    $MainAgentYaml = Join-Path $AgentSource "ekc.yaml"
    $MainAgentMd = Join-Path $AgentSource "ekc.md"
    if (Test-Path $MainAgentYaml) {
        $MainAgentDest = Join-Path $AgentTarget "ekc.yaml"
        if (-not (Test-Path $MainAgentDest) -or $Force) {
            if ($DryRun) {
                Write-Info "[DRY-RUN] Would copy agent: ekc.yaml"
            } else {
                Copy-Item -Path $MainAgentYaml -Destination $MainAgentDest -Force
                Write-Ok "copy agent ekc.yaml"
            }
        }
    }
    if (Test-Path $MainAgentMd) {
        $MainAgentMdDest = Join-Path $AgentTarget "ekc.md"
        if (-not (Test-Path $MainAgentMdDest) -or $Force) {
            if ($DryRun) {
                Write-Info "[DRY-RUN] Would copy agent: ekc.md"
            } else {
                Copy-Item -Path $MainAgentMd -Destination $MainAgentMdDest -Force
                Write-Ok "copy agent ekc.md"
            }
        }
    }
}

if (-not $DryRun) {
    $GitHash = "unknown"
    try {
        $GitHash = (git -C $RepoRoot rev-parse --short HEAD 2>$null) | Out-String
        $GitHash = $GitHash.Trim()
    } catch { }
    $StampContent = @(
        "# EKC Project Install Stamp"
        "# Generated by: scripts/install-project.ps1"
        "# Source: $Source"
        "# Timestamp: $(Get-Date -Format o)"
        "# Git Commit: $GitHash"
        "# Total Skills: $($Copied + $Updated + $Skipped)"
        "# Total Agents: $($AgentCopied + $AgentUpdated + $AgentSkipped)"
        "# DO NOT EDIT MANUALLY"
    ) -join "`n"
    Set-Content -Path $StampFile -Value $StampContent -Encoding utf8 -NoNewline
    Write-Ok "Stamp file created"
}

Write-Info ""
Write-Info "EKC Project Install"
Write-Info "==================="
Write-Info "Source:  $Source"
Write-Info "Target:  $Target"
Write-Info ""
Write-Info "Skills:"
Write-Info "  Copied:   $Copied"
Write-Info "  Updated:  $Updated"
Write-Info "  Skipped:  $Skipped"
Write-Info ""
Write-Info "Agents:"
Write-Info "  Copied:   $AgentCopied"
Write-Info "  Updated:  $AgentUpdated"
Write-Info "  Skipped:  $AgentSkipped"
Write-Info ""

$FlowSkills = @()
if (Test-Path $Target) {
    $FlowSkills = Get-ChildItem -Path $Target -Directory | Where-Object {
        $md = Join-Path $_.FullName "SKILL.md"
        if (Test-Path $md) {
            $c = Get-Content -Path $md -Raw
            $c -match "type:\s*flow"
        } else { $false }
    } | Select-Object -ExpandProperty Name
}

if ($FlowSkills.Count -gt 0) {
    Write-Info "Flow skills installed:"
    foreach ($f in $FlowSkills) {
        Write-Info "  /flow:$f"
    }
}

Write-Info ""
if ($DryRun) {
    Write-Info "[DRY-RUN] No files were copied."
} else {
    Write-Info "Next step: Run 'kimi' and type '/help' to verify."
}
