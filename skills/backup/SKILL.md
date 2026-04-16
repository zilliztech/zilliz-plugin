---
name: backup
description: Use when the user wants to create, list, describe, delete, export,
  restore cluster, restore collection, describe policy, or update policy backup
  resources.
---
# backup

_Section: Cloud Management_ — Create, restore, and manage backups.

## Prerequisites

- `zilliz` CLI installed (see `/zilliz:setup`).
- Authenticated (`zilliz login`) and context set (`zilliz context set`).

## Commands Reference

### Create — Create a backup for a cluster.

```bash
zilliz backup create --cluster-id <cluster-id>
#   [--database <database>]
#   [--collection <collection>]
#   [--backup-type <backup-type>]
#   [--api-key <api-key>]
```

**Flags:**
- `--cluster-id` (**required**, `string`) — cluster ID
- `--database` (`string`) — database name (for collection-level backup)
- `--collection` (`string`) — collection name (omit for full cluster backup)
- `--backup-type` (`string`) — [CLUSTER, COLLECTION]backup type (default: CLUSTER, auto-set to COLLECTION when --collection is given)
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### List — List all backups.

```bash
zilliz backup list
#   [--project-id <project-id>]
#   [--cluster-id <cluster-id>]
#   [--creation-method <creation-method>]
#   [--backup-type <backup-type>]
#   [--page-size <page-size>]
#   [--page <page>]
#   [--api-key <api-key>]
```

**Flags:**
- `--project-id` (`string`) — filter by project ID
- `--cluster-id` (`string`) — filter by cluster ID
- `--creation-method` (`string`) — [MANUAL, AUTO]       filter by creation method
- `--backup-type` (`string`) — [CLUSTER, COLLECTION]filter by backup type
- `--page-size` (`integer`) — items per page
- `--page` (`integer`) — page number
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### Describe — Get details of a backup.

```bash
zilliz backup describe --cluster-id <cluster-id> --backup-id <backup-id>
#   [--api-key <api-key>]
```

**Flags:**
- `--cluster-id` (**required**, `string`) — cluster ID
- `--backup-id` (**required**, `string`) — backup ID
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### Delete — Delete a backup.

```bash
zilliz backup delete --cluster-id <cluster-id> --backup-id <backup-id>
#   [--api-key <api-key>]
```

**Flags:**
- `--cluster-id` (**required**, `string`) — cluster ID
- `--backup-id` (**required**, `string`) — backup ID to delete
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### Export — Export a backup to external storage.

```bash
zilliz backup export --cluster-id <cluster-id> --backup-id <backup-id> --integration-id <integration-id>
#   [--directory <directory>]
#   [--api-key <api-key>]
```

**Flags:**
- `--cluster-id` (**required**, `string`) — cluster ID
- `--backup-id` (**required**, `string`) — backup ID
- `--integration-id` (**required**, `string`) — storage integration ID
- `--directory` (`string`) — target directory in external storage
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### Restore Cluster — Restore a backup to a new cluster.

```bash
zilliz backup restore-cluster --cluster-id <cluster-id> --backup-id <backup-id> --project-id <project-id> --name <name> --cu-size <cu-size> --collection-status <collection-status>
#   [--api-key <api-key>]
```

**Flags:**
- `--cluster-id` (**required**, `string`) — source cluster ID
- `--backup-id` (**required**, `string`) — backup ID to restore
- `--project-id` (**required**, `string`) — target project ID
- `--name` (**required**, `string`) — new cluster name
- `--cu-size` (**required**, `integer`) — compute units for new cluster
- `--collection-status` (**required**, `string`) — [LOADED, NOT_LOADED]collection state after restore
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### Restore Collection — Restore specific collections from a backup.

```bash
zilliz backup restore-collection --cluster-id <cluster-id> --backup-id <backup-id> --dest-cluster-id <dest-cluster-id>
#   [--api-key <api-key>]
```

**Flags:**
- `--cluster-id` (**required**, `string`) — source cluster ID
- `--backup-id` (**required**, `string`) — backup ID
- `--dest-cluster-id` (**required**, `string`) — destination cluster ID
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### Describe Policy — Describe backup policy for a cluster.

```bash
zilliz backup describe-policy --cluster-id <cluster-id>
#   [--api-key <api-key>]
```

**Flags:**
- `--cluster-id` (**required**, `string`) — cluster ID
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### Update Policy — Update backup policy for a cluster.

```bash
zilliz backup update-policy --cluster-id <cluster-id> --auto-backup <auto-backup>
#   [--frequency <frequency>]
#   [--start-time <start-time>]
#   [--retention-days <retention-days>]
#   [--api-key <api-key>]
```

**Flags:**
- `--cluster-id` (**required**, `string`) — cluster ID
- `--auto-backup` (**required**, `boolean`) — turn auto-backup on or off
- `--frequency` (`string`) — daily | weekdays | weekends | 1-7 (1=Mon, 7=Sun) e.g. 1,3,5
- `--start-time` (`string`) — start hour in UTC, e.g. 02:00
- `--retention-days` (`integer`) — days to retain backups (1-30)
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

## Live help

```bash
zilliz backup --help
```

Destructive operations (`delete`, `drop`, `restore`) require explicit user confirmation before execution.
