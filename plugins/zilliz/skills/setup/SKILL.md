---
name: setup
description: Use when the user needs to install zilliz-cli, log in to Zilliz Cloud, configure credentials, or set the active cluster context. Also use when any other skill reports a missing prerequisite.
---

## Prerequisites

Before running any zilliz-cli command, verify the following in order:

1. **CLI installed?** Run `zilliz --version`. If `zilliz` is not installed (or needs upgrading), run the bundled installer script under `scripts/` relative to this skill directory (see **Install / Upgrade CLI** below).
2. **Logged in?** Run `zilliz auth status`. If not logged in, guide the user through login in their own interactive terminal (see **Authentication** below).
3. **Context set?** (Only for data-plane operations) Run `zilliz context current`. If no context is set, guide the user through context setup.

## Commands Reference

### Install / Upgrade CLI

Check whether `zilliz` is already installed first:

```bash
zilliz --version
```

If `zilliz` is missing or out of date, run the audited local installer script bundled with this skill (resolve `<setup-skill-dir>` to the directory containing this `SKILL.md` file):

```bash
# macOS / Linux
bash "<setup-skill-dir>/scripts/install-cli.sh"
```

```powershell
# Windows (PowerShell)
powershell -ExecutionPolicy Bypass -File "<setup-skill-dir>\scripts\install-cli.ps1"
```

Alternative manual installation options:
- Install via `uv` (Python 3.10+): `uv tool install zilliz-cli`
- Download a prebuilt archive and verify against `sha256sums.txt` from [Zilliz CLI Releases](https://github.com/zilliztech/zilliz-cli/releases)

Verify installation:

```bash
zilliz --version
```

### Authentication

**IMPORTANT:** Login commands (`zilliz login`, `zilliz configure`) require an interactive terminal and CANNOT run inside a non-interactive AI coding agent session. Always instruct the user to run these commands in their own terminal.

Check if already logged in:

```bash
zilliz auth status
```

If not logged in, tell the user to open their own terminal and run one of the following:

**Option 1: Browser-based login (OAuth) -- full feature access**

```text
zilliz login
```

- Opens a browser for authentication
- Retrieves user info, organization data, and API keys
- Use `--no-browser` in headless environments (displays a URL to visit manually)

**Option 2a: API Key via login command**

```text
zilliz login --api-key
```

**Option 2b: API Key via configure (legacy)**

```text
zilliz configure
```

- Prompts for an API key (found in Zilliz Cloud console under API Keys)
- Limitations compared to OAuth login:
  - Organization switching not available
  - On Serverless clusters: database management, user/role management may be restricted
  - Some control-plane operations may require OAuth login

**Option 3: Environment variable**

User can add to their shell profile (`.zshrc` / `.bashrc`):

```text
export ZILLIZ_API_KEY=<your-api-key>
```

After the user completes authentication, verify by running:

```bash
zilliz auth status
```

### Configure Subcommands

```bash
zilliz configure                    # Interactive API key setup
zilliz configure list               # Show all config values
zilliz configure set <key> <value>  # Set a config value
zilliz configure get <key>          # Get a config value
zilliz configure clear              # Clear all credentials
```

### Switch Organization

Interactive selection requires an interactive terminal. Instruct the user to run in their own terminal:

```text
# Interactive selection
zilliz auth switch

# Direct switch by org ID
zilliz auth switch <org-id>
```

### Logout

```bash
zilliz logout
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

Available formats: `json`, `table`, `text`, `yaml`, `csv`. Default is `table`.

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

When a command fails with a permissions error, check the cluster type first -- the feature may not be available on that cluster type.

## Troubleshooting

- **"command not found" after install:** Ensure `~/.local/bin` (macOS/Linux) or `%LOCALAPPDATA%\Programs\Zilliz` (Windows) is in `PATH`, or re-run `bash "<setup-skill-dir>/scripts/install-cli.sh"` (`install-cli.ps1` on Windows).
- **"not authenticated" errors:** Run `zilliz auth status` to check login state. Tokens may have expired -- instruct the user to re-run `zilliz login` in their own terminal.
- **Context errors (no cluster set):** Run `zilliz context current` to verify. If the cluster was deleted or suspended, set a new context with `zilliz context set --cluster-id <id>`.
- **Permission or "not supported" errors:** Check the cluster type -- some operations are only available on Dedicated clusters (see Cluster Type Differences table above).
- **Network or timeout errors:** Verify the cluster is RUNNING with `zilliz cluster describe --cluster-id <id>`. Suspended clusters reject data-plane requests.

## Guidance

- Always check prerequisites before executing any command.
- If a prerequisite fails, fix it before proceeding -- do not skip ahead.
- NEVER run `zilliz login`, `zilliz configure`, or `zilliz auth switch` (without arguments) inside a non-interactive AI coding agent session -- they require interactive input. Always instruct the user to run these in their own terminal.
- NEVER ask the user to paste API keys into the chat -- this is a security risk. Guide them to configure credentials in their own terminal instead.
- After the user reports login is complete, verify with `zilliz auth status`.
- After setting context, verify with `zilliz context current`.
- For data-plane commands in other skills, always verify context is set first.
- When a command fails unexpectedly, consider whether the cluster type or auth mode may be the cause.
