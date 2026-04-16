---
name: role
description: Use when the user wants to create, list, describe, drop, grant
  privilege, or revoke privilege role resources.
---
# role

_Section: Data Operations_ — Create and manage access control roles. (Dedicated only)

## Prerequisites

- `zilliz` CLI installed (see `/zilliz:setup`).
- Authenticated (`zilliz login`) and context set (`zilliz context set`).

## Commands Reference

### Create — Create a new role.

```bash
zilliz role create --role <role>
#   [--api-key <api-key>]
```

**Flags:**
- `--role` (**required**, `string`) — role name
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### List — List all roles.

```bash
zilliz role list
#   [--api-key <api-key>]
```

**Flags:**
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### Describe — Get details and privileges of a role.

```bash
zilliz role describe --role <role>
#   [--api-key <api-key>]
```

**Flags:**
- `--role` (**required**, `string`) — role name
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### Drop — Drop a role.

```bash
zilliz role drop --role <role>
#   [--api-key <api-key>]
```

**Flags:**
- `--role` (**required**, `string`) — role name to drop
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### Grant Privilege — Grant a privilege to a role.

```bash
zilliz role grant-privilege --role <role> --object-type <object-type> --object-name <object-name> --privilege <privilege>
#   [--database <database>]
#   [--api-key <api-key>]
```

**Flags:**
- `--role` (**required**, `string`) — role name
- `--object-type` (**required**, `string`) — [Global, Collection, Database]object type
- `--object-name` (**required**, `string`) — object name (or * for all)
- `--privilege` (**required**, `string`) — privilege name (e.g. Search, Insert, CreateCollection)
- `--database` (`string`) — database name
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### Revoke Privilege — Revoke a privilege from a role.

```bash
zilliz role revoke-privilege --role <role> --object-type <object-type> --object-name <object-name> --privilege <privilege>
#   [--database <database>]
#   [--api-key <api-key>]
```

**Flags:**
- `--role` (**required**, `string`) — role name
- `--object-type` (**required**, `string`) — [Global, Collection, Database]object type
- `--object-name` (**required**, `string`) — object name (or * for all)
- `--privilege` (**required**, `string`) — privilege name
- `--database` (`string`) — database name
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

## Live help

```bash
zilliz role --help
```

Destructive operations (`delete`, `drop`, `restore`) require explicit user confirmation before execution.
