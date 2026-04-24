#!/usr/bin/env bash
# EKC Wrapper for Unix/Linux/macOS
# Usage: ./kimi-ekc.sh [any kimi args...]
# This wrapper automatically loads the EKC main agent from agents/ekc.yaml

set -euo pipefail

# Resolve script directory and repo root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Resolve absolute path to agent file
AGENT_FILE="${REPO_ROOT}/agents/ekc.yaml"

if [ ! -f "$AGENT_FILE" ]; then
    echo "Error: EKC agent file not found: $AGENT_FILE" >&2
    exit 1
fi

# Pass all arguments through to kimi with --agent-file prepended
exec kimi --agent-file "$AGENT_FILE" "$@"
