#!/usr/bin/env node

/**
 * EKC CLI Entry Point
 *
 * Usage:
 *   ekc <command> [options]
 *
 * Commands:
 *   install    Interactive installer for agents/skills
 *   update     Update EKC to the latest version
 *   doctor     Diagnose the EKC installation
 *   status     Show installed agents and skills
 *   validate   Validate custom agents/skills structure
 */

const path = require("path");
const cliPath = path.join(__dirname, "..", "src", "cli.js");

require(cliPath);
