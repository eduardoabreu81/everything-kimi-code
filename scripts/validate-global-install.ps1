# EKC Global Install Validation
# Usage: .\validate-global-install.ps1 [-Quiet]

[CmdletBinding()]
param(
    [switch]$Quiet
)

$ErrorActionPreference = "Stop"

$Target = Join-Path $HOME ".kimi/skills"
$AgentTarget = Join-Path $HOME ".kimi/agents"
$StampFile = Join-Path $Target ".ekc-installed"

function Write-Info($msg) { if (-not $Quiet) { Write-Host $msg } }
function Write-Pass($msg) { if (-not $Quiet) { Write-Host "  [PASS] $msg" -ForegroundColor Green } }
function Write-Fail($msg) { Write-Host "  [FAIL] $msg" -ForegroundColor Red }
function Write-Warn($msg) { if (-not $Quiet) { Write-Host "  [WARN] $msg" -ForegroundColor Yellow } }

$Failures = 0
$Warnings = 0

Write-Info "EKC Global Install Validation"
Write-Info "============================="
Write-Info "Target: $Target"
Write-Info ""

if (Test-Path $Target) {
    Write-Pass "Directory exists"
} else {
    Write-Fail "Directory not found: $Target"
    $Failures++
    Write-Info ""
    Write-Info "Result: CRITICAL FAILURE"
    exit 1
}

if (Test-Path $StampFile) {
    Write-Pass "Stamp file found"
} else {
    Write-Warn "Stamp file not found (.ekc-installed)"
    $Warnings++
}

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

$FlowNames = @("code-review", "feature-dev", "github-code-reviewer", "pr-review")

Write-Info ""
Write-Info "Agent Validation:"

if (Test-Path $AgentTarget) {
    Write-Pass "Agents directory exists"
} else {
    Write-Fail "Agents directory not found: $AgentTarget"
    $Failures++
}

$EkcYaml = Join-Path $AgentTarget "ekc.yaml"
$EkcMd = Join-Path $AgentTarget "ekc.md"
if (Test-Path $EkcYaml) {
    Write-Pass "Main agent (ekc.yaml) exists"
} else {
    Write-Fail "Main agent (ekc.yaml) not found"
    $Failures++
}
if (Test-Path $EkcMd) {
    Write-Pass "Main agent (ekc.md) exists"
} else {
    Write-Fail "Main agent (ekc.md) not found"
    $Failures++
}

$AgentDirs = Get-ChildItem -Path $AgentTarget -Directory -ErrorAction SilentlyContinue | Sort-Object Name
$TotalAgents = $AgentDirs.Count
$MissingAgentFiles = 0

foreach ($Dir in $AgentDirs) {
    $AgentMd = Join-Path $Dir.FullName "agent.md"
    $AgentYaml = Join-Path $Dir.FullName "agent.yaml"
    if (-not (Test-Path $AgentMd)) {
        Write-Fail "$($Dir.Name): missing agent.md"
        $MissingAgentFiles++
        $Failures++
    }
    if (-not (Test-Path $AgentYaml)) {
        Write-Fail "$($Dir.Name): missing agent.yaml"
        $MissingAgentFiles++
        $Failures++
    }
}

if ($MissingAgentFiles -eq 0) {
    Write-Pass "All $TotalAgents subagents have agent.md + agent.yaml"
} else {
    Write-Fail "$MissingAgentFiles agent file(s) missing"
}

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
    $HasBr = $Content -match "<br\s*/?>"

    # Parse diagram for dead nodes (nodes with no outgoing edge) and unreachable nodes
    $DeadNodes = @()
    $UnreachableNodes = @()
    if ($HasDiagram) {
        $DiagramMatch = [regex]::Match($Content, '```mermaid\r?\n(.*?)\r?\n```', [System.Text.RegularExpressions.RegexOptions]::Singleline)
        if ($DiagramMatch.Success) {
            $Diagram = $DiagramMatch.Groups[1].Value
            $Sources = @()
            $Targets = @()
            $DefinedNodes = @()
            $BeginNode = $null
            $EndNode = $null
            foreach ($Line in $Diagram -split "`r?`n") {
                $Line = $Line.Trim()
                if ($Line -eq '' -or $Line -match '^flowchart') { continue }
                # Extract edges: A([BEGIN]) --> B[text], C -->|label| D, etc.
                $EdgeMatches = [regex]::Matches($Line, '([A-Z]\w*)(?:\[[^\]]*\]|\{[^\}]*\}|\([^\)]*\))?\s*-->\s*(?:\|[^|]*\|)?\s*([A-Z]\w*)')
                foreach ($m in $EdgeMatches) {
                    $Sources += $m.Groups[1].Value
                    $Targets += $m.Groups[2].Value
                }
                # Extract node definitions and detect BEGIN/END nodes
                $DefMatches = [regex]::Matches($Line, '([A-Z]\w*)(\[|\{|\()')
                foreach ($m in $DefMatches) {
                    $Node = $m.Groups[1].Value
                    $DefinedNodes += $Node
                    $Bracket = $m.Groups[2].Value
                    $Start = $m.Index + $m.Length - 1
                    switch ($Bracket) {
                        '[' { $EndPos = $Line.IndexOf(']', $Start + 1) }
                        '{' { $EndPos = $Line.IndexOf('}', $Start + 1) }
                        '(' { $EndPos = $Line.IndexOf(')', $Start + 1) }
                    }
                    if ($EndPos -gt 0) {
                        $Inner = $Line.Substring($Start + 1, $EndPos - $Start - 1)
                        if ($Inner -match 'BEGIN') { $BeginNode = $Node }
                        if ($Inner -match 'END') { $EndNode = $Node }
                    }
                }
            }
            $UniqueNodes = $DefinedNodes | Select-Object -Unique
            foreach ($Node in $UniqueNodes) {
                if ($Node -ne $EndNode -and $Sources -notcontains $Node) {
                    $DeadNodes += $Node
                }
                if ($Node -ne $BeginNode -and $Targets -notcontains $Node) {
                    $UnreachableNodes += $Node
                }
            }
        }
    }

    $Ok = $true
    $Details = @()

    if ($HasTypeFlow) { $Details += "type=flow" } else { $Details += "type=MISSING"; $Ok = $false }
    if ($HasDiagram) { $Details += "diagram=YES" } else { $Details += "diagram=MISSING"; $Ok = $false }
    if ($HasBegin) { $Details += "begin=YES" } else { $Details += "begin=MISSING"; $Ok = $false }
    if ($HasEnd) { $Details += "end=YES" } else { $Details += "end=MISSING"; $Ok = $false }
    if (-not $HasBr) { $Details += "no-br=YES" } else { $Details += "no-br=FAIL"; $Ok = $false }
    if ($DeadNodes.Count -eq 0) { $Details += "connected=YES" } else { $Details += "connected=FAIL(dead:$($DeadNodes -join ','))"; $Ok = $false }
    if ($UnreachableNodes.Count -eq 0) { $Details += "reachable=YES" } else { $Details += "reachable=FAIL(unreachable:$($UnreachableNodes -join ','))"; $Ok = $false }

    if ($Ok) {
        Write-Pass "${FlowName}: $($Details -join ', ')"
    } else {
        Write-Fail "${FlowName}: $($Details -join ', ')"
        $Failures++
    }
}

Write-Info ""
Write-Info "=============================="
if ($Failures -eq 0 -and $Warnings -eq 0) {
    Write-Info "Result: ALL CHECKS PASSED"
    Write-Info "  Skills: $TotalSkills"
    Write-Info "  Agents: $TotalAgents"
    Write-Info "  Flows:  4/4 valid"
} elseif ($Failures -eq 0) {
    Write-Info "Result: PASSED WITH WARNINGS ($Warnings)"
} else {
    Write-Info "Result: $Failures CRITICAL FAILURE(S), $Warnings WARNING(S)"
}

Write-Info ""
Write-Info "Manual Test Required"
Write-Info "===================="
Write-Info "1. Open VS Code or run 'kimi'"
Write-Info "2. Type: /help"
Write-Info "3. Look for EKC skills and flows"
Write-Info "4. Type: /flow"
Write-Info "5. Confirm these 4 flows appear:"
Write-Info "     /flow:code-review"
Write-Info "     /flow:feature-dev"
Write-Info "     /flow:github-code-reviewer"
Write-Info "     /flow:pr-review"
Write-Info ""

exit $Failures
