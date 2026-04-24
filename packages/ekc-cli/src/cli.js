const { install } = require("./commands/install");
const { update } = require("./commands/update");
const { doctor } = require("./commands/doctor");
const { status } = require("./commands/status");
const { validate } = require("./commands/validate");

const commands = {
  install,
  update,
  doctor,
  status,
  validate,
};

function showHelp() {
  console.log(`
EKC CLI — Everything Kimi Code

Usage: ekc <command> [options]

Commands:
  install    Interactive installer (select agents/skills to install)
  update     Update EKC to the latest version from GitHub
  doctor     Diagnose the EKC installation and environment
  status     Show what is currently installed
  validate   Validate agents/skills structure in a given path

Options:
  -h, --help     Show this help message
  -v, --version  Show version number
`);
}

function showVersion() {
  const pkg = require("../package.json");
  console.log(pkg.version);
}

async function main() {
  const args = process.argv.slice(2);

  if (args.length === 0 || args[0] === "-h" || args[0] === "--help") {
    showHelp();
    process.exit(0);
  }

  if (args[0] === "-v" || args[0] === "--version") {
    showVersion();
    process.exit(0);
  }

  const [command, ...rest] = args;

  if (!commands[command]) {
    console.error(`Error: Unknown command "${command}"`);
    showHelp();
    process.exit(1);
  }

  try {
    await commands[command](rest);
  } catch (err) {
    console.error(`Error executing "${command}":`, err.message);
    process.exit(1);
  }
}

main();
