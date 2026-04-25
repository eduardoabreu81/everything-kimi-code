#!/usr/bin/env bash
# EKC Global Install Validation
# Usage: ./validate-global-install.sh [-q|--quiet]

set -euo pipefail

TARGET="${HOME}/.kimi/skills"
STAMP_FILE="${TARGET}/.ekc-installed"

QUIET=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    -q|--quiet) QUIET=1; shift ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

info()  { [[ $QUIET -eq 0 ]] && echo "$*"; }
pass()  { [[ $QUIET -eq 0 ]] && echo "  [PASS] $*"; }
fail()  { echo "  [FAIL] $*"; }
warn()  { [[ $QUIET -eq 0 ]] && echo "  [WARN] $*"; }

FAILURES=0
WARNINGS=0

info "EKC Global Install Validation"
info "============================="
info "Target: ${TARGET}"
info ""

if [[ -d "$TARGET" ]]; then
  pass "Directory exists"
else
  fail "Directory not found: ${TARGET}"
  FAILURES=$((FAILURES + 1))
  info ""
  info "Result: CRITICAL FAILURE"
  exit 1
fi

if [[ -f "$STAMP_FILE" ]]; then
  pass "Stamp file found"
else
  warn "Stamp file not found (.ekc-installed)"
  WARNINGS=$((WARNINGS + 1))
fi

TOTAL_SKILLS=0
MISSING_SKILL_MD=0
for skill_dir in "$TARGET"/*/; do
  [[ -d "$skill_dir" ]] || continue
  TOTAL_SKILLS=$((TOTAL_SKILLS + 1))
  skill_md="${skill_dir}/SKILL.md"
  if [[ ! -f "$skill_md" ]]; then
    skill_name="$(basename "$skill_dir")"
    fail "${skill_name}: missing SKILL.md"
    MISSING_SKILL_MD=$((MISSING_SKILL_MD + 1))
    FAILURES=$((FAILURES + 1))
  fi
done

if [[ $MISSING_SKILL_MD -eq 0 ]]; then
  pass "All ${TOTAL_SKILLS} skills have SKILL.md"
else
  fail "${MISSING_SKILL_MD} skills missing SKILL.md"
fi

MISSING_FRONTMATTER=0
for skill_dir in "$TARGET"/*/; do
  [[ -d "$skill_dir" ]] || continue
  skill_md="${skill_dir}/SKILL.md"
  if [[ -f "$skill_md" ]]; then
    if ! head -n 1 "$skill_md" | grep -q '^---'; then
      MISSING_FRONTMATTER=$((MISSING_FRONTMATTER + 1))
    fi
  fi
done

if [[ $MISSING_FRONTMATTER -eq 0 ]]; then
  pass "All skills have YAML frontmatter"
else
  warn "${MISSING_FRONTMATTER} skills missing YAML frontmatter"
  WARNINGS=$((WARNINGS + 1))
fi

AGENT_TARGET="${HOME}/.kimi/agents"
info ""
info "Agent Validation:"

if [[ -d "$AGENT_TARGET" ]]; then
  pass "Agents directory exists"
else
  fail "Agents directory not found: ${AGENT_TARGET}"
  FAILURES=$((FAILURES + 1))
fi

if [[ -f "${AGENT_TARGET}/ekc.yaml" ]]; then
  pass "Main agent (ekc.yaml) exists"
else
  fail "Main agent (ekc.yaml) not found"
  FAILURES=$((FAILURES + 1))
fi

if [[ -f "${AGENT_TARGET}/ekc.md" ]]; then
  pass "Main agent (ekc.md) exists"
else
  fail "Main agent (ekc.md) not found"
  FAILURES=$((FAILURES + 1))
fi

TOTAL_AGENTS=0
MISSING_AGENT_FILES=0
for agent_dir in "${AGENT_TARGET}"/*/; do
  [[ -d "$agent_dir" ]] || continue
  TOTAL_AGENTS=$((TOTAL_AGENTS + 1))
  agent_md="${agent_dir}/agent.md"
  agent_yaml="${agent_dir}/agent.yaml"
  agent_name="$(basename "$agent_dir")"
  if [[ ! -f "$agent_md" ]]; then
    fail "${agent_name}: missing agent.md"
    MISSING_AGENT_FILES=$((MISSING_AGENT_FILES + 1))
    FAILURES=$((FAILURES + 1))
  fi
  if [[ ! -f "$agent_yaml" ]]; then
    fail "${agent_name}: missing agent.yaml"
    MISSING_AGENT_FILES=$((MISSING_AGENT_FILES + 1))
    FAILURES=$((FAILURES + 1))
  fi
done

if [[ $MISSING_AGENT_FILES -eq 0 ]]; then
  pass "All ${TOTAL_AGENTS} subagents have agent.md + agent.yaml"
else
  fail "${MISSING_AGENT_FILES} agent file(s) missing"
fi

FLOW_NAMES=("code-review" "feature-dev" "github-code-reviewer" "pr-review")
info ""
info "Flow Skill Validation:"

for flow_name in "${FLOW_NAMES[@]}"; do
  flow_md="${TARGET}/${flow_name}/SKILL.md"
  if [[ ! -f "$flow_md" ]]; then
    fail "${flow_name}: SKILL.md not found"
    FAILURES=$((FAILURES + 1))
    continue
  fi

  content="$(cat "$flow_md")"
  has_type_flow=0
  has_diagram=0
  has_begin=0
  has_end=0
  has_br=0

  if echo "$content" | grep -q 'type:\s*flow'; then has_type_flow=1; fi
  if echo "$content" | grep -qE '```mermaid|```d2'; then has_diagram=1; fi
  if echo "$content" | grep -qE '\(\[BEGIN\]\)|BEGIN\s*->|->\s*BEGIN|:BEGIN'; then has_begin=1; fi
  if echo "$content" | grep -qE '\(\[END\]\)|->\s*END|END\s*:'; then has_end=1; fi
  if echo "$content" | grep -q '<br'; then has_br=1; fi

  details=""
  ok=1
  if [[ $has_type_flow -eq 1 ]]; then details+="type=flow "; else details+="type=MISSING "; ok=0; fi
  if [[ $has_diagram -eq 1 ]]; then details+="diagram=YES "; else details+="diagram=MISSING "; ok=0; fi
  if [[ $has_begin -eq 1 ]]; then details+="begin=YES "; else details+="begin=MISSING "; ok=0; fi
  if [[ $has_end -eq 1 ]]; then details+="end=YES "; else details+="end=MISSING "; ok=0; fi
  if [[ $has_br -eq 0 ]]; then details+="no-br=YES"; else details+="no-br=FAIL"; ok=0; fi

  if [[ $ok -eq 1 ]]; then
    pass "${flow_name}: ${details}"
  else
    fail "${flow_name}: ${details}"
    FAILURES=$((FAILURES + 1))
  fi
done

info ""
info "=============================="
if [[ $FAILURES -eq 0 && $WARNINGS -eq 0 ]]; then
  info "Result: ALL CHECKS PASSED"
  info "  Skills: ${TOTAL_SKILLS}"
  info "  Agents: ${TOTAL_AGENTS}"
  info "  Flows:  4/4 valid"
elif [[ $FAILURES -eq 0 ]]; then
  info "Result: PASSED WITH WARNINGS (${WARNINGS})"
else
  info "Result: ${FAILURES} CRITICAL FAILURE(S), ${WARNINGS} WARNING(S)"
fi

info ""
info "Manual Test Required"
info "===================="
info "1. Open VS Code or run 'kimi'"
info "2. Type: /help"
info "3. Look for EKC skills and flows"
info "4. Type: /flow"
info "5. Confirm these 4 flows appear:"
info "     /flow:code-review"
info "     /flow:feature-dev"
info "     /flow:github-code-reviewer"
info "     /flow:pr-review"
info ""

exit $FAILURES
