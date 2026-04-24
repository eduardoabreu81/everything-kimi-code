const { execSync } = require("child_process");
const { EKC_REPO_PATH, KIMI_DIR, KIMI_AGENTS_DIR, KIMI_SKILLS_DIR } = require("../lib/paths");
const { exists, listDirs } = require("../lib/fs-utils");

/**
 * Diagnose the EKC installation and environment.
 */
async function doctor() {
  console.log("\n🩺 EKC Doctor\n");

  let issues = 0;

  // Check Kimi CLI
  try {
    const version = execSync("kimi --version", { encoding: "utf-8" }).trim();
    console.log(`✅ Kimi CLI: ${version}`);
  } catch {
    console.log("❌ Kimi CLI not found in PATH");
    issues++;
  }

  // Check EKC repo
  if (exists(EKC_REPO_PATH)) {
    console.log(`✅ EKC repo: ${EKC_REPO_PATH}`);
  } else {
    console.log(`❌ EKC repo not found at ${EKC_REPO_PATH}`);
    issues++;
  }

  // Check Kimi directories
  if (exists(KIMI_DIR)) {
    console.log(`✅ Kimi config dir: ${KIMI_DIR}`);
  } else {
    console.log(`⚠️  Kimi config dir not found: ${KIMI_DIR}`);
    issues++;
  }

  // Check installed agents
  if (exists(KIMI_AGENTS_DIR)) {
    const count = listDirs(KIMI_AGENTS_DIR).length;
    console.log(`✅ Installed agents: ${count}`);
  } else {
    console.log(`⚠️  Agents dir not found: ${KIMI_AGENTS_DIR}`);
  }

  // Check installed skills
  if (exists(KIMI_SKILLS_DIR)) {
    const count = listDirs(KIMI_SKILLS_DIR).length;
    console.log(`✅ Installed skills: ${count}`);
  } else {
    console.log(`⚠️  Skills dir not found: ${KIMI_SKILLS_DIR}`);
  }

  // Check environment variables
  if (process.env.EKC_REPO_PATH) {
    console.log(`✅ EKC_REPO_PATH: ${process.env.EKC_REPO_PATH}`);
  } else {
    console.log(`ℹ️  EKC_REPO_PATH not set (using default: ${EKC_REPO_PATH})`);
  }

  console.log("\n" + (issues === 0 ? "✅ All checks passed!" : `⚠️  ${issues} issue(s) found.`));
}

module.exports = { doctor };
