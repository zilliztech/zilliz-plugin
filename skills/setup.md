---
name: setup
description: Use when the user needs to install zilliz-cli, log in to Zilliz Cloud, configure credentials, or set the active cluster context. Also use when any other skill reports a missing prerequisite.
---

## Prerequisites

Before running any zilliz-cli command, verify the following in order:

1. **CLI installed?** Run `pip show zilliz-cli`. If not installed, run `pip install zilliz-cli`.
2. **Logged in?** Run `zilliz auth status`. If not logged in, guide through login (see below).
3. **Context set?** (Only for data-plane operations) Run `zilliz context current`. If no context, guide through context setup.

## Commands Reference

### Install CLI

```bash
pip install zilliz-cli
```

Verify installation:

```bash
zilliz version
```

### Authentication

The CLI supports two login methods. Ask the user which they prefer:

**Option 1: Browser-based login (OAuth) — full feature access**

```bash
zilliz login
```

- Opens a browser for authentication
- Retrieves user info, organization data, and API keys
- Use `--no-browser` if running in a headless environment (displays a URL to visit manually)

**Option 2: API Key — simple, no browser needed**

```bash
zilliz login --api-key
```

- Prompts for an API key (found in Zilliz Cloud console under API Keys)
- Some features like organization switching are not available

### Check Login Status

```bash
zilliz auth status
```

### Switch Organization

```bash
# Interactive selection
zilliz auth switch

# Direct switch by org ID
zilliz auth switch <org-id>
```

### Logout

```bash
zilliz logout
```

### Configure API Key Directly

```bash
# Interactive prompt
zilliz configure

# Set specific key
zilliz configure set api_key

# View current config
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

## Guidance

- Always check prerequisites before executing any command.
- If a prerequisite fails, fix it before proceeding — do not skip ahead.
- When login fails, suggest the alternative login method.
- After setting context, verify with `zilliz context current`.
- For data-plane commands in other skills, always verify context is set first.
