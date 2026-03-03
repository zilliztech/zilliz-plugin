---
name: quickstart
description: Set up Zilliz Cloud CLI — install, authenticate, and configure your cluster context in one go.
---

Guide the user through the complete Zilliz Cloud CLI setup. Follow these steps in order:

## Step 1: Check Python Environment

Run `python3 --version` to verify Python 3.10+ is available.

## Step 2: Install zilliz-cli

Check if already installed:

```bash
python3 -m pip show zilliz-cli
```

If not installed:

```bash
python3 -m pip install zilliz-cli
```

Verify:

```bash
zilliz version
```

## Step 3: Authenticate

Check if already logged in:

```bash
zilliz auth status
```

If not logged in, instruct the user to open their own terminal and run one of:

1. **Browser login (recommended)** — `zilliz login` — opens browser for OAuth, full feature access.
2. **API Key** — `zilliz configure` — prompts for API key, simpler setup.
3. **Environment variable** — add `export ZILLIZ_API_KEY=<key>` to `.zshrc` / `.bashrc`.

**IMPORTANT:** These commands require interactive input and cannot run inside Claude Code. Do NOT ask the user to paste API keys into the chat.

Wait for the user to confirm login is complete, then verify:

```bash
zilliz auth status
```

## Step 4: Select a Cluster

List available clusters:

```bash
zilliz cluster list
```

If no clusters exist, offer to create one:

```bash
zilliz project list
zilliz region list
zilliz cluster create --name <name> --project-id <id> --region <region>
```

## Step 5: Set Cluster Context

Set the active cluster for data operations:

```bash
zilliz context set --cluster-id <selected-cluster-id>
```

## Step 6: Verify

Confirm everything works:

```bash
zilliz context current
zilliz collection list
```

Report the setup result to the user, showing their cluster ID, endpoint, and database.
