const { execSync } = require("child_process");
const { EKC_REPO_PATH } = require("../lib/paths");
const { exists } = require("../lib/fs-utils");

/**
 * Update EKC to the latest version from GitHub.
 */
async function update() {
  console.log("\n🔄 EKC Updater\n");

  if (!exists(EKC_REPO_PATH)) {
    console.error(`EKC repo not found at ${EKC_REPO_PATH}`);
    console.error("Run `ekc install` first or clone the repository manually.");
    process.exit(1);
  }

  try {
    console.log("Pulling latest changes...");
    execSync("git pull", { cwd: EKC_REPO_PATH, stdio: "inherit" });
    console.log("\n✅ EKC updated successfully!");
    console.log("Run `ekc install` again if new agents/skills were added.");
  } catch (err) {
    console.error("\n❌ Update failed:", err.message);
    process.exit(1);
  }
}

module.exports = { update };
