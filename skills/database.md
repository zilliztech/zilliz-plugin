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
