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
zilliz user create --user <username> --password <password>
```

Describe a user (shows assigned roles):

```bash
zilliz user describe --user <username>
```

Update password:

```bash
zilliz user update-password --user <username> --password <old-password> --new-password <new-password>
```

Grant a role to a user:

```bash
zilliz user grant-role --user <username> --role <role-name>
```

Revoke a role from a user:

```bash
zilliz user revoke-role --user <username> --role <role-name>
```

Drop a user:

```bash
zilliz user drop --user <username>
```

### Roles

List roles:

```bash
zilliz role list
```

Create a role:

```bash
zilliz role create --role <role-name>
```

Describe a role (shows granted privileges):

```bash
zilliz role describe --role <role-name>
```

Grant a privilege:

```bash
zilliz role grant-privilege \
  --role <role-name> \
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
  --role <role-name> \
  --object-type <Collection|Global|Database> \
  --object-name <name-or-*> \
  --privilege <privilege-name>
```

Drop a role:

```bash
zilliz role drop --role <role-name>
```

## Guidance

- User and role management is only available on **Dedicated** clusters.
- Built-in roles: `admin` (full access), `public` (no privileges by default — must be granted explicitly).
- When setting up RBAC, suggest a workflow: create role, grant privileges, create user, assign role.
- Before dropping a user or role, confirm with the user.
- Use `*` as object-name to grant privilege on all objects of that type.
