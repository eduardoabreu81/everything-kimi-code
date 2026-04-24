const fs = require("fs");
const path = require("path");
const readline = require("readline");
const { EKC_REPO_PATH, repoAgentsDir, repoSkillsDir, KIMI_AGENTS_DIR, KIMI_SKILLS_DIR } = require("../lib/paths");
const { exists, listDirs, linkOrCopy } = require("../lib/fs-utils");

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
});

function ask(question) {
  return new Promise((resolve) => rl.question(question, resolve));
}

/**
 * Interactive installer for EKC agents and skills.
 */
async function install(args) {
  console.log("\n🔧 EKC Installer\n");

  // Ensure repo exists
  if (!exists(EKC_REPO_PATH)) {
    console.log(`EKC repo not found at ${EKC_REPO_PATH}`);
    const cloneNow = await ask("Clone from GitHub now? (y/n): ");
    if (cloneNow.toLowerCase() === "y") {
      console.log("Cloning... (not yet implemented in MVP)");
      // TODO: implement git clone
    } else {
      console.log("Aborting. Set EKC_REPO_PATH to your local clone.");
      process.exit(1);
    }
  }

  const agentsDir = repoAgentsDir();
  const skillsDir = repoSkillsDir();

  const availableAgents = listDirs(agentsDir);
  const availableSkills = listDirs(skillsDir);

  console.log(`📦 Available agents: ${availableAgents.length}`);
  console.log(`📦 Available skills: ${availableSkills.length}\n`);

  // Install agents
  const installAllAgents = await ask("Install ALL agents? (y/n): ");
  if (installAllAgents.toLowerCase() === "y") {
    for (const agent of availableAgents) {
      const src = path.join(agentsDir, agent);
      const dest = path.join(KIMI_AGENTS_DIR, agent);
      linkOrCopy(src, dest);
      console.log(`  ✓ ${agent}`);
    }
  } else {
    console.log("Skipping agents.");
  }

  // Install skills
  const installAllSkills = await ask("Install ALL skills? (y/n): ");
  if (installAllSkills.toLowerCase() === "y") {
    for (const skill of availableSkills) {
      const src = path.join(skillsDir, skill);
      const dest = path.join(KIMI_SKILLS_DIR, skill);
      linkOrCopy(src, dest);
      console.log(`  ✓ ${skill}`);
    }
  } else {
    console.log("Skipping skills.");
  }

  console.log("\n✅ Installation complete!");
  console.log(`Agents installed to: ${KIMI_AGENTS_DIR}`);
  console.log(`Skills installed to: ${KIMI_SKILLS_DIR}`);

  rl.close();
}

module.exports = { install };
