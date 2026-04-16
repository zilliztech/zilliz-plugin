---
name: alias
description: Use when the user wants to create, list, describe, alter, or drop
  alias resources.
---
# alias

_Section: Data Operations_ — Create and manage collection aliases.

## Prerequisites

- `zilliz` CLI installed (see `/zilliz:setup`).
- Authenticated (`zilliz login`) and context set (`zilliz context set`).

## Commands Reference

### Create — Create an alias pointing to a collection.

```bash
zilliz alias create --collection <collection> --alias <alias>
#   [--database <database>]
#   [--api-key <api-key>]
```

**Flags:**
- `--collection` (**required**, `string`) — target collection name
- `--alias` (**required**, `string`) — alias name
- `--database` (`string`) — database name
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### List — List all aliases.

```bash
zilliz alias list --database <database>
#   [--collection <collection>]
#   [--api-key <api-key>]
```

**Flags:**
- `--database` (**required**, `string`) — database name
- `--collection` (`string`) — filter by collection name
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### Describe — Get details of an alias.

```bash
zilliz alias describe --alias <alias>
#   [--database <database>]
#   [--api-key <api-key>]
```

**Flags:**
- `--alias` (**required**, `string`) — alias name
- `--database` (`string`) — database name
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### Alter — Reassign an alias to another collection.

```bash
zilliz alias alter --collection <collection> --alias <alias>
#   [--database <database>]
#   [--api-key <api-key>]
```

**Flags:**
- `--collection` (**required**, `string`) — new target collection
- `--alias` (**required**, `string`) — alias name to reassign
- `--database` (`string`) — database name
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### Drop — Drop an alias.

```bash
zilliz alias drop --alias <alias>
#   [--database <database>]
#   [--api-key <api-key>]
```

**Flags:**
- `--alias` (**required**, `string`) — alias name to drop
- `--database` (`string`) — database name
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

## Live help

```bash
zilliz alias --help
```

Destructive operations (`delete`, `drop`, `restore`) require explicit user confirmation before execution.
