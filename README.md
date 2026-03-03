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
