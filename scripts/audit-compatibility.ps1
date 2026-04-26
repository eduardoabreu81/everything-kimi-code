# EKC Compatibility Auditor Wrapper
# Usage: .\audit-compatibility.ps1 [repo-path]

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoPath = if ($args[0]) { $args[0] } else { Resolve-Path "$ScriptDir\.." | Select-Object -ExpandProperty Path }

& node "$ScriptDir\audit-compatibility.js" "$RepoPath"
