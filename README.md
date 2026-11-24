# Zilliz Cloud Plugin for Google Antigravity, Claude Code & OpenAI Codex

Your Zilliz Cloud console in your AI coding agent. This plugin lets **Google Antigravity**, **Claude Code**, and **OpenAI Codex** operate `zilliz-cli`, bringing the full power of [Zilliz Cloud](https://zilliz.com/) -- cluster management, collection operations, vector search, RBAC, backups, volumes, diagnostics, and architecture guidance -- into your agent workflow through natural language.

It ships as a **unified multi-client plugin** living in `plugins/zilliz/`:
- `.antigravity-plugin/plugin.json` for **Google Antigravity**
- `.claude-plugin/plugin.json` for **Claude Code**
- `.codex-plugin/plugin.json` for **OpenAI Codex**

All three clients share one canonical `plugins/zilliz/skills/` directory -- no symlinks, no duplication.

## What It Does

Instead of memorizing CLI commands or switching to the web console, describe what you want:

- "Create a serverless cluster in aws-us-east-1 and set up a collection with 768-dimension vectors"
- "Search for similar items in my product collection with filter age > 20"
- "Show me the status of all my clusters and collections"
- "Diagnose slow queries or high latency on my active Zilliz Cloud cluster"
- "Set up a daily backup policy for my production cluster with 7-day retention"
- "Create a custom project role with read-only access to serving clusters"
- "Upload local Parquet files to a managed volume and import them into my embeddings collection"
- "Check the status of my import job"
- "Show me this month's usage and invoices"
- "Help me estimate Dedicated CU vs Serverless vCU cost for 50M 768-dim vectors at 300 QPS"

## Installation

### With Google Antigravity

Install **Zilliz Cloud** directly from the Antigravity Agent Marketplace, or install from GitHub / a local checkout using the `agy` CLI:

```bash
agy plugin install https://github.com/zilliztech/zilliz-plugin/tree/main/plugins/zilliz
```

### From Claude Code Marketplace

Search for **zilliz** in the plugin directory, or add the marketplace manually:

```text
/plugin marketplace add zilliztech/zilliz-plugin
```

`zilliztech/zilliz-plugin` is the GitHub repo. Once added, the marketplace is named **`zilliztech`** (from `marketplace.json`) and the plugin is named **`zilliz`**. Install via the Discover tab in `/plugin` or directly:

```bash
/plugin install zilliz@zilliztech
```

To upgrade an existing Claude Code installation:

```bash
/plugin marketplace update zilliztech
/plugin update zilliz@zilliztech
```

### With OpenAI Codex

Codex reads the same repo via `.agents/plugins/marketplace.json`, which points at `./plugins/zilliz`:

```bash
codex plugin marketplace add zilliztech/zilliz-plugin
```

Then open `/plugins` in Codex and install **zilliz** from the marketplace.

## Quick Start

After installing the plugin:

- **Google Antigravity:** click the starter prompt on the plugin card, or ask `"Set up zilliz-cli, check my authentication status, and select a Zilliz Cloud cluster"`
- **Claude Code:** run `/zilliz:quickstart`
- **OpenAI Codex:** invoke the `quickstart` skill (e.g., `"set up the Zilliz CLI"`)

This guides you through installing `zilliz-cli` (via the bundled SHA-256-verified installer script), authenticating in your terminal, and selecting an active cluster context.

## Commands (Claude Code)

| Command | Description |
|---------|-------------|
| `/zilliz:quickstart` | Install CLI, authenticate, and set up cluster context |
| `/zilliz:status` | Show cluster status, collections, and statistics |

Under Google Antigravity and OpenAI Codex these workflows are available directly as the `quickstart` and `status` skills below.

## Skills (24)

| Skill | Description |
|-------|-------------|
| `quickstart` | One-shot onboarding: install CLI, authenticate, select and set cluster context |
| `status` | Overview of context, cluster details, databases, and collections with stats |
| `setup` | Install `zilliz-cli`, log in, configure credentials, set active cluster context |
| `ask-zilliz` | Zilliz Cloud architecture, plan selection, CU/vCU cost estimation, schema design, and SDK code assistant |
| `diagnose` | Read-only troubleshooting for unhealthy, slow, or error-returning clusters and collections |
| `cluster` | Create, list, describe, delete, suspend, resume, or modify clusters, list Milvus versions, and create Vector Lake instances |
| `on-demand-cluster` | Create, list, describe, or delete on-demand (Vector Lake) clusters with auto-suspend TTL |
| `database` | Create, list, describe, or drop databases |
| `collection` | Create, list, describe, drop, rename, load, release, manage aliases, and query per-collection metrics |
| `external-collection` | Trigger, describe, or list refresh jobs for external collections (Vector Lake-backed) |
| `index` | Create, list, describe, or drop indexes |
| `partition` | Create, list, load, release, or drop partitions |
| `vector` | Search, hybrid search, query, insert, upsert, get, or delete vectors |
| `import` | Bulk data import from object storage or from files uploaded to a volume |
| `backup` | Create, list, describe, delete, export, restore backups, or manage backup policies |
| `job` | Track async Cloud Job status (backup, restore, migration, import, clone) |
| `user-role` | Manage database users, roles, passwords, and access privileges inside Milvus |
| `acl` | Cloud-level RBAC: custom org/project roles, member grants, and SCIM group grants |
| `monitoring` | Check cluster status, collection statistics, load states, and cluster metrics |
| `billing` | Check usage, view invoices, or manage payment methods |
| `project-region` | Manage projects and bind additional regions |
| `volume` | Manage volumes and upload local files or directories into a managed volume |
| `privatelink` | Manage PrivateLink endpoint services, endpoints, and whitelist |
| `storage-integration` | Connect customer-owned AWS S3 / Azure Blob / GCS buckets: generate access policy, validate, and manage integrations |

## Capabilities

| Area | What You Can Do |
|------|----------------|
| **Clusters** | Create (Serverless, Dedicated with explicit Milvus version/channel, Free), delete, suspend, resume, modify |
| **Vector Lake** | Create Vector Lake instances; provision, list, describe, and delete on-demand clusters with auto-suspend TTL |
| **Collections** | Create with custom schema, load, release, rename, drop, manage aliases |
| **External Collections** | Trigger / describe / list refresh jobs against Vector Lake-backed sources |
| **Vectors** | Vector search, hybrid search, filtered query, insert, upsert, delete |
| **Indexes** | Create, list, describe, drop |
| **Databases** | Create, list, describe, drop |
| **Users & Roles** | Milvus database RBAC setup and privilege management |
| **Access Control** | Cloud-level RBAC: custom org/project roles with policies, member and SCIM group grants |
| **Backups** | Create, restore (including target Milvus version/channel), export, policy management |
| **Import** | Bulk data import from object storage or volumes |
| **Jobs** | Track async operations (backup, restore, migration, import, clone) |
| **Partitions** | Create, load, release, manage |
| **Diagnostics & Monitoring** | Read-only cluster/collection diagnostics, cluster status, collection stats, cluster and per-collection metrics |
| **Billing** | Usage, invoices, payment methods |
| **Projects** | Project and region management |
| **Volumes** | Create and manage volumes; upload local files for import |
| **PrivateLink** | Endpoint services, project endpoints, whitelist management |
| **Storage Integrations** | Connect customer-owned buckets on AWS, Azure, and GCP |
| **Architecture & Costing** | Plan selection, CU/vCU sizing formulas, schema templates, and multi-language SDK examples |

## Requirements

- A [Zilliz Cloud](https://cloud.zilliz.com/) account

## License

Apache License 2.0
