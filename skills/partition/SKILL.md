---
name: partition
description: Use when the user wants to create, list, drop, has, get stats,
  load, or release partition resources.
---
# partition

_Section: Data Operations_ — Create and manage collection partitions.

## Prerequisites

- `zilliz` CLI installed (see `/zilliz:setup`).
- Authenticated (`zilliz login`) and context set (`zilliz context set`).

## Commands Reference

### Create — Create a partition in a collection.

```bash
zilliz partition create --collection <collection> --partition <partition>
#   [--database <database>]
#   [--api-key <api-key>]
```

**Flags:**
- `--collection` (**required**, `string`) — collection name
- `--partition` (**required**, `string`) — partition name
- `--database` (`string`) — database name
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### List — List partitions in a collection.

```bash
zilliz partition list --collection <collection>
#   [--database <database>]
#   [--api-key <api-key>]
```

**Flags:**
- `--collection` (**required**, `string`) — collection name
- `--database` (`string`) — database name
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### Drop — Drop a partition.

```bash
zilliz partition drop --collection <collection> --partition <partition>
#   [--database <database>]
#   [--api-key <api-key>]
```

**Flags:**
- `--collection` (**required**, `string`) — collection name
- `--partition` (**required**, `string`) — partition name to drop
- `--database` (`string`) — database name
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### Has — Check if a partition exists.

```bash
zilliz partition has --collection <collection> --partition <partition>
#   [--database <database>]
#   [--api-key <api-key>]
```

**Flags:**
- `--collection` (**required**, `string`) — collection name
- `--partition` (**required**, `string`) — partition name
- `--database` (`string`) — database name
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### Get Stats — Get partition statistics.

```bash
zilliz partition get-stats --collection <collection> --partition <partition>
#   [--database <database>]
#   [--api-key <api-key>]
```

**Flags:**
- `--collection` (**required**, `string`) — collection name
- `--partition` (**required**, `string`) — partition name
- `--database` (`string`) — database name
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### Load — Load partitions into memory.

```bash
zilliz partition load --collection <collection> --names <names-json-array>
#   [--database <database>]
#   [--api-key <api-key>]
```

**Flags:**
- `--collection` (**required**, `string`) — collection name
- `--names` (**required**, `array`) — partition names as JSON array
- `--database` (`string`) — database name
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### Release — Release partitions from memory.

```bash
zilliz partition release --collection <collection> --names <names-json-array>
#   [--database <database>]
#   [--api-key <api-key>]
```

**Flags:**
- `--collection` (**required**, `string`) — collection name
- `--names` (**required**, `array`) — partition names as JSON array
- `--database` (`string`) — database name
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

## Live help

```bash
zilliz partition --help
```

Destructive operations (`delete`, `drop`, `restore`) require explicit user confirmation before execution.
