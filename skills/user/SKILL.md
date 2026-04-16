---
name: user
description: Use when the user wants to create, list, describe, drop, update
  password, grant role, or revoke role user resources.
---
# user

_Section: Data Operations_ — Create and manage database users. (Dedicated only)

## Prerequisites

- `zilliz` CLI installed (see `/zilliz:setup`).
- Authenticated (`zilliz login`) and context set (`zilliz context set`).

## Commands Reference

### Create — Create a new database user.

```bash
zilliz user create --user <user> --password <password>
#   [--api-key <api-key>]
```

**Flags:**
- `--user` (**required**, `string`) — username
- `--password` (**required**, `string`) — password
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### List — List all database users.

```bash
zilliz user list
#   [--api-key <api-key>]
```

**Flags:**
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### Describe — Get details of a user.

```bash
zilliz user describe --user <user>
#   [--api-key <api-key>]
```

**Flags:**
- `--user` (**required**, `string`) — username
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### Drop — Drop a database user.

```bash
zilliz user drop --user <user>
#   [--api-key <api-key>]
```

**Flags:**
- `--user` (**required**, `string`) — username to drop
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### Update Password — Update user password.

```bash
zilliz user update-password --user <user> --password <password> --new-password <new-password>
#   [--api-key <api-key>]
```

**Flags:**
- `--user` (**required**, `string`) — username
- `--password` (**required**, `string`) — current password
- `--new-password` (**required**, `string`) — new password
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### Grant Role — Grant a role to a user.

```bash
zilliz user grant-role --user <user> --role <role>
#   [--api-key <api-key>]
```

**Flags:**
- `--user` (**required**, `string`) — username
- `--role` (**required**, `string`) — role name to grant
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### Revoke Role — Revoke a role from a user.

```bash
zilliz user revoke-role --user <user> --role <role>
#   [--api-key <api-key>]
```

**Flags:**
- `--user` (**required**, `string`) — username
- `--role` (**required**, `string`) — role name to revoke
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

## Live help

```bash
zilliz user --help
```

Destructive operations (`delete`, `drop`, `restore`) require explicit user confirmation before execution.
