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
pip show zilliz-cli
```

If not installed:

```bash
pip install zilliz-cli
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

If not logged in, ask the user which authentication method they prefer:

1. **Browser login (recommended)** — Run `zilliz login`. Opens browser for OAuth authentication. Full feature access including organization management.
2. **API Key** — Run `zilliz login --api-key`. Simpler setup, just paste an API key from the Zilliz Cloud console.

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
