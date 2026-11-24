---
name: quickstart
description: Use when the user wants to set up, install, authenticate, or configure the Zilliz Cloud CLI and cluster context for the first time (one-shot onboarding).
---

Guide the user through the complete Zilliz Cloud CLI setup. Follow these steps in order:

## Step 1: Install zilliz-cli

Check if already installed:

```bash
zilliz --version
```

If not installed or needs upgrading, run the bundled installer script from the `setup` skill directory (resolve `<quickstart-skill-dir>` to the directory containing this `SKILL.md` file):

```bash
# macOS / Linux
bash "<quickstart-skill-dir>/../setup/scripts/install-cli.sh"
```

```powershell
# Windows (PowerShell)
powershell -ExecutionPolicy Bypass -File "<quickstart-skill-dir>\..\setup\scripts\install-cli.ps1"
```

Verify:

```bash
zilliz --version
```

## Step 2: Authenticate

Check if already logged in:

```bash
zilliz auth status
```

If not logged in, instruct the user to open their own terminal and run one of:

1. **Browser login (recommended)** -- `zilliz login` -- opens browser for OAuth, full feature access.
2. **API Key via login** -- `zilliz login --api-key` -- prompts for API key, no browser needed.
3. **API Key via configure (legacy)** -- `zilliz configure` -- prompts for API key, simpler setup.
4. **Environment variable** -- add `export ZILLIZ_API_KEY=<key>` to `.zshrc` / `.bashrc`.

**IMPORTANT:** These commands require interactive input and cannot run inside a non-interactive AI coding agent session. Do NOT ask the user to paste API keys into the chat.

Wait for the user to confirm login is complete, then verify:

```bash
zilliz auth status
```

## Step 3: Select a Cluster

List available clusters:

```bash
zilliz cluster list
```

If no clusters exist, offer to create one:

```bash
zilliz project list
zilliz cluster regions
zilliz cluster create --type serverless --name <name> --project-id <id> --region <region>
```

## Step 4: Set Cluster Context

Set the active cluster for data operations:

```bash
zilliz context set --cluster-id <selected-cluster-id>
```

## Step 5: Verify

Confirm everything works:

```bash
zilliz context current
zilliz collection list
```

Report the setup result to the user, showing their cluster ID, endpoint, and database.
