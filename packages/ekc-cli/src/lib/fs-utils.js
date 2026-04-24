const fs = require("fs");
const path = require("path");

/**
 * Check if a path exists.
 * @param {string} p
 * @returns {boolean}
 */
function exists(p) {
  try {
    fs.accessSync(p);
    return true;
  } catch {
    return false;
  }
}

/**
 * List directories inside a path.
 * @param {string} dir
 * @returns {string[]}
 */
function listDirs(dir) {
  if (!exists(dir)) return [];
  return fs
    .readdirSync(dir)
    .filter((name) => fs.statSync(path.join(dir, name)).isDirectory());
}

/**
 * List files inside a path.
 * @param {string} dir
 * @returns {string[]}
 */
function listFiles(dir) {
  if (!exists(dir)) return [];
  return fs
    .readdirSync(dir)
    .filter((name) => fs.statSync(path.join(dir, name)).isFile());
}

/**
 * Create a symbolic link (or copy on Windows without admin privileges).
 * @param {string} target
 * @param {string} linkPath
 */
function linkOrCopy(target, linkPath) {
  if (exists(linkPath)) {
    const stat = fs.lstatSync(linkPath);
    if (stat.isSymbolicLink() || stat.isDirectory() || stat.isFile()) {
      fs.rmSync(linkPath, { recursive: true, force: true });
    }
  }

  try {
    fs.symlinkSync(target, linkPath, "junction");
  } catch {
    // Fallback to recursive copy if symlink fails (common on Windows without admin)
    fs.cpSync(target, linkPath, { recursive: true });
  }
}

module.exports = {
  exists,
  listDirs,
  listFiles,
  linkOrCopy,
};
