# VS Code Extension Setup for EKC

> **Note:** The methods below use `--agent-file` as a **local workaround**. The official IDE integration path supported by Kimi Code CLI is **ACP (Agent Client Protocol)** via `kimi acp`. See [Using in IDEs](https://moonshotai.github.io/kimi-cli/en/guides/ides.md) in the official documentation. The wrapper approach documented here works for the current VS Code Extension by overriding `kimi.executablePath`, but ACP is the recommended long-term solution.

This guide explains how to configure the **Kimi VS Code Extension** to automatically load the **EKC main agent** (`agents/ekc.yaml`) on every session.

---

## Option 1: Wrapper Script (Recommended)

The Kimi VS Code Extension has a setting `kimi.executablePath` that lets you point to a custom executable instead of the bundled `kimi` CLI. We provide a wrapper script that automatically adds `--agent-file agents/ekc.yaml`.

### Windows

1. Open VS Code Settings (`Ctrl+,`)
2. Search for `kimi.executablePath`
3. Set it to the absolute path of the wrapper:
   ```
   C:\Users\Eduardo\OneDrive\Documentos\GitHub\everything-kimi-code\scripts\kimi-ekc.cmd
   ```
   (Adjust the path if your repo is cloned elsewhere.)

4. Restart VS Code or reload the window.

### macOS / Linux

1. Open VS Code Settings (`Cmd+,` or `Ctrl+,`)
2. Search for `kimi.executablePath`
3. Set it to the absolute path of the wrapper:
   ```
   /home/YOUR_USER/path/to/everything-kimi-code/scripts/kimi-ekc.sh
   ```
4. Make sure the script is executable:
   ```bash
   chmod +x /home/YOUR_USER/path/to/everything-kimi-code/scripts/kimi-ekc.sh
   ```
5. Restart VS Code or reload the window.

---

## Option 2: Terminal Wrapper (Manual)

If you prefer not to change the extension executable, you can:

1. Add the `scripts/` folder to your `PATH`
2. Use `kimi-ekc.ps1` (PowerShell) or `kimi-ekc.sh` (Bash) directly in the integrated terminal:
   ```powershell
   # PowerShell
   .\scripts\kimi-ekc.ps1
   ```

---

## Option 3: Symlink (Advanced)

Create a symlink named `kimi` that points to the wrapper, placing it earlier in your `PATH` than the real `kimi` binary.

### PowerShell (Windows)
```powershell
# Example: create a bin directory in your profile
$binDir = "$env:USERPROFILE\bin"
New-Item -ItemType Directory -Force -Path $binDir

# Create a symlink or wrapper
Copy-Item C:\path\to\everything-kimi-code\scripts\kimi-ekc.cmd "$binDir\kimi.cmd"

# Add to PATH if not already there
[Environment]::SetEnvironmentVariable("PATH", "$binDir;$env:PATH", "User")
```

---

## Verifying It Works

1. Open the Kimi panel in VS Code (`Ctrl+Shift+P` → "Kimi: Open Chat")
2. Start a new conversation
3. The agent should identify itself as **EKC** and list the 64 available subagents.

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| "Agent file not found" | Verify the path in `kimi.executablePath` and ensure `agents/ekc.yaml` exists. |
| "kimi command not found" inside wrapper | Ensure the real `kimi` binary is available in your system `PATH`. |
| Wrapper not executing | On Windows, use the `.cmd` wrapper. On macOS/Linux, ensure the `.sh` script has execute permissions (`chmod +x`). |
| Extension uses bundled CLI | Explicitly set `kimi.executablePath` to override the bundled CLI. |
