---
name: collection
description: Use when the user wants to metrics, create, list, describe, drop,
  rename, load, release, get load state, get stats, has, flush, or compact
  collection resources.
---
# collection

_Section: Data Operations_ — Create and manage vector collections.

## Prerequisites

- `zilliz` CLI installed (see `/zilliz:setup`).
- Authenticated (`zilliz login`) and context set (`zilliz context set`).

## Commands Reference

### Metrics — Show collection metrics.

```bash
zilliz collection metrics
#   [--cluster-id <cluster-id>]
```

**Flags:**
- `--cluster-id` (`string`) — Cluster ID (overrides context if provided)

### Create — Create a new collection.

```bash
zilliz collection create --name <name>
#   [--dimension <dimension>]
#   [--metric-type <metric-type>  # default: "COSINE"]
#   [--id-type <id-type>]
#   [--auto-id <auto-id>]
#   [--primary-field <primary-field>]
#   [--vector-field <vector-field>]
#   [--database <database>]
#   [--api-key <api-key>]
```

**Flags:**
- `--name` (**required**, `string`) — collection name
- `--dimension` (`integer`) — vector dimension
- `--metric-type` (`string`, default `"COSINE"`) — [COSINE, L2, IP]distance metric
- `--id-type` (`string`) — [Int64, VarChar]     primary key type
- `--auto-id` (`boolean`) — auto-generate primary key
- `--primary-field` (`string`) — primary key field name
- `--vector-field` (`string`) — vector field name
- `--database` (`string`) — database name
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### List — List all collections.

```bash
zilliz collection list
#   [--database <database>]
#   [--api-key <api-key>]
```

**Flags:**
- `--database` (`string`) — database name
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### Describe — Get details of a collection.

```bash
zilliz collection describe --name <name>
#   [--database <database>]
#   [--api-key <api-key>]
```

**Flags:**
- `--name` (**required**, `string`) — collection name
- `--database` (`string`) — database name
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### Drop — Drop a collection. This action is irreversible.

```bash
zilliz collection drop --name <name>
#   [--database <database>]
#   [--api-key <api-key>]
```

**Flags:**
- `--name` (**required**, `string`) — collection name to drop
- `--database` (`string`) — database name
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### Rename — Rename a collection.

```bash
zilliz collection rename --name <name> --new-name <new-name>
#   [--database <database>]
#   [--new-database <new-database>]
#   [--api-key <api-key>]
```

**Flags:**
- `--name` (**required**, `string`) — current collection name
- `--new-name` (**required**, `string`) — new collection name
- `--database` (`string`) — current database name
- `--new-database` (`string`) — target database name (for cross-db rename)
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### Load — Load a collection into memory for search.

```bash
zilliz collection load --name <name>
#   [--database <database>]
#   [--api-key <api-key>]
```

**Flags:**
- `--name` (**required**, `string`) — collection name
- `--database` (`string`) — database name
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### Release — Release a collection from memory.

```bash
zilliz collection release --name <name>
#   [--database <database>]
#   [--api-key <api-key>]
```

**Flags:**
- `--name` (**required**, `string`) — collection name
- `--database` (`string`) — database name
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### Get Load State — Get collection load state.

```bash
zilliz collection get-load-state --name <name>
#   [--database <database>]
#   [--api-key <api-key>]
```

**Flags:**
- `--name` (**required**, `string`) — collection name
- `--database` (`string`) — database name
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### Get Stats — Get collection statistics (row count, etc.).

```bash
zilliz collection get-stats --name <name>
#   [--database <database>]
#   [--api-key <api-key>]
```

**Flags:**
- `--name` (**required**, `string`) — collection name
- `--database` (`string`) — database name
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### Has — Check if a collection exists.

```bash
zilliz collection has --name <name>
#   [--database <database>]
#   [--api-key <api-key>]
```

**Flags:**
- `--name` (**required**, `string`) — collection name
- `--database` (`string`) — database name
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### Flush — Flush collection data to disk.

```bash
zilliz collection flush --name <name>
#   [--database <database>]
#   [--api-key <api-key>]
```

**Flags:**
- `--name` (**required**, `string`) — collection name
- `--database` (`string`) — database name
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### Compact — Compact collection segments to optimize storage.

```bash
zilliz collection compact --name <name>
#   [--database <database>]
#   [--api-key <api-key>]
```

**Flags:**
- `--name` (**required**, `string`) — collection name
- `--database` (`string`) — database name
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

## Live help

```bash
zilliz collection --help
```

Destructive operations (`delete`, `drop`, `restore`) require explicit user confirmation before execution.
