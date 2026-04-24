#!/usr/bin/env node
/**
 * LEGACY / LOCAL-ONLY INSTALL SCRIPT
 *
 * WARNING: This script was created during a local setup adjustment and is NOT
 * the recommended installer. It performs a naive recursive copy to ~/.kimi/.
 *
 * For the official interactive installer, use packages/ekc-cli/ instead:
 *   cd packages/ekc-cli && node bin/ekc.js install
 *
 * This file is preserved for reference only.
 */

const fs = require('fs');
const path = require('path');

const REPO_ROOT = path.resolve(__dirname, '..', '..');
const AGENTS_SRC = path.join(REPO_ROOT, 'agents');
const SKILLS_SRC = path.join(REPO_ROOT, 'skills');
const KIMI_HOME = path.join(process.env.USERPROFILE || process.env.HOME, '.kimi');
const AGENTS_DEST = path.join(KIMI_HOME, 'agents');
const SKILLS_DEST = path.join(KIMI_HOME, 'skills');

function copyRecursive(src, dest) {
  const stat = fs.statSync(src);
  if (stat.isDirectory()) {
    if (!fs.existsSync(dest)) {
      fs.mkdirSync(dest, { recursive: true });
    }
    for (const entry of fs.readdirSync(src)) {
      copyRecursive(path.join(src, entry), path.join(dest, entry));
    }
  } else {
    fs.mkdirSync(path.dirname(dest), { recursive: true });
    fs.copyFileSync(src, dest);
  }
}

function install() {
  console.log('🔧 EKC Install (LEGACY)');
  console.log(`   Repo: ${REPO_ROOT}`);
  console.log();

  // Install agents
  if (fs.existsSync(AGENTS_SRC)) {
    console.log(`📦 Installing agents → ${AGENTS_DEST}`);
    if (!fs.existsSync(AGENTS_DEST)) fs.mkdirSync(AGENTS_DEST, { recursive: true });

    const entries = fs.readdirSync(AGENTS_SRC, { withFileTypes: true });
    for (const entry of entries) {
      const srcPath = path.join(AGENTS_SRC, entry.name);
      const destPath = path.join(AGENTS_DEST, entry.name);
      if (!entry.isDirectory() && entry.name !== 'ekc.yaml' && entry.name !== 'ekc.md') continue;
      console.log(`   📁 ${entry.name}`);
      copyRecursive(srcPath, destPath);
    }
  }

  // Install skills
  if (fs.existsSync(SKILLS_SRC)) {
    console.log();
    console.log(`📦 Installing skills → ${SKILLS_DEST}`);
    if (!fs.existsSync(SKILLS_DEST)) fs.mkdirSync(SKILLS_DEST, { recursive: true });

    const entries = fs.readdirSync(SKILLS_SRC, { withFileTypes: true });
    for (const entry of entries) {
      if (!entry.isDirectory()) continue;
      const srcPath = path.join(SKILLS_SRC, entry.name);
      const destPath = path.join(SKILLS_DEST, entry.name);
      console.log(`   📁 ${entry.name}`);
      copyRecursive(srcPath, destPath);
    }
  }

  console.log();
  console.log('✅ EKC installed successfully!');
  console.log();
  console.log('📝 Next steps:');
  console.log('   1. Update kimi.executablePath in VS Code to point to ~/.kimi/bin/kimi-ekc.exe');
  console.log('   2. Reload VS Code window');
}

install();
