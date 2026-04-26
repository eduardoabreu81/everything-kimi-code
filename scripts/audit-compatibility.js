#!/usr/bin/env node
/**
 * EKC Compatibility Auditor
 * Minimal validation to detect drift in agents, skills, flows, and runtime.
 *
 * Usage: node scripts/audit-compatibility.js [repo-path]
 */

const fs = require("fs");
const path = require("path");

const repoPath = process.argv[2] || path.resolve(__dirname, "..");
let failures = 0;
let warnings = 0;
let passes = 0;

function result(severity, check, message, file = null) {
  const icons = { PASS: "✅", WARN: "⚠️ ", FAIL: "❌" };
  const prefix = `${icons[severity]} [${severity}] ${check}`;
  const suffix = file ? ` (${file})` : "";
  console.log(`${prefix}: ${message}${suffix}`);
  if (severity === "FAIL") failures++;
  else if (severity === "WARN") warnings++;
  else passes++;
}

// ─── Check 1: Wrapper Paths ───
function checkWrapperPaths() {
  const wrappers = [
    { file: "scripts/kimi-ekc.ps1", expected: "agents/ekc.yaml" },
    { file: "scripts/kimi-ekc.sh", expected: "agents/ekc.yaml" },
    { file: "scripts/kimi-ekc.cmd", expected: "agents/ekc.yaml" },
  ];

  for (const w of wrappers) {
    const p = path.join(repoPath, w.file);
    if (!fs.existsSync(p)) {
      result("FAIL", "wrapper-paths", `${w.file} not found`);
      continue;
    }
    const content = fs.readFileSync(p, "utf-8");
    const badPath = content.includes("agents/ekc/agent.yaml") || content.includes("agents\\ekc\\agent.yaml");
    const goodPath = content.includes(w.expected) || content.includes(w.expected.replace("/", "\\"));
    if (badPath) {
      result("FAIL", "wrapper-paths", `${w.file} points to wrong agent path (agents/ekc/agent.yaml)`, w.file);
    } else if (goodPath) {
      result("PASS", "wrapper-paths", `${w.file} points to correct path`, w.file);
    } else {
      result("WARN", "wrapper-paths", `${w.file} agent path could not be verified`, w.file);
    }
  }
}

// ─── Check 2: Agent Structure ───
function checkAgentStructure() {
  const agentsDir = path.join(repoPath, "agents");
  const ekcYaml = path.join(agentsDir, "ekc.yaml");
  const ekcMd = path.join(agentsDir, "ekc.md");

  if (fs.existsSync(ekcYaml)) {
    result("PASS", "agent-structure", "agents/ekc.yaml exists");
  } else {
    result("FAIL", "agent-structure", "agents/ekc.yaml missing");
  }

  if (fs.existsSync(ekcMd)) {
    result("PASS", "agent-structure", "agents/ekc.md exists");
  } else {
    result("FAIL", "agent-structure", "agents/ekc.md missing");
  }

  if (!fs.existsSync(agentsDir)) {
    result("FAIL", "agent-structure", "agents/ directory not found");
    return;
  }

  const dirs = fs.readdirSync(agentsDir).filter((d) =>
    fs.statSync(path.join(agentsDir, d)).isDirectory()
  );

  let subagentOk = 0;
  let subagentFail = 0;
  for (const dir of dirs) {
    const mdPath = path.join(agentsDir, dir, "agent.md");
    const yamlPath = path.join(agentsDir, dir, "agent.yaml");
    if (fs.existsSync(mdPath) && fs.existsSync(yamlPath)) {
      subagentOk++;
    } else {
      subagentFail++;
      result("FAIL", "agent-structure", `Missing agent.md or agent.yaml in agents/${dir}/`);
    }
  }

  if (subagentFail === 0) {
    result("PASS", "agent-structure", `${subagentOk} subagents have agent.md + agent.yaml`);
  }
}

// ─── Check 3: Agent YAML Tools ───
function checkAgentYamlTools() {
  const agentsDir = path.join(repoPath, "agents");
  if (!fs.existsSync(agentsDir)) return;

  const legacyTools = ["Bash", "Read", "Edit", "Task"];
  const dirs = fs.readdirSync(agentsDir).filter((d) =>
    fs.statSync(path.join(agentsDir, d)).isDirectory()
  );
  let agentDriftCount = 0;

  for (const dir of dirs) {
    const yamlPath = path.join(agentsDir, dir, "agent.yaml");
    if (!fs.existsSync(yamlPath)) continue;
    const content = fs.readFileSync(yamlPath, "utf-8");

    // Extract tools: block
    const toolsMatch = content.match(/tools:\s*([\s\S]*?)(?=\n\w|\n$|$)/);
    if (!toolsMatch) continue;
    const toolsBlock = toolsMatch[1];

    for (const tool of legacyTools) {
      const regex = new RegExp(`\\b${tool}\\b`);
      if (regex.test(toolsBlock) && !toolsBlock.includes(`kimi_cli.tools.multiagent:${tool}`)) {
        result("WARN", "agent-tools", `agents/${dir}/agent.yaml references legacy tool "${tool}" in tools block`, `agents/${dir}/agent.yaml`);
      }
    }

    // Detect drift: Agent vs Task for subagent dispatch (count only)
    if (toolsBlock.includes("kimi_cli.tools.agent:Agent")) {
      agentDriftCount++;
    }
  }

  if (agentDriftCount > 0) {
    result("WARN", "agent-tools", `${agentDriftCount} agents use "kimi_cli.tools.agent:Agent" for subagents; Kimi docs recommend "kimi_cli.tools.multiagent:Task"`);
  }
}

// ─── Check 4: Flow Structure ───
function checkFlowStructure() {
  const flows = ["code-review", "feature-dev", "github-code-reviewer", "pr-review"];
  for (const flow of flows) {
    const mdPath = path.join(repoPath, "skills", flow, "SKILL.md");
    if (!fs.existsSync(mdPath)) {
      result("FAIL", "flow-structure", `Flow ${flow}: SKILL.md not found`);
      continue;
    }
    const content = fs.readFileSync(mdPath, "utf-8");
    const hasType = /type:\s*flow/.test(content);
    const hasDiagram = /```mermaid/.test(content) || /```d2/.test(content);
    const hasBegin = /\(\[BEGIN\]\)|BEGIN\s*->|->\s*BEGIN|:BEGIN/.test(content);
    const hasEnd = /\(\[END\]\)|->\s*END|END\s*:/.test(content);
    const hasBr = /<br\s*\/?>/.test(content);

    if (!hasType) result("FAIL", "flow-structure", `Flow ${flow}: missing type: flow`);
    if (!hasDiagram) result("FAIL", "flow-structure", `Flow ${flow}: missing diagram`);
    if (!hasBegin) result("FAIL", "flow-structure", `Flow ${flow}: missing BEGIN node`);
    if (!hasEnd) result("FAIL", "flow-structure", `Flow ${flow}: missing END node`);
    if (hasBr) result("FAIL", "flow-structure", `Flow ${flow}: contains <br/> tag`);

    if (hasType && hasDiagram && hasBegin && hasEnd && !hasBr) {
      result("PASS", "flow-structure", `Flow ${flow} is valid`);
    }
  }
}

// ─── Check 5: Skill Frontmatter Tools ───
function checkSkillFrontmatterTools() {
  const skillsDir = path.join(repoPath, "skills");
  if (!fs.existsSync(skillsDir)) return;

  const legacyTools = ["Bash", "Read", "Edit", "Task"];
  const dirs = fs.readdirSync(skillsDir).filter((d) =>
    fs.statSync(path.join(skillsDir, d)).isDirectory()
  );

  for (const dir of dirs) {
    const mdPath = path.join(skillsDir, dir, "SKILL.md");
    if (!fs.existsSync(mdPath)) continue;
    const content = fs.readFileSync(mdPath, "utf-8");

    if (!content.startsWith("---")) continue;
    const endFm = content.indexOf("---", 3);
    if (endFm === -1) continue;
    const frontmatter = content.slice(0, endFm);

    for (const tool of legacyTools) {
      const regex = new RegExp(`\\b${tool}\\b`);
      if (regex.test(frontmatter)) {
        result("WARN", "skill-tools", `skills/${dir}/SKILL.md references legacy tool "${tool}" in frontmatter`, `skills/${dir}/SKILL.md`);
      }
    }
  }
}

// ─── Check 6: Clara-Only References ───
function checkClaraRefs() {
  const claudeMd = path.join(repoPath, "CLAUDE.md");
  if (fs.existsSync(claudeMd)) {
    result("WARN", "clara-refs", "CLAUDE.md exists at repo root");
  }

  const skillsDir = path.join(repoPath, "skills");
  const agentsDir = path.join(repoPath, "agents");

  for (const baseDir of [skillsDir, agentsDir]) {
    if (!fs.existsSync(baseDir)) continue;
    const dirs = fs.readdirSync(baseDir).filter((d) =>
      fs.statSync(path.join(baseDir, d)).isDirectory()
    );
    for (const dir of dirs) {
      const subPath = path.join(baseDir, dir);
      const hasClaudeDir = fs.existsSync(path.join(subPath, ".claude"));
      if (hasClaudeDir) {
        result("WARN", "clara-refs", `.claude/ directory found in ${path.relative(repoPath, subPath)}`);
      }
    }
  }
}

// ─── Check 7: Gitignore ───
function checkGitignore() {
  const gitignore = path.join(repoPath, ".gitignore");
  if (!fs.existsSync(gitignore)) {
    result("FAIL", "gitignore", ".gitignore not found");
    return;
  }
  const content = fs.readFileSync(gitignore, "utf-8");
  if (content.includes(".kimi/agents/")) {
    result("PASS", "gitignore", ".kimi/agents/ is ignored");
  } else {
    result("WARN", "gitignore", ".kimi/agents/ is not in .gitignore");
  }
}

// ─── Check 8: Installer Coverage ───
function checkInstallerCoverage() {
  const installScripts = [
    "scripts/install-global.ps1",
    "scripts/install-global.sh",
    "scripts/install-project.ps1",
    "scripts/install-project.sh",
  ];

  for (const script of installScripts) {
    const p = path.join(repoPath, script);
    if (!fs.existsSync(p)) {
      result("FAIL", "installer-coverage", `${script} not found`);
      continue;
    }
    const content = fs.readFileSync(p, "utf-8");
    const hasSkills = content.includes("skills") || content.includes("skills/");
    const hasAgents = content.includes("agents") || content.includes("agents/");
    if (hasSkills && hasAgents) {
      result("PASS", "installer-coverage", `${script} covers skills/ and agents/`);
    } else {
      result("WARN", "installer-coverage", `${script} may not cover both skills/ and agents/`);
    }
  }
}

// ─── Execution ───
console.log("🔍 EKC Compatibility Auditor");
console.log("============================");

checkWrapperPaths();
checkAgentStructure();
checkAgentYamlTools();
checkFlowStructure();
checkSkillFrontmatterTools();
checkClaraRefs();
checkGitignore();
checkInstallerCoverage();

console.log("\n============================");
if (failures === 0 && warnings === 0) {
  console.log(`✅ All checks passed (${passes} PASS)`);
  process.exit(0);
} else {
  console.log(`❌ ${failures} FAIL, ⚠️ ${warnings} WARN, ✅ ${passes} PASS`);
  process.exit(failures > 0 ? 1 : 0);
}
