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
# Full cluster backup (default)
zilliz backup create --cluster-id in01-xxxxxxxxxxxx

# Collection-level backup
zilliz backup create --cluster-id in01-xxxxxxxxxxxx --database default --collection my_col
```

The backup type is automatically derived: if `--collection` is provided, it's a COLLECTION backup; otherwise it's a CLUSTER backup.

### List Backups

```bash
zilliz backup list
zilliz backup list --cluster-id <cluster-id>
zilliz backup list --project-id <project-id>
zilliz backup list --creation-method manual   # or: auto
zilliz backup list --backup-type CLUSTER      # or: COLLECTION
zilliz backup list --page-size 10 --page 1
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
  --collection-status LOADED
```

Valid `--collection-status` values: `LOADED`, `NOT_LOADED`.

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
zilliz backup describe-policy --cluster-id <cluster-id>
```

Update backup policy:

```bash
# Enable daily backup at 2am UTC with 7-day retention
zilliz backup update-policy --cluster-id in01-xxxx --auto-backup true --frequency daily --start-time 02:00 --retention-days 7

# Enable backup on Mon/Wed/Fri at 3am UTC
zilliz backup update-policy --cluster-id in01-xxxx --auto-backup true --frequency 1,3,5 --start-time 03:00-05:00 --retention-days 14

# Disable auto-backup
zilliz backup update-policy --cluster-id in01-xxxx --auto-backup false
```

Frequency format: `daily | weekdays | weekends | 1-7 (1=Mon, 7=Sun) e.g. 1,3,5`
Start time format: `HH:MM` or `HH:MM-HH:MM` (time window)

## Guidance

- Before deleting a backup, confirm with the user — this is irreversible.
- When restoring, explain the difference between cluster restore (new cluster) and collection restore (into existing cluster).
- Suggest setting up a backup policy for production clusters.
