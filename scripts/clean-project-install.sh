#!/usr/bin/env bash
# EKC Project Clean — Remove .kimi/skills/ created by install-project
# Usage: ./clean-project-install.sh [-y|--yes] [-n|--dry-run]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
TARGET="${REPO_ROOT}/.kimi/skills"
AGENT_TARGET="${REPO_ROOT}/.kimi/agents"
STAMP_FILE="${TARGET}/.ekc-installed"

YES=0
DRYRUN=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    -y|--yes) YES=1; shift ;;
    -n|--dry-run) DRYRUN=1; shift ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

info()  { echo "$*"; }
warn()  { echo "  [WARN] $*"; }
ok()    { echo "  [OK] $*"; }

info "EKC Project Clean"
info "================="
info "Target: ${TARGET}"
info ""

# Check target exists
if [[ ! -d "$TARGET" ]]; then
  warn "Target does not exist. Nothing to clean."
  exit 0
fi

# Check stamp file
if [[ ! -f "$STAMP_FILE" ]]; then
  echo "  [ERROR] Refusing to delete ${TARGET}" >&2
  echo "  Reason: .ekc-installed stamp not found." >&2
  echo "  This directory may contain user-managed skills not created by EKC." >&2
  echo "  If you are sure, remove manually: rm -rf '${TARGET}'" >&2
  exit 1
fi

# Count skills and agents
SKILL_COUNT=0
for d in "$TARGET"/*/; do
  [[ -d "$d" ]] || continue
  SKILL_COUNT=$((SKILL_COUNT + 1))
done

AGENT_COUNT=0
if [[ -d "$AGENT_TARGET" ]]; then
  for d in "$AGENT_TARGET"/*/; do
    [[ -d "$d" ]] || continue
    AGENT_COUNT=$((AGENT_COUNT + 1))
  done
fi

info "WARNING: This will delete ${SKILL_COUNT} skills and ${AGENT_COUNT} agents installed by EKC."
info "Your source directory (skills/, agents/) will NOT be touched."
info ""

if [[ $DRYRUN -eq 1 ]]; then
  info "[DRY-RUN] Would remove: ${TARGET}"
  if [[ -d "$AGENT_TARGET" ]]; then
    info "[DRY-RUN] Would remove: ${AGENT_TARGET}"
  fi
  info "[DRY-RUN] No files were deleted."
  exit 0
fi

# Confirmation
if [[ $YES -eq 0 ]]; then
  read -rp "Remove .kimi/skills/ and .kimi/agents/? [y/N] " response
  if [[ ! "$response" =~ ^[Yy]([Ee][Ss])?$ ]]; then
    info "Cancelled."
    exit 0
  fi
fi

# Remove only .kimi/skills/ and .kimi/agents/, never .kimi/
rm -rf "$TARGET"
ok "Removed: ${TARGET}"

if [[ -d "$AGENT_TARGET" ]]; then
  rm -rf "$AGENT_TARGET"
  ok "Removed: ${AGENT_TARGET}"
fi

info ""
info "Result: Clean complete."
info "To reinstall, run: ./install-project.sh"
