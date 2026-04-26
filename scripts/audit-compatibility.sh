#!/usr/bin/env bash
# EKC Compatibility Auditor Wrapper
# Usage: ./audit-compatibility.sh [repo-path]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v node >/dev/null 2>&1; then
  echo "[ERROR] Node.js is required but not found in PATH."
  echo "Please install Node.js or run the auditor directly:"
  echo "  node ${SCRIPT_DIR}/audit-compatibility.js [repo-path]"
  exit 1
fi

node "${SCRIPT_DIR}/audit-compatibility.js" "$@"
