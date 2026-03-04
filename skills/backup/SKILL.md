---
name: backup
description: Use when the user wants to create, list, describe, delete, export, or restore backups, or manage backup policies on Zilliz Cloud.
---

## Prerequisites

1. CLI installed and logged in (see setup skill).
2. No cluster context required — backup operations use `--cluster-id` directly.

## Commands Reference

### Create a Backup

```bash
zilliz backup create --cluster-id <cluster-id> --backup-type <full|incremental>
# Advanced with body:
zilliz backup create --cluster-id <cluster-id> --backup-type full --body '{"collections": ["col1"]}'
```

### List Backups

```bash
zilliz backup list
# Filter:
zilliz backup list --cluster-id <cluster-id>
zilliz backup list --project-id <project-id>
zilliz backup list --backup-type full
zilliz backup list --creation-method manual
```

### Describe a Backup

```bash
zilliz backup describe --cluster-id <cluster-id> --backup-id <backup-id>
```

### Delete a Backup

```bash
zilliz backup delete --cluster-id <cluster-id> --backup-id <backup-id>
```

### Export a Backup

```bash
zilliz backup export \
  --cluster-id <cluster-id> \
  --backup-id <backup-id> \
  --integration-id <integration-id> \
  --directory <path>
```

### Restore to a New Cluster

```bash
zilliz backup restore-cluster \
  --cluster-id <source-cluster-id> \
  --backup-id <backup-id> \
  --project-id <project-id> \
  --name <new-cluster-name> \
  --cu-size <size> \
  --collection-status <loaded|unloaded>
```

### Restore Specific Collections

```bash
zilliz backup restore-collection \
  --cluster-id <source-cluster-id> \
  --backup-id <backup-id> \
  --dest-cluster-id <destination-cluster-id> \
  --body '{"collections": [{"source": "col1", "target": "col1_restored"}]}'
```

### Backup Policy

Get current policy:

```bash
zilliz backup get-policy --cluster-id <cluster-id>
```

Set backup policy:

```bash
zilliz backup set-policy \
  --cluster-id <cluster-id> \
  --enabled true \
  --frequency daily \
  --start-time "02:00" \
  --retention-days 7
```

## Guidance

- Before deleting a backup, confirm with the user — this is irreversible.
- When restoring, explain the difference between cluster restore (new cluster) and collection restore (into existing cluster).
- Suggest setting up a backup policy for production clusters.
