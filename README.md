# Zilliz Cloud Plugin for Claude Code

Manage [Zilliz Cloud](https://zilliz.com/) clusters and [Milvus](https://milvus.io/) vector databases directly from [Claude Code](https://claude.ai/code).

## What It Does

This plugin teaches Claude how to use the `zilliz-cli` to manage your Zilliz Cloud environment. Instead of memorizing CLI commands, just describe what you want in natural language:

- "Create a new collection with 768-dimension vectors"
- "Search for similar items in my product collection"
- "Show me the status of my cluster"
- "Set up a backup policy for my production cluster"

## Installation

```bash
/install zilliztech/zilliz-plugin
```

## Quick Start

After installing the plugin, run:

```
/quickstart
```

This guides you through installing the CLI, logging in, and connecting to a cluster.

## Commands

| Command | Description |
|---------|-------------|
| `/quickstart` | Install CLI, authenticate, and set up cluster context |
| `/status` | Show cluster status, collections, and statistics |

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
| **Partitions** | Create, load, release, manage |
| **Monitoring** | Cluster status, collection stats |
| **Projects** | Project and region management |

## Requirements

- Python 3.10+
- A [Zilliz Cloud](https://cloud.zilliz.com/) account (or local Milvus instance)

## License

Apache License 2.0
