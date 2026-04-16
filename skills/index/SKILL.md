---
name: index
description: Use when the user wants to create, list, describe, or drop index resources.
---
# index

_Section: Data Operations_ — Create and manage vector indexes.

## Prerequisites

- `zilliz` CLI installed (see `/zilliz:setup`).
- Authenticated (`zilliz login`) and context set (`zilliz context set`).

## Commands Reference

### Create — Create an index on a collection field.

```bash
zilliz index create --collection <collection>
#   [--database <database>]
#   [--api-key <api-key>]
```

**Flags:**
- `--collection` (**required**, `string`) — collection name
- `--database` (`string`) — database name
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### List — List indexes on a collection.

```bash
zilliz index list --collection <collection>
#   [--database <database>]
#   [--api-key <api-key>]
```

**Flags:**
- `--collection` (**required**, `string`) — collection name
- `--database` (`string`) — database name
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### Describe — Get details of an index.

```bash
zilliz index describe --collection <collection> --index-name <index-name>
#   [--database <database>]
#   [--api-key <api-key>]
```

**Flags:**
- `--collection` (**required**, `string`) — collection name
- `--index-name` (**required**, `string`) — index name
- `--database` (`string`) — database name
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### Drop — Drop an index.

```bash
zilliz index drop --collection <collection> --index-name <index-name>
#   [--database <database>]
#   [--api-key <api-key>]
```

**Flags:**
- `--collection` (**required**, `string`) — collection name
- `--index-name` (**required**, `string`) — index name to drop
- `--database` (`string`) — database name
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

## Live help

```bash
zilliz index --help
```

Destructive operations (`delete`, `drop`, `restore`) require explicit user confirmation before execution.
