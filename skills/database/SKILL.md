---
name: database
description: Use when the user wants to create, list, describe, or drop database resources.
---
# database

_Section: Data Operations_ — Create and manage databases.

## Prerequisites

- `zilliz` CLI installed (see `/zilliz:setup`).
- Authenticated (`zilliz login`) and context set (`zilliz context set`).

## Commands Reference

### Create — Create a new database. (Dedicated only)

```bash
zilliz database create --name <name>
#   [--api-key <api-key>]
```

**Flags:**
- `--name` (**required**, `string`) — database name
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### List — List all databases.

```bash
zilliz database list
#   [--api-key <api-key>]
```

**Flags:**
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### Describe — Get details of a database. (Dedicated only)

```bash
zilliz database describe --name <name>
#   [--api-key <api-key>]
```

**Flags:**
- `--name` (**required**, `string`) — database name
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### Drop — Drop a database. (Dedicated only)

```bash
zilliz database drop --name <name>
#   [--api-key <api-key>]
```

**Flags:**
- `--name` (**required**, `string`) — database name to drop
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

## Live help

```bash
zilliz database --help
```

Destructive operations (`delete`, `drop`, `restore`) require explicit user confirmation before execution.
