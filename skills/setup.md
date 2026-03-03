---
name: setup
description: Use when the user needs to install zilliz-cli, log in to Zilliz Cloud, configure credentials, or set the active cluster context. Also use when any other skill reports a missing prerequisite.
---

## Prerequisites

Before running any zilliz-cli command, verify the following in order:

1. **CLI installed and up to date?** Run `python3 -m pip install --upgrade zilliz-cli` to ensure the latest version is installed.
2. **Logged in?** Run `zilliz auth status`. If not logged in, guide through login (see below).
3. **Context set?** (Only for data-plane operations) Run `zilliz context current`. If no context, guide through context setup.

## Commands Reference

### Install / Upgrade CLI

```bash
python3 -m pip install --upgrade zilliz-cli
```

Verify installation:

```bash
zilliz --version
```

### Authentication

**IMPORTANT:** Login commands (`zilliz login`, `zilliz configure`) require an interactive terminal and CANNOT run inside Claude Code. Always instruct the user to run these in their own terminal.

Check if already logged in:

```bash
zilliz auth status
```

If not logged in, tell the user to open their own terminal and run one of the following:

**Option 1: Browser-based login (OAuth) — full feature access**

```
zilliz login
```

- Opens a browser for authentication
- Retrieves user info, organization data, and API keys
- Use `--no-browser` in headless environments (displays a URL to visit manually)

**Option 2: API Key — simple, no browser needed**

```
zilliz configure
```

- Prompts for an API key (found in Zilliz Cloud console under API Keys)
- Limitations compared to OAuth login:
  - Organization switching not available
  - On Serverless clusters: database management, user/role management may be restricted
  - Some control-plane operations may require OAuth login

**Option 3: Environment variable**

User can add to their shell profile (`.zshrc` / `.bashrc`):

```
export ZILLIZ_API_KEY=<your-api-key>
```

After the user completes authentication, verify by running:

```bash
zilliz auth status
```

### Switch Organization

These commands require an interactive terminal. Instruct the user to run in their own terminal:

```
# Interactive selection
zilliz auth switch

# Direct switch by org ID
zilliz auth switch <org-id>
```

### Logout

```bash
zilliz logout
```

### View Current Config

```bash
zilliz configure list
```

### Set Cluster Context

Data-plane commands (collection, vector, index, etc.) require an active cluster context.

```bash
# Set by cluster ID (endpoint auto-resolved)
zilliz context set --cluster-id <cluster-id>

# Set with explicit endpoint
zilliz context set --cluster-id <cluster-id> --endpoint <url>

# Change database (default: "default")
zilliz context set --database <db-name>
```

### View Current Context

```bash
zilliz context current
```

## Output Format

All zilliz-cli commands support `--output json` for structured, machine-readable output. Use this when you need to parse results programmatically:

```bash
zilliz cluster list --output json
zilliz collection describe --name <name> --output json
```

Available formats: `json`, `table`, `text`. Default is `text`.

## Cluster Type Differences

Different cluster types have different feature support:

| Feature | Free | Serverless | Dedicated |
|---|---|---|---|
| Collection CRUD | Yes | Yes | Yes |
| Vector search/query | Yes | Yes | Yes |
| Database create/drop | No | No | Yes |
| User/role management | No | Limited | Yes |
| Backup management | No | Yes | Yes |
| Cluster modify | No | No | Yes |

When a command fails with a permissions error, check the cluster type first — the feature may not be available on that cluster type.

## Guidance

- Always check prerequisites before executing any command.
- If a prerequisite fails, fix it before proceeding — do not skip ahead.
- NEVER run `zilliz login`, `zilliz configure`, or `zilliz auth switch` (without arguments) inside Claude Code — they require interactive input. Always instruct the user to run these in their own terminal.
- NEVER ask the user to paste API keys into the chat — this is a security risk. Guide them to configure credentials in their own terminal instead.
- After the user reports login is complete, verify with `zilliz auth status`.
- After setting context, verify with `zilliz context current`.
- For data-plane commands in other skills, always verify context is set first.
- When a command fails unexpectedly, consider whether the cluster type or auth mode may be the cause.
