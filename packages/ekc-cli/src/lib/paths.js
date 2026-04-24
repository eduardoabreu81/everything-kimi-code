const path = require("path");
const os = require("os");
const fs = require("fs");

/**
 * Resolve EKC-related paths based on environment, heuristics, or defaults.
 */

const HOME = os.homedir();

/**
 * Try to find the EKC repo by walking up from cwd looking for agents/ekc.yaml.
 */
function findRepoFromCwd() {
  let dir = process.cwd();
  while (dir !== path.parse(dir).root) {
    const candidate = path.join(dir, "agents", "ekc.yaml");
    if (fs.existsSync(candidate)) {
      return dir;
    }
    dir = path.dirname(dir);
  }
  return null;
}

// Primary repo path: from env, or heuristic from cwd, or default clone location
const EKC_REPO_PATH =
  process.env.EKC_REPO_PATH ||
  findRepoFromCwd() ||
  path.join(HOME, ".ekc", "repo");

// Kimi config directories
const KIMI_DIR = path.join(HOME, ".kimi");
const KIMI_AGENTS_DIR = path.join(KIMI_DIR, "agents");
const KIMI_SKILLS_DIR = path.join(KIMI_DIR, "skills");

module.exports = {
  HOME,
  EKC_REPO_PATH,
  KIMI_DIR,
  KIMI_AGENTS_DIR,
  KIMI_SKILLS_DIR,

  // Repo subpaths
  repoAgentsDir: () => path.join(EKC_REPO_PATH, "agents"),
  repoSkillsDir: () => path.join(EKC_REPO_PATH, "skills"),
  repoScriptsDir: () => path.join(EKC_REPO_PATH, "scripts"),
  repoKimiMemDir: () => path.join(EKC_REPO_PATH, "kimi-mem"),
};
