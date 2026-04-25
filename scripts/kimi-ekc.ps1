#!/usr/bin/env pwsh
# EKC Wrapper for PowerShell
# Usage: ./kimi-ekc.ps1 [any kimi args...]
# This wrapper automatically loads the EKC main agent from agents/ekc.yaml

$ErrorActionPreference = "Stop"

# Resolve script directory and repo root
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Resolve-Path (Join-Path $scriptDir "..")

# Resolve absolute path to agent file
$agentFile = Join-Path $repoRoot "agents\ekc.yaml"

if (-not (Test-Path $agentFile)) {
    Write-Error "EKC agent file not found: $agentFile"
    exit 1
}

# Pass all arguments through to kimi with --agent-file prepended
& kimi --agent-file $agentFile @args
