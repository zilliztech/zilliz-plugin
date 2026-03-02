# Zilliz Cloud Plugin for Claude Code - Design

## Overview

A Claude Code plugin that enables Zilliz Cloud and Milvus vector database management through natural language. The plugin contains no Python code — it works entirely through Skill files (Markdown) that guide Claude to install and use `zilliz-cli`.

**Goal:** Serve as a terminal-based alternative to the Zilliz Cloud Web Console, combining CLI power with AI-assisted workflows.

## Architecture

### Core Principles

- No Python code in the plugin itself
- All capabilities delivered through Skills (Markdown guidance documents)
- Depends on `zilliz-cli` installed via `pip install zilliz-cli`
- Skills guide Claude to execute CLI commands, handle errors, and present results

### User Experience Flow

1. User installs the plugin
2. User makes a request (e.g., "create a Zilliz cluster")
3. Claude loads relevant Skill, checks prerequisites (CLI installed? logged in? context set?)
4. If not ready, guides through setup (pip install, login, context)
5. Executes the target CLI commands

## Project Structure

```
zilliz-plugin/
├── .claude-plugin/
│   └── plugin.json              # Plugin metadata, skills and commands registration
├── skills/
│   ├── setup.md                 # Install CLI, auth (OAuth / API Key), configure context
│   ├── cluster.md               # Cluster CRUD, suspend/resume
│   ├── collection.md            # Collection create/manage, schema design
│   ├── vector.md                # Search, query, insert, delete
│   ├── index.md                 # Index create/manage
│   ├── database.md              # Database management
│   ├── user-role.md             # User, role, and privilege management
│   ├── backup.md                # Backup create/restore/policy
│   ├── import.md                # Data import jobs
│   ├── monitoring.md            # Cluster status, collection stats (table display)
│   ├── project-region.md        # Project management, region/provider queries
│   └── partition.md             # Partition management
├── commands/
│   ├── quickstart.md            # /quickstart - install + login + configure in one go
│   └── status.md                # /status - cluster status overview
└── README.md
```

## Skill Design

### Unified Structure

Each Skill follows this format:

```markdown
---
name: <resource-name>
description: <trigger description — tells Claude when to use this Skill>
---

## Prerequisites
# Pre-condition checks (CLI installed? logged in? context set?)

## Commands Reference
# All zilliz-cli commands for this resource with usage, parameters, examples

## Guidance
# Behavioral guidelines for Claude:
# - Confirm user intent before executing
# - Explain what each command does
# - Error handling suggestions
```

### Prerequisite Check Chain

Every Skill guides Claude through this chain before executing commands:

```
User request → Check CLI installed (pip show zilliz-cli)
             → Check login status (zilliz auth status)
             → Check context set (zilliz context current)
             → Execute target command
```

### Language

All Skill content written in English.

## Slash Commands

### /quickstart

Full initialization flow:
1. Check Python environment
2. `pip install zilliz-cli`
3. Ask user: OAuth or API Key login
4. Execute `zilliz login` (with chosen method)
5. List available clusters (`zilliz cluster list`)
6. Guide user to select cluster and set context
7. Verify connection (`zilliz collection list`)

### /status

Collect and display cluster overview:
1. Current context (`zilliz context current`)
2. Cluster details (`zilliz cluster describe`)
3. Database list (`zilliz database list`)
4. Collection list with stats (`zilliz collection list` + `get-stats`)
5. Present as formatted tables

## Authentication Strategy

Skill presents both options and lets the user choose:
- **OAuth (browser):** `zilliz login` — full experience, retrieves org info
- **API Key:** `zilliz login --api-key` — simple, no browser needed

## Monitoring Approach

Based on existing CLI capabilities only:
- Cluster status and details
- Collection statistics (row counts)
- Collection load state
- Presented as tables (no ASCII charts in V1)

## Plugin Metadata

```json
{
  "name": "zilliz",
  "displayName": "Zilliz Cloud",
  "description": "Manage Zilliz Cloud clusters and Milvus vector databases from Claude Code",
  "author": "zilliztech",
  "version": "0.1.0"
}
```

## What Gets Deleted

All existing files in the repo are obsolete and will be replaced:
- `src/`, `tests/`, `pyproject.toml`, `.mcp.json`
- `docs/` (except this plan), `CONTRIBUTING.md`, `LICENSE`, `.github/`
- Old `commands/` directory

## Dependency

- **zilliz-cli** (`pip install zilliz-cli`) — provides all CLI commands
  - Source: `/Users/lawrance/Desktop/workspace/zilliz-cloud/vdc/zilliz-cli/`
