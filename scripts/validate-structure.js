#!/usr/bin/env node

/**
 * EKC Structure Validator
 * Valida a estrutura básica de agents e skills no repositório.
 *
 * Uso: node scripts/validate-structure.js [caminho-do-repo]
 */

const fs = require("fs");
const path = require("path");

const repoPath = process.argv[2] || path.resolve(__dirname, "..");
let errors = 0;
let warnings = 0;

function check(condition, message, level = "error") {
  if (!condition) {
    console[level === "error" ? "error" : "log"](
      `  [${level.toUpperCase()}] ${message}`
    );
    if (level === "error") errors++;
    else warnings++;
  }
}

function validateAgents() {
  const agentsDir = path.join(repoPath, "agents");
  if (!fs.existsSync(agentsDir)) {
    console.error("[ERROR] Diretório agents/ não encontrado");
    errors++;
    return;
  }

  const dirs = fs.readdirSync(agentsDir).filter((d) =>
    fs.statSync(path.join(agentsDir, d)).isDirectory()
  );

  console.log(`\n📂 Validando agents/ (${dirs.length} encontrados)...`);

  for (const dir of dirs) {
    const agentDir = path.join(agentsDir, dir);
    const mdPath = path.join(agentDir, "agent.md");
    const yamlPath = path.join(agentDir, "agent.yaml");

    check(fs.existsSync(mdPath), `agent.md ausente em agents/${dir}/`);
    check(fs.existsSync(yamlPath), `agent.yaml ausente em agents/${dir}/`);
  }
}

function validateSkills() {
  const skillsDir = path.join(repoPath, "skills");
  if (!fs.existsSync(skillsDir)) {
    console.error("[ERROR] Diretório skills/ não encontrado");
    errors++;
    return;
  }

  const dirs = fs.readdirSync(skillsDir).filter((d) =>
    fs.statSync(path.join(skillsDir, d)).isDirectory()
  );

  console.log(`\n📂 Validando skills/ (${dirs.length} encontradas)...`);

  for (const dir of dirs) {
    const skillDir = path.join(skillsDir, dir);
    const mdPath = path.join(skillDir, "SKILL.md");

    check(fs.existsSync(mdPath), `SKILL.md ausente em skills/${dir}/`);

    if (fs.existsSync(mdPath)) {
      const content = fs.readFileSync(mdPath, "utf-8");
      check(
        content.startsWith("---"),
        `Frontmatter YAML ausente em skills/${dir}/SKILL.md`,
        "warning"
      );
    }
  }
}

function validateRootFiles() {
  console.log("\n📄 Validando arquivos raiz...");
  const required = ["README.md", "LICENSE", "CONTRIBUTING.md", "CHANGELOG.md"];
  for (const file of required) {
    check(
      fs.existsSync(path.join(repoPath, file)),
      `${file} ausente na raiz do repo`
    );
  }
}

// Execução
console.log("🔍 EKC Structure Validator");
console.log("==========================");

validateAgents();
validateSkills();
validateRootFiles();

console.log("\n==========================");
if (errors === 0 && warnings === 0) {
  console.log("✅ Todos os checks passaram!");
  process.exit(0);
} else {
  console.log(`⚠️  ${errors} erro(s), ${warnings} aviso(s)`);
  process.exit(errors > 0 ? 1 : 0);
}
