# Zilliz Cloud Plugin for Claude Code & OpenAI Codex

Your Zilliz Cloud console in your AI coding agent. This plugin lets Claude Code or OpenAI Codex operate the `zilliz-cli`, bringing the full power of [Zilliz Cloud](https://zilliz.com/) — cluster management, collection operations, vector search, RBAC, backups, and more — into your terminal through natural language.

It ships as a **dual-format plugin** living in `plugins/zilliz/`: `.claude-plugin/plugin.json` for Claude Code and `.codex-plugin/plugin.json` for Codex, sharing one real `skills/` directory — no symlinks, no duplication. Both root `.claude-plugin/marketplace.json` and `.agents/plugins/marketplace.json` point their plugin source at `./plugins/zilliz`.

## What It Does

Instead of memorizing CLI commands or switching to the web console, just describe what you want:

- "Create a serverless cluster in us-east-1 and set up a collection with 768-dimension vectors"
- "Search for similar items in my product collection with filter age > 20"
- "Show me the status of all my clusters and collections"
- "Set up a daily backup policy for my production cluster with 7-day retention"
- "Create a role with read-only access to the analytics collection"
- "Import data from S3 into my embeddings collection"
- "Check the status of my import job"
- "Show me this month's usage and invoices"
- "Spin up a Vector Lake in us-east-1 and create an on-demand cluster with a 30-minute idle TTL"
- "Refresh my external collection from Vector Lake and tell me when the job finishes"

## Installation

### From Claude Code Marketplace

Search for **zilliz** in the plugin directory, or add the marketplace manually:

```
/plugin marketplace add zilliztech/zilliz-plugin
```

`zilliztech/zilliz-plugin` is the GitHub repo. Once added, the marketplace is
named **`zilliztech`** (from `marketplace.json`) and the plugin is named
**`zilliz`**. Then install via the Discover tab in `/plugin`.

### Direct Install

```bash
/plugin install zilliz@zilliztech
```

The format is `<plugin>@<marketplace>` — `zilliz@zilliztech`, **not**
`zilliz@zilliztech/zilliz-plugin` (that repo path is not the marketplace name).

### Upgrading

`/plugin marketplace add` does not refresh an already-added marketplace, and
`/plugin install` is a no-op if the plugin is already installed. To pull a new
version:

```bash
/plugin marketplace update zilliztech
/plugin update zilliz@zilliztech
```

### With OpenAI Codex

Codex reads the same repo via `.agents/plugins/marketplace.json`, which points
at the self-contained Codex plugin under `plugins/zilliz/` (its real `skills/`
directory is shared with the Claude Code build). Add the marketplace:

```bash
codex plugin marketplace add zilliztech/zilliz-plugin
```

Then open `/plugins` in Codex and install **zilliz** from the marketplace.

#### Via codex-marketplace (one-liner)

Alternatively, install directly with [`codex-marketplace`](https://www.npmjs.com/package/codex-marketplace):

```bash
npx codex-marketplace add zilliztech/zilliz-plugin --plugins
```

All skills are shared with the Claude Code build; the `quickstart` and `status`
skills replace the Claude `/zilliz:*` slash commands under Codex.

## Quick Start

After installing the plugin:

- **Claude Code:** run `/zilliz:quickstart`
- **Codex:** invoke the `quickstart` skill (e.g. "set up the Zilliz CLI")

This guides you through installing the CLI, logging in, and connecting to a cluster.

## Commands (Claude Code)

| Command | Description |
|---------|-------------|
| `/zilliz:quickstart` | Install CLI, authenticate, and set up cluster context |
| `/zilliz:status` | Show cluster status, collections, and statistics |

Under Codex these are available as the `quickstart` and `status` skills below.

## Skills

| Skill | Description |
|-------|-------------|
| `zilliz:quickstart` | One-shot onboarding: install CLI, authenticate, select and set cluster context |
| `zilliz:status` | Overview of context, cluster details, databases, and collections with stats |
| `zilliz:setup` | Install zilliz-cli, log in, configure credentials, set active cluster context |
| `zilliz:cluster` | Create, list, describe, delete, suspend, resume, or modify clusters (including `create-vectorlake` for Vector Lake instances) |
| `zilliz:on-demand-cluster` | Create, list, describe, or delete on-demand (Vector Lake) clusters with auto-suspend TTL |
| `zilliz:database` | Create, list, describe, or drop databases |
| `zilliz:collection` | Create, list, describe, drop, rename, load, release, manage aliases, and query per-collection metrics |
| `zilliz:external-collection` | Trigger, describe, or list refresh jobs for external collections (Vector Lake-backed) |
| `zilliz:index` | Create, list, describe, or drop indexes |
| `zilliz:partition` | Create, list, load, release, or drop partitions |
| `zilliz:vector` | Search, query, insert, upsert, get, or delete vectors |
| `zilliz:import` | Bulk data import from cloud storage; manage import stages |
| `zilliz:backup` | Create, list, describe, delete, export, restore backups, or manage backup policies |
| `zilliz:job` | Track async Cloud Job status (backup, restore, migration, import, clone) |
| `zilliz:user-role` | Manage database users, roles, passwords, and access privileges |
| `zilliz:monitoring` | Check cluster status, collection statistics, and load states |
| `zilliz:billing` | Check usage, view invoices, or manage payment methods |
| `zilliz:project-region` | Manage projects and storage volumes |
| `zilliz:privatelink` | Manage PrivateLink endpoint services, endpoints, and whitelist |

## Capabilities

| Area | What You Can Do |
|------|----------------|
| **Clusters** | Create, delete, suspend, resume, modify |
| **Vector Lake** | Create Vector Lake instances; provision, list, describe, and delete on-demand clusters with auto-suspend TTL |
| **Collections** | Create with custom schema, load, release, rename, drop |
| **External Collections** | Trigger / describe / list refresh jobs against Vector Lake-backed sources |
| **Vectors** | Search, query, insert, upsert, delete |
| **Indexes** | Create, list, describe, drop |
| **Databases** | Create, list, describe, drop |
| **Users & Roles** | RBAC setup, privilege management |
| **Backups** | Create, restore, export, policy management |
| **Import** | Bulk data import from cloud storage; managed import stages |
| **Jobs** | Track async operations (backup, restore, migration, import, clone) |
| **Partitions** | Create, load, release, manage |
| **Monitoring** | Cluster status, collection stats, load states, cluster and per-collection time-series metrics |
| **Billing** | Usage, invoices, payment methods |
| **Projects** | Project and region management |
| **PrivateLink** | Endpoint services, project endpoints, whitelist management |

## Requirements

- A [Zilliz Cloud](https://cloud.zilliz.com/) account (or local Milvus instance)

## License

Apache License 2.0
