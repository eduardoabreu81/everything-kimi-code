const fs = require("fs");
const path = require("path");
const { exists, listDirs } = require("../lib/fs-utils");

/**
 * Validate agents/skills structure in a given path.
 * Usage: ekc validate [path]
 */
async function validate(args) {
  const targetPath = args[0] || process.cwd();
  const agentsDir = path.join(targetPath, "agents");
  const skillsDir = path.join(targetPath, "skills");

  console.log(`\n🔍 Validating EKC structure in: ${targetPath}\n`);

  let errors = 0;
  let warnings = 0;

  // Validate agents
  if (exists(agentsDir)) {
    const dirs = listDirs(agentsDir);
    console.log(`Agents (${dirs.length}):`);
    for (const dir of dirs) {
      const agentPath = path.join(agentsDir, dir);
      const hasMd = exists(path.join(agentPath, "agent.md"));
      const hasYaml = exists(path.join(agentPath, "agent.yaml"));

      if (!hasMd) {
        console.log(`  ❌ ${dir}: missing agent.md`);
        errors++;
      } else if (!hasYaml) {
        console.log(`  ❌ ${dir}: missing agent.yaml`);
        errors++;
      } else {
        console.log(`  ✅ ${dir}`);
      }
    }
  } else {
    console.log("ℹ️  No agents/ directory found.");
  }

  console.log("");

  // Validate skills
  if (exists(skillsDir)) {
    const dirs = listDirs(skillsDir);
    console.log(`Skills (${dirs.length}):`);
    for (const dir of dirs) {
      const skillPath = path.join(skillsDir, dir);
      const hasMd = exists(path.join(skillPath, "SKILL.md"));

      if (!hasMd) {
        console.log(`  ❌ ${dir}: missing SKILL.md`);
        errors++;
      } else {
        const content = fs.readFileSync(path.join(skillPath, "SKILL.md"), "utf-8");
        if (!content.startsWith("---")) {
          console.log(`  ⚠️  ${dir}: missing YAML frontmatter`);
          warnings++;
        } else {
          console.log(`  ✅ ${dir}`);
        }
      }
    }
  } else {
    console.log("ℹ️  No skills/ directory found.");
  }

  console.log("\n" + (errors === 0 && warnings === 0
    ? "✅ All checks passed!"
    : `⚠️  ${errors} error(s), ${warnings} warning(s)`));

  process.exit(errors > 0 ? 1 : 0);
}

module.exports = { validate };
