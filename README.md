# Zilliz Cloud Plugin for Claude Code

Your Zilliz Cloud console in Claude Code. This plugin enables Claude to operate the `zilliz-cli`, bringing the full power of [Zilliz Cloud](https://zilliz.com/) — cluster management, collection operations, vector search, RBAC, backups, and more — into your terminal through natural language.

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

## Installation

### From Claude Code Marketplace

Search for **zilliz** in the plugin directory, or add the marketplace manually:

```
/plugin marketplace add zilliztech/zilliz-plugin
```

Then install via the Discover tab in `/plugin`.

### Direct Install

```bash
/plugin install zilliz@zilliztech/zilliz-plugin
```

## Quick Start

After installing the plugin, run:

```
/zilliz:quickstart
```

This guides you through installing the CLI, logging in, and connecting to a cluster.

## Commands

| Command | Description |
|---------|-------------|
| `/zilliz:quickstart` | Install CLI, authenticate, and set up cluster context |
| `/zilliz:status` | Show cluster status, collections, and statistics |

## Skills

| Skill | Description |
|-------|-------------|
| `zilliz:setup` | Install zilliz-cli, log in, configure credentials, set active cluster context |
| `zilliz:cluster` | Create, list, describe, delete, suspend, resume, or modify clusters |
| `zilliz:database` | Create, list, describe, or drop databases |
| `zilliz:collection` | Create, list, describe, drop, rename, load, release, or manage collections and aliases |
| `zilliz:index` | Create, list, describe, or drop indexes |
| `zilliz:partition` | Create, list, load, release, or drop partitions |
| `zilliz:vector` | Search, query, insert, upsert, get, or delete vectors |
| `zilliz:import` | Bulk data import from cloud storage |
| `zilliz:backup` | Create, list, describe, delete, export, restore backups, or manage backup policies |
| `zilliz:job` | Track async Cloud Job status (backup, restore, migration, import, clone) |
| `zilliz:user-role` | Manage database users, roles, passwords, and access privileges |
| `zilliz:monitoring` | Check cluster status, collection statistics, and load states |
| `zilliz:billing` | Check usage, view invoices, or manage payment methods |
| `zilliz:project-region` | Manage projects and storage volumes |

## Capabilities

| Area | What You Can Do |
|------|----------------|
| **Clusters** | Create, delete, suspend, resume, modify |
| **Collections** | Create with custom schema, load, release, rename, drop |
| **Vectors** | Search, query, insert, upsert, delete |
| **Indexes** | Create, list, describe, drop |
| **Databases** | Create, list, describe, drop |
| **Users & Roles** | RBAC setup, privilege management |
| **Backups** | Create, restore, export, policy management |
| **Import** | Bulk data import from cloud storage |
| **Jobs** | Track async operations (backup, restore, migration, import, clone) |
| **Partitions** | Create, load, release, manage |
| **Monitoring** | Cluster status, collection stats, load states |
| **Billing** | Usage, invoices, payment methods |
| **Projects** | Project and region management |

## Requirements

- A [Zilliz Cloud](https://cloud.zilliz.com/) account (or local Milvus instance)

## License

Apache License 2.0
