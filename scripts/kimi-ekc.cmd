@echo off
setlocal EnableDelayedExpansion

REM EKC Wrapper for Windows (CMD/Batch)
REM Usage: kimi-ekc.cmd [any kimi args...]
REM This wrapper automatically loads the EKC main agent from agents/ekc.yaml

REM Resolve script directory and repo root
set "SCRIPT_DIR=%~dp0"
set "REPO_ROOT=%SCRIPT_DIR%.."

REM Resolve absolute path to agent file
set "AGENT_FILE=%REPO_ROOT%\agents\ekc\agent.yaml"

REM Pass all arguments through to kimi with --agent-file prepended
kimi --agent-file "%AGENT_FILE%" %*
