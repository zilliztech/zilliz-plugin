# Zilliz Cloud Plugin Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Build a Claude Code plugin that guides Claude to use zilliz-cli for managing Zilliz Cloud clusters and Milvus vector databases.

**Architecture:** Pure Markdown plugin — no Python code. Skills guide Claude to execute `zilliz` CLI commands. Slash commands provide quick-access workflows.

**Tech Stack:** Claude Code Plugin SDK (plugin.json + skills + commands), zilliz-cli (installed via pip)

---

### Task 1: Clean up old files and create directory structure

**Files:**
- Delete: `src/`, `tests/`, `pyproject.toml`, `.mcp.json`, `CONTRIBUTING.md`, `LICENSE`
- Delete: `.github/`, `.claude-plugin/marketplace.json`
- Delete: `commands/help.md`, `commands/query.md`, `commands/quickstart.md`
- Create: `skills/` directory

**Step 1: Remove obsolete files and directories**

```bash
cd /Users/lawrance/Desktop/workspace/zilliz-plugin
rm -rf src/ tests/ .github/ .idea/
rm -f pyproject.toml .mcp.json CONTRIBUTING.md LICENSE
rm -f .claude-plugin/marketplace.json
rm -f commands/help.md commands/query.md commands/quickstart.md
rm -f docs/plans/.gitkeep
```

**Step 2: Create skills directory**

```bash
mkdir -p skills
```

**Step 3: Commit**

```bash
git add -A
git commit -m "chore: remove obsolete files for plugin redesign"
```

---

### Task 2: Create .claude-plugin/plugin.json

**Files:**
- Modify: `.claude-plugin/plugin.json`

**Step 1: Write plugin.json**

```json
{
  "name": "zilliz",
  "displayName": "Zilliz Cloud",
  "description": "Manage Zilliz Cloud clusters and Milvus vector databases from Claude Code using the zilliz-cli.",
  "version": "0.1.0",
  "author": {
    "name": "Zilliz",
    "email": "support@zilliz.com"
  },
  "homepage": "https://github.com/zilliztech/zilliz-plugin",
  "repository": "https://github.com/zilliztech/zilliz-plugin",
  "license": "Apache-2.0",
  "keywords": [
    "zilliz",
    "milvus",
    "vector-database",
    "semantic-search",
    "rag"
  ]
}
```

**Step 2: Commit**

```bash
git add .claude-plugin/plugin.json
git commit -m "chore: update plugin.json for redesign"
```

---

### Task 3: Create skills/setup.md

**Files:**
- Create: `skills/setup.md`

**Step 1: Write skills/setup.md**

```markdown
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
```

**Step 2: Commit**

```bash
git add skills/setup.md
git commit -m "feat: add setup skill for CLI installation and authentication"
```

---

### Task 4: Create skills/cluster.md

**Files:**
- Create: `skills/cluster.md`

**Step 1: Write skills/cluster.md**

```markdown
---
name: cluster
description: Use when the user wants to create, list, describe, delete, suspend, resume, or modify Zilliz Cloud clusters.
---

## Prerequisites

1. CLI installed and logged in (see setup skill).
2. No cluster context required — these are control-plane operations.

## Commands Reference

### List Clusters

```bash
zilliz cluster list
# Paginated:
zilliz cluster list --page-size 10 --page 1
# Fetch all pages:
zilliz cluster list --all
```

### Describe a Cluster

```bash
zilliz cluster describe --cluster-id <cluster-id>
```

### Create a Serverless Cluster

```bash
zilliz cluster create --name <name> --project-id <project-id> --region <region-id>
```

To find available project IDs and regions:
```bash
zilliz project list
zilliz region list
```

### Create a Free Tier Cluster

```bash
zilliz cluster create-free --name <name> --project-id <project-id> --region <region-id>
```

### Create a Dedicated Cluster

```bash
zilliz cluster create-dedicated \
  --name <name> \
  --project-id <project-id> \
  --region <region-id> \
  --cu-type <cu-type> \
  --cu-size <cu-size>
```

### Delete a Cluster

```bash
zilliz cluster delete --cluster-id <cluster-id>
```

### Suspend a Cluster

```bash
zilliz cluster suspend --cluster-id <cluster-id>
```

### Resume a Cluster

```bash
zilliz cluster resume --cluster-id <cluster-id>
```

### Modify a Cluster

```bash
zilliz cluster modify --cluster-id <cluster-id> --cu-size <new-size>
zilliz cluster modify --cluster-id <cluster-id> --replica <count>
# Or use raw JSON body:
zilliz cluster modify --cluster-id <cluster-id> --body '{"cuSize": 2, "replica": 2}'
```

## Guidance

- Before creating a cluster, help the user choose a region by listing available regions first.
- Before deleting a cluster, always confirm with the user — this is irreversible.
- After creating a cluster, suggest setting it as the active context with `zilliz context set --cluster-id <id>`.
- When a cluster is suspended, remind the user it must be resumed before data-plane operations.
```

**Step 2: Commit**

```bash
git add skills/cluster.md
git commit -m "feat: add cluster management skill"
```

---

### Task 5: Create skills/collection.md

**Files:**
- Create: `skills/collection.md`

**Step 1: Write skills/collection.md**

```markdown
---
name: collection
description: Use when the user wants to create, list, describe, drop, rename, load, release, or manage collections and collection aliases in Milvus.
---

## Prerequisites

1. CLI installed, logged in, and cluster context set (see setup skill).

## Commands Reference

### List Collections

```bash
zilliz collection list
zilliz collection list --database <db-name>
```

### Describe a Collection

```bash
zilliz collection describe --name <collection-name>
```

### Create a Collection

Quick create with auto schema:

```bash
zilliz collection create --name <name> --dimension <dim>
# Optional parameters:
#   --metric-type COSINE|L2|IP (default: COSINE)
#   --id-type Int64|VarChar
#   --auto-id true|false
#   --primary-field <name>
#   --vector-field <name>
```

Advanced create with custom schema using `--body`:

```bash
zilliz collection create --name <name> --body '{
  "schema": {
    "fields": [
      {"fieldName": "id", "dataType": "Int64", "isPrimary": true},
      {"fieldName": "vector", "dataType": "FloatVector", "elementTypeParams": {"dim": "768"}},
      {"fieldName": "text", "dataType": "VarChar", "elementTypeParams": {"max_length": "1024"}}
    ]
  }
}'
```

### Drop a Collection

```bash
zilliz collection drop --name <collection-name>
```

### Check if Collection Exists

```bash
zilliz collection has --name <collection-name>
```

### Rename a Collection

```bash
zilliz collection rename --name <old-name> --new-name <new-name>
# Move to another database:
zilliz collection rename --name <old-name> --new-name <new-name> --new-database <db-name>
```

### Load a Collection into Memory

```bash
zilliz collection load --name <collection-name>
```

### Release a Collection from Memory

```bash
zilliz collection release --name <collection-name>
```

### Get Collection Statistics

```bash
zilliz collection get-stats --name <collection-name>
```

### Get Load State

```bash
zilliz collection get-load-state --name <collection-name>
```

### Flush a Collection

```bash
zilliz collection flush --name <collection-name>
```

### Compact a Collection

```bash
zilliz collection compact --name <collection-name>
```

### Collection Aliases

Create an alias:

```bash
zilliz alias create --collection <collection-name> --alias <alias-name>
```

List aliases:

```bash
zilliz alias list --database <db-name>
# Filter by collection:
zilliz alias list --database <db-name> --collection <collection-name>
```

Describe an alias:

```bash
zilliz alias describe --alias <alias-name>
```

Alter an alias (point to a different collection):

```bash
zilliz alias alter --collection <new-collection-name> --alias <alias-name>
```

Drop an alias:

```bash
zilliz alias drop --alias <alias-name>
```

## Guidance

- When the user wants to create a collection, ask about their use case to recommend appropriate dimension, metric type, and schema.
- Before dropping a collection, always confirm with the user — this deletes all data.
- A collection must be loaded before it can be searched or queried.
- After creating a collection, suggest loading it if the user plans to query immediately.
- Use `describe` to inspect schema before performing vector operations.
```

**Step 2: Commit**

```bash
git add skills/collection.md
git commit -m "feat: add collection and alias management skill"
```

---

### Task 6: Create skills/vector.md

**Files:**
- Create: `skills/vector.md`

**Step 1: Write skills/vector.md**

```markdown
---
name: vector
description: Use when the user wants to search, query, insert, upsert, get, or delete vectors in a Milvus collection.
---

## Prerequisites

1. CLI installed, logged in, and cluster context set (see setup skill).
2. Target collection must exist and be loaded (see collection skill).

## Commands Reference

### Vector Search

```bash
zilliz vector search \
  --collection <collection-name> \
  --data '[[0.1, 0.2, 0.3, ...]]' \
  --limit 10
# Optional:
#   --filter 'age > 20 and status == "active"'
#   --output-fields '["field1", "field2"]'
#   --anns-field <vector-field-name>  (if collection has multiple vector fields)
#   --database <db-name>
```

The `--data` parameter accepts a JSON array of vectors. Each vector is an array of floats.

### Hybrid Search

```bash
zilliz vector hybrid-search \
  --collection <collection-name> \
  --search '[
    {"data": [[0.1, 0.2, ...]], "annsField": "dense_vector", "limit": 10},
    {"data": [["search text"]], "annsField": "sparse_vector", "limit": 10}
  ]' \
  --rerank '{"strategy": "rrf", "params": {"k": 60}}' \
  --limit 10
# Optional:
#   --output-fields '["field1", "field2"]'
```

Or use `--body` for complex hybrid search configurations.

### Query (Filter-Based Retrieval)

```bash
zilliz vector query \
  --collection <collection-name> \
  --filter 'id in [1, 2, 3]' \
  --limit 10
# Optional:
#   --output-fields '["field1", "field2"]'
```

### Get by ID

```bash
zilliz vector get \
  --collection <collection-name> \
  --id '[1, 2, 3]'
# Optional:
#   --output-fields '["field1", "field2"]'
```

### Insert Vectors

```bash
zilliz vector insert \
  --collection <collection-name> \
  --data '[
    {"id": 1, "vector": [0.1, 0.2, ...], "text": "hello"},
    {"id": 2, "vector": [0.3, 0.4, ...], "text": "world"}
  ]'
```

For large datasets, consider reading data from a file:
```bash
zilliz vector insert --collection <name> --data "$(cat data.json)"
```

### Upsert Vectors

```bash
zilliz vector upsert \
  --collection <collection-name> \
  --data '[{"id": 1, "vector": [0.1, ...], "text": "updated"}]'
# Optional:
#   --partition <partition-name>
```

### Delete Vectors

```bash
zilliz vector delete \
  --collection <collection-name> \
  --filter 'id in [1, 2, 3]'
# Optional:
#   --partition <partition-name>
```

## Filter Expression Syntax

Common filter patterns:

| Expression | Example |
|---|---|
| Comparison | `age > 20` |
| Equality | `status == "active"` |
| IN list | `id in [1, 2, 3]` |
| AND/OR | `age > 20 and status == "active"` |
| String match | `text like "hello%"` |
| Array contains | `tags array_contains "ml"` |

## Guidance

- Before searching, inspect the collection schema with `zilliz collection describe` to understand field names and vector dimensions.
- The collection must be loaded before search/query operations.
- For search, the `--data` value must match the collection's vector dimension exactly.
- When the user provides a text query and wants semantic search, explain that they need to convert text to vectors first (using an embedding model) before passing to `--data`.
- For large insert operations, suggest writing data to a JSON file first, then reading it.
- Always show `--output-fields` when the user wants specific fields in results.
```

**Step 2: Commit**

```bash
git add skills/vector.md
git commit -m "feat: add vector operations skill"
```

---

### Task 7: Create skills/index.md

**Files:**
- Create: `skills/index.md`

**Step 1: Write skills/index.md**

```markdown
---
name: index
description: Use when the user wants to create, list, describe, or drop indexes on Milvus collections.
---

## Prerequisites

1. CLI installed, logged in, and cluster context set (see setup skill).
2. Target collection must exist (see collection skill).

## Commands Reference

### Create an Index

```bash
zilliz index create --collection <collection-name> --body '{
  "indexParams": [
    {
      "fieldName": "vector",
      "indexName": "vector_index",
      "metricType": "COSINE",
      "indexType": "AUTOINDEX"
    }
  ]
}'
```

Common index types:
- `AUTOINDEX` — recommended, automatically selects the best index
- `IVF_FLAT`, `IVF_SQ8`, `HNSW` — manual selection for advanced users

Common metric types:
- `COSINE` — cosine similarity (default)
- `L2` — Euclidean distance
- `IP` — inner product

### List Indexes

```bash
zilliz index list --collection <collection-name>
```

### Describe an Index

```bash
zilliz index describe --collection <collection-name> --index-name <index-name>
```

### Drop an Index

```bash
zilliz index drop --collection <collection-name> --index-name <index-name>
```

## Guidance

- On Zilliz Cloud, `AUTOINDEX` is recommended for most use cases.
- An index is required before loading a collection for search.
- Before creating an index, check the collection schema to identify vector fields.
- After creating an index, remind the user to load the collection.
```

**Step 2: Commit**

```bash
git add skills/index.md
git commit -m "feat: add index management skill"
```

---

### Task 8: Create skills/database.md

**Files:**
- Create: `skills/database.md`

**Step 1: Write skills/database.md**

```markdown
---
name: database
description: Use when the user wants to create, list, describe, or drop databases in Milvus.
---

## Prerequisites

1. CLI installed, logged in, and cluster context set (see setup skill).

## Commands Reference

### List Databases

```bash
zilliz database list
```

### Create a Database

```bash
zilliz database create --name <db-name>
# Advanced with properties:
zilliz database create --name <db-name> --body '{"properties": {}}'
```

### Describe a Database

```bash
zilliz database describe --name <db-name>
```

### Drop a Database

```bash
zilliz database drop --name <db-name>
```

## Guidance

- Every cluster has a "default" database.
- Before dropping a database, confirm with the user — all collections in it will be deleted.
- After creating a database, suggest switching context: `zilliz context set --database <db-name>`.
- To work with collections in a non-default database, use `--database` flag on collection commands or switch context.
```

**Step 2: Commit**

```bash
git add skills/database.md
git commit -m "feat: add database management skill"
```

---

### Task 9: Create skills/user-role.md

**Files:**
- Create: `skills/user-role.md`

**Step 1: Write skills/user-role.md**

```markdown
---
name: user-role
description: Use when the user wants to manage database users, roles, passwords, or access privileges in Milvus.
---

## Prerequisites

1. CLI installed, logged in, and cluster context set (see setup skill).

## Commands Reference

### Users

List users:

```bash
zilliz user list
```

Create a user:

```bash
zilliz user create --name <username> --password <password>
```

Describe a user (shows assigned roles):

```bash
zilliz user describe --name <username>
```

Update password:

```bash
zilliz user update-password --name <username> --password <old-password> --new-password <new-password>
```

Grant a role to a user:

```bash
zilliz user grant-role --name <username> --role <role-name>
```

Revoke a role from a user:

```bash
zilliz user revoke-role --name <username> --role <role-name>
```

Drop a user:

```bash
zilliz user drop --name <username>
```

### Roles

List roles:

```bash
zilliz role list
```

Create a role:

```bash
zilliz role create --name <role-name>
```

Describe a role (shows granted privileges):

```bash
zilliz role describe --name <role-name>
```

Grant a privilege:

```bash
zilliz role grant-privilege \
  --name <role-name> \
  --object-type <Collection|Global|Database> \
  --object-name <name-or-*> \
  --privilege <privilege-name>
# Optional: --database <db-name>
```

Common privileges:
- Collection: `Search`, `Query`, `Insert`, `Delete`, `CreateIndex`, `DropCollection`
- Global: `CreateCollection`, `All`
- Database: `ListCollections`

Revoke a privilege:

```bash
zilliz role revoke-privilege \
  --name <role-name> \
  --object-type <Collection|Global|Database> \
  --object-name <name-or-*> \
  --privilege <privilege-name>
```

Drop a role:

```bash
zilliz role drop --name <role-name>
```

## Guidance

- Built-in roles: `admin` (full access), `public` (read-only).
- When setting up RBAC, suggest a workflow: create role, grant privileges, create user, assign role.
- Before dropping a user or role, confirm with the user.
- Use `*` as object-name to grant privilege on all objects of that type.
```

**Step 2: Commit**

```bash
git add skills/user-role.md
git commit -m "feat: add user and role management skill"
```

---

### Task 10: Create skills/backup.md

**Files:**
- Create: `skills/backup.md`

**Step 1: Write skills/backup.md**

```markdown
---
name: backup
description: Use when the user wants to create, list, describe, delete, export, or restore backups, or manage backup policies on Zilliz Cloud.
---

## Prerequisites

1. CLI installed and logged in (see setup skill).
2. No cluster context required — backup operations use `--cluster-id` directly.

## Commands Reference

### Create a Backup

```bash
zilliz backup create --cluster-id <cluster-id> --backup-type <full|incremental>
# Advanced with body:
zilliz backup create --cluster-id <cluster-id> --backup-type full --body '{"collections": ["col1"]}'
```

### List Backups

```bash
zilliz backup list
# Filter:
zilliz backup list --cluster-id <cluster-id>
zilliz backup list --project-id <project-id>
zilliz backup list --backup-type full
zilliz backup list --creation-method manual
```

### Describe a Backup

```bash
zilliz backup describe --cluster-id <cluster-id> --backup-id <backup-id>
```

### Delete a Backup

```bash
zilliz backup delete --cluster-id <cluster-id> --backup-id <backup-id>
```

### Export a Backup

```bash
zilliz backup export \
  --cluster-id <cluster-id> \
  --backup-id <backup-id> \
  --integration-id <integration-id> \
  --directory <path>
```

### Restore to a New Cluster

```bash
zilliz backup restore-cluster \
  --cluster-id <source-cluster-id> \
  --backup-id <backup-id> \
  --project-id <project-id> \
  --name <new-cluster-name> \
  --cu-size <size> \
  --collection-status <loaded|unloaded>
```

### Restore Specific Collections

```bash
zilliz backup restore-collection \
  --cluster-id <source-cluster-id> \
  --backup-id <backup-id> \
  --dest-cluster-id <destination-cluster-id> \
  --body '{"collections": [{"source": "col1", "target": "col1_restored"}]}'
```

### Backup Policy

Get current policy:

```bash
zilliz backup get-policy --cluster-id <cluster-id>
```

Set backup policy:

```bash
zilliz backup set-policy \
  --cluster-id <cluster-id> \
  --enabled true \
  --frequency daily \
  --start-time "02:00" \
  --retention-days 7
```

## Guidance

- Before deleting a backup, confirm with the user — this is irreversible.
- When restoring, explain the difference between cluster restore (new cluster) and collection restore (into existing cluster).
- Suggest setting up a backup policy for production clusters.
```

**Step 2: Commit**

```bash
git add skills/backup.md
git commit -m "feat: add backup management skill"
```

---

### Task 11: Create skills/import.md

**Files:**
- Create: `skills/import.md`

**Step 1: Write skills/import.md**

```markdown
---
name: import
description: Use when the user wants to import bulk data into a Milvus collection via Zilliz Cloud import jobs.
---

## Prerequisites

1. CLI installed and logged in (see setup skill).
2. Target collection must exist on the target cluster.

## Commands Reference

### Create an Import Job

```bash
zilliz import-job create \
  --cluster-id <cluster-id> \
  --collection <collection-name> \
  --body '{
    "files": [["s3://bucket/path/to/file.parquet"]],
    "options": {}
  }'
```

Supported file formats: Parquet, JSON, CSV.

### List Import Jobs

```bash
zilliz import-job list --cluster-id <cluster-id>
# Filter by database:
zilliz import-job list --cluster-id <cluster-id> --database <db-name>
# Pagination:
zilliz import-job list --cluster-id <cluster-id> --page-size 10 --page 1
```

### Check Import Progress

```bash
zilliz import-job get-progress --cluster-id <cluster-id> --job-id <job-id>
```

## Guidance

- Import jobs run asynchronously. After creating a job, use `get-progress` to track status.
- The data files must be accessible from Zilliz Cloud (e.g., S3, GCS with proper integration configured).
- The collection schema must match the data file structure.
```

**Step 2: Commit**

```bash
git add skills/import.md
git commit -m "feat: add data import skill"
```

---

### Task 12: Create skills/monitoring.md

**Files:**
- Create: `skills/monitoring.md`

**Step 1: Write skills/monitoring.md**

```markdown
---
name: monitoring
description: Use when the user wants to check cluster status, collection statistics, load states, or get an overview of their Zilliz Cloud resources.
---

## Prerequisites

1. CLI installed and logged in (see setup skill).
2. Cluster context set for collection-level monitoring (see setup skill).

## Commands Reference

### Cluster Status

```bash
# Current context
zilliz context current

# Cluster details (status, plan, region, endpoints)
zilliz cluster describe --cluster-id <cluster-id>
```

### Collection Overview

List all collections with their stats:

```bash
# List collections
zilliz collection list

# For each collection, get stats and load state:
zilliz collection get-stats --name <collection-name>
zilliz collection get-load-state --name <collection-name>
```

### Database Overview

```bash
zilliz database list
```

### All Clusters

```bash
zilliz cluster list --all
```

## Presenting Results

When the user asks for a status overview, collect and present information as a summary table:

**Cluster Info:**
- Cluster ID, name, status (RUNNING/SUSPENDED/etc.)
- Plan type, region, create time

**Collections Summary:**
Present as a table with columns:
| Collection | Rows | Load State |
|---|---|---|

Gather this by running `collection list`, then `get-stats` and `get-load-state` for each collection.

## Guidance

- When presenting status, use `--output json` to get machine-readable data, then format it into a readable summary for the user.
- If the cluster is suspended, note this prominently and inform the user that data-plane operations are unavailable.
- For multiple clusters, show a summary table of all clusters first, then drill into the selected one.
```

**Step 2: Commit**

```bash
git add skills/monitoring.md
git commit -m "feat: add monitoring skill"
```

---

### Task 13: Create skills/project-region.md

**Files:**
- Create: `skills/project-region.md`

**Step 1: Write skills/project-region.md**

```markdown
---
name: project-region
description: Use when the user wants to manage Zilliz Cloud projects, query available cloud regions and providers, or manage storage volumes.
---

## Prerequisites

1. CLI installed and logged in (see setup skill).

## Commands Reference

### Projects

List projects:

```bash
zilliz project list
```

Describe a project:

```bash
zilliz project describe --project-id <project-id>
```

Create a project:

```bash
zilliz project create --name <project-name> --plan <plan-type>
```

Upgrade a project:

```bash
zilliz project upgrade --project-id <project-id> --plan <new-plan>
```

### Regions and Cloud Providers

List cloud providers:

```bash
zilliz region list-providers
```

List available regions:

```bash
zilliz region list
# Filter by cloud provider:
zilliz region list --cloud-id <cloud-id>
```

### Volumes

Create a volume:

```bash
zilliz volume create --project-id <project-id> --region <region-id> --name <volume-name>
```

List volumes:

```bash
zilliz volume list --project-id <project-id>
```

Delete a volume:

```bash
zilliz volume delete --name <volume-name>
```

## Guidance

- When the user wants to create a cluster, they need a project ID and region ID first. Guide them through listing projects and regions.
- Before deleting a volume, confirm with the user.
- Use `region list-providers` and `region list` to help users choose where to deploy.
```

**Step 2: Commit**

```bash
git add skills/project-region.md
git commit -m "feat: add project, region, and volume management skill"
```

---

### Task 14: Create skills/partition.md

**Files:**
- Create: `skills/partition.md`

**Step 1: Write skills/partition.md**

```markdown
---
name: partition
description: Use when the user wants to create, list, load, release, or drop partitions in a Milvus collection.
---

## Prerequisites

1. CLI installed, logged in, and cluster context set (see setup skill).
2. Target collection must exist (see collection skill).

## Commands Reference

### List Partitions

```bash
zilliz partition list --collection <collection-name>
```

### Create a Partition

```bash
zilliz partition create --collection <collection-name> --name <partition-name>
```

### Check if Partition Exists

```bash
zilliz partition has --collection <collection-name> --name <partition-name>
```

### Get Partition Statistics

```bash
zilliz partition get-stats --collection <collection-name> --name <partition-name>
```

### Load Partitions

```bash
zilliz partition load --collection <collection-name> --names '["partition1", "partition2"]'
```

### Release Partitions

```bash
zilliz partition release --collection <collection-name> --names '["partition1", "partition2"]'
```

### Drop a Partition

```bash
zilliz partition drop --collection <collection-name> --name <partition-name>
```

## Guidance

- Every collection has a default `_default` partition.
- Partitions allow organizing data for more targeted searches.
- A partition must be loaded before it can be searched.
- Before dropping a partition, confirm with the user — all data in it will be deleted.
- Use partition stats to check row counts per partition.
```

**Step 2: Commit**

```bash
git add skills/partition.md
git commit -m "feat: add partition management skill"
```

---

### Task 15: Create commands/quickstart.md

**Files:**
- Modify: `commands/quickstart.md` (replace content)

**Step 1: Write commands/quickstart.md**

```markdown
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
```

**Step 2: Commit**

```bash
git add commands/quickstart.md
git commit -m "feat: add quickstart slash command"
```

---

### Task 16: Create commands/status.md

**Files:**
- Create: `commands/status.md`

**Step 1: Write commands/status.md**

```markdown
---
name: status
description: Show a comprehensive overview of the current Zilliz Cloud cluster — context, cluster details, databases, and collections with stats.
---

Gather and display a status overview of the user's current Zilliz Cloud environment. Run commands with `--output json` for structured data, then present a formatted summary.

## Step 1: Check Prerequisites

Verify CLI is installed and user is logged in:

```bash
zilliz auth status
```

If not set up, suggest running `/quickstart` first.

## Step 2: Show Current Context

```bash
zilliz context current --output json
```

If no context is set, suggest running `zilliz context set --cluster-id <id>`.

## Step 3: Cluster Details

Using the cluster ID from context:

```bash
zilliz cluster describe --cluster-id <cluster-id> --output json
```

Present: cluster name, status, plan, region.

## Step 4: Database List

```bash
zilliz database list --output json
```

## Step 5: Collections Summary

```bash
zilliz collection list --output json
```

For each collection, gather stats:

```bash
zilliz collection get-stats --name <name> --output json
zilliz collection get-load-state --name <name> --output json
```

## Step 6: Present Summary

Format the results as a readable summary:

**Cluster:** <name> (<cluster-id>)
**Status:** RUNNING | **Region:** <region> | **Plan:** <plan>
**Database:** <current-db>

**Collections:**

| Collection | Rows | Load State |
|---|---|---|
| my_collection | 10,000 | Loaded |
| ... | ... | ... |

If the cluster is suspended, show a warning that data operations are unavailable.
```

**Step 2: Commit**

```bash
git add commands/status.md
git commit -m "feat: add status slash command"
```

---

### Task 17: Create README.md and update .gitignore

**Files:**
- Modify: `README.md`
- Modify: `.gitignore`

**Step 1: Write README.md**

```markdown
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
```

**Step 2: Write .gitignore**

```
# Python
__pycache__/
*.py[cod]
*.egg-info/
dist/
build/
.venv/

# IDE
.idea/
.vscode/
*.swp

# OS
.DS_Store
Thumbs.db

# Claude
.claude/
```

**Step 3: Commit**

```bash
git add README.md .gitignore
git commit -m "docs: add README and update gitignore"
```

---

### Task 18: Final review and commit

**Step 1: Verify file structure**

```bash
find /Users/lawrance/Desktop/workspace/zilliz-plugin -type f -not -path '*/.git/*' | sort
```

Expected:
```
.claude-plugin/plugin.json
.gitignore
README.md
commands/quickstart.md
commands/status.md
docs/plans/2026-03-02-plugin-implementation.md
docs/plans/2026-03-02-plugin-redesign.md
skills/backup.md
skills/cluster.md
skills/collection.md
skills/database.md
skills/import.md
skills/index.md
skills/monitoring.md
skills/partition.md
skills/project-region.md
skills/setup.md
skills/user-role.md
skills/vector.md
```

**Step 2: Verify no old files remain**

Ensure none of these exist: `src/`, `tests/`, `pyproject.toml`, `.mcp.json`, `CONTRIBUTING.md`, `LICENSE`, `.github/`, `.claude-plugin/marketplace.json`.

**Step 3: Verify all skills are referenced**

Check that every skill file in `skills/` has proper frontmatter with `name` and `description` fields.

**Step 4: Final commit if any uncommitted changes**

```bash
git status
# If changes exist:
git add -A
git commit -m "chore: finalize plugin redesign"
```
