const { EKC_REPO_PATH, KIMI_AGENTS_DIR, KIMI_SKILLS_DIR } = require("../lib/paths");
const { exists, listDirs } = require("../lib/fs-utils");

/**
 * Show what is currently installed.
 */
async function status() {
  console.log("\n📊 EKC Status\n");

  if (exists(EKC_REPO_PATH)) {
    const repoAgents = listDirs(EKC_REPO_PATH + "/agents");
    const repoSkills = listDirs(EKC_REPO_PATH + "/skills");
    console.log(`Repository: ${EKC_REPO_PATH}`);
    console.log(`  Available agents: ${repoAgents.length}`);
    console.log(`  Available skills: ${repoSkills.length}`);
  } else {
    console.log(`Repository not found: ${EKC_REPO_PATH}`);
  }

  console.log("");

  if (exists(KIMI_AGENTS_DIR)) {
    const agents = listDirs(KIMI_AGENTS_DIR);
    console.log(`Installed agents (${agents.length}):`);
    for (const a of agents.slice(0, 10)) {
      console.log(`  • ${a}`);
    }
    if (agents.length > 10) console.log(`  ... and ${agents.length - 10} more`);
  } else {
    console.log("No agents installed.");
  }

  console.log("");

  if (exists(KIMI_SKILLS_DIR)) {
    const skills = listDirs(KIMI_SKILLS_DIR);
    console.log(`Installed skills (${skills.length}):`);
    for (const s of skills.slice(0, 10)) {
      console.log(`  • ${s}`);
    }
    if (skills.length > 10) console.log(`  ... and ${skills.length - 10} more`);
  } else {
    console.log("No skills installed.");
  }
}

module.exports = { status };
