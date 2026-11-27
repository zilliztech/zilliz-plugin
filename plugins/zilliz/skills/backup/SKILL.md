---
name: backup
description: Use when the user wants to create, list, describe, delete, export, or restore backups, or manage backup policies on Zilliz Cloud.
---

## Prerequisites

1. CLI installed and logged in (see setup skill).
2. No cluster context required -- backup operations use `--cluster-id` directly.

## Commands Reference

### Create a Backup

```bash
zilliz backup create --cluster-id <cluster-id>
# Optional:
#   --database <database-name>
#   --collection <collection-name>
#   --backup-type <CLUSTER|COLLECTION>
# Or use raw JSON: --body '{...}'
```

### List Backups

```bash
zilliz backup list
# Optional:
#   --project-id <filter-by-project-id>
#   --cluster-id <filter-by-cluster-id>
#   --creation-method <MANUAL|AUTO>
#   --backup-type <CLUSTER|COLLECTION>
# Pagination: --page-size <n> --page <n>
# Fetch all pages: --all
```

### Describe a Backup

```bash
zilliz backup describe --cluster-id <cluster-id> --backup-id <backup-id>
```

### Delete a Backup

```bash
zilliz backup delete --cluster-id <cluster-id> --backup-id <backup-id-to-delete>
```

### Export a Backup

```bash
zilliz backup export \
  --cluster-id <cluster-id> \
  --backup-id <backup-id> \
  --integration-id <storage-integration-id>
# Optional: --directory <directory>
```

### Restore to a New Cluster

```bash
zilliz backup restore-cluster \
  --cluster-id <source-cluster-id> \
  --backup-id <backup-id-to-restore> \
  --project-id <target-project-id> \
  --name <new-cluster-name> \
  --cu-size <compute-units-for-new-cluster> \
  --collection-status <KEEP|RELEASE>
# Optional:
#   --restore-version-policy <LATEST|ORIGINAL>
#   --version <version>
#   --channel <GA|PUBLIC_PREVIEW|ORIGIN>
```

### Restore Specific Collections

```bash
zilliz backup restore-collection \
  --cluster-id <source-cluster-id> \
  --backup-id <backup-id> \
  --dest-cluster-id <destination-cluster-id>
# Or use raw JSON: --body '{"collections": [{"source": "col1", "target": "col1_restored"}]}'
```

### Describe Backup Policy

```bash
zilliz backup describe-policy --cluster-id <cluster-id>
```

### Update Backup Policy

```bash
zilliz backup update-policy --cluster-id <cluster-id> --auto-backup <true|false>
# Optional:
#   --frequency <frequency>
#   --start-time <start-time>
#   --retention-days <days-to-retain-backups>
# Or use raw JSON: --body '{...}'
```

## Backup Policy Format

Frequency: `daily | weekdays | weekends | 1-7` (1=Mon, 7=Sun), e.g. `1,3,5`

Start time: `HH:MM` or `HH:MM-HH:MM` (time window), e.g. `02:00` or `03:00-05:00`

## Guidance

- The backup type is automatically derived: if `--collection` is provided, it's a COLLECTION backup; otherwise it's a CLUSTER backup. Whole-cluster (`CLUSTER`) backups require a **Dedicated** cluster; Serverless clusters reject `--type CLUSTER` (`96022`).
- Backup creation, export, and restore operations are **asynchronous**. Pass `--wait` to `zilliz backup create` to wait for completion, or use `zilliz backup describe` to check progress.
- The `--integration-id` for export refers to a cloud storage integration configured in the Zilliz Cloud console (see import skill for setup guidance).
- Before deleting a backup, confirm with the user -- this is irreversible.
- When restoring, explain the difference between cluster restore (new cluster) and collection restore (into existing cluster).
- To restore a cluster backup onto a specific Milvus version, first run `zilliz cluster versions --backup-id <backup-id>` and pass the chosen option's `milvusVersion` as `--version` and its `channel` as `--channel` to `backup restore-cluster`. `ORIGIN` restores the exact version recorded in the backup. Do not combine `--version`/`--channel` with `--restore-version-policy`. An empty list (or error `96018` when explicit version listing is not yet enabled on the endpoint) means explicit version selection is unavailable; restore without these flags to keep the default behavior.
- In an interactive terminal, `backup restore-cluster` without `--version`, `--channel` or `--restore-version-policy` prompts the user to pick a version. Agent runs are non-interactive and get no prompt, so the default restore behavior applies; if the user wants a specific version, list the options with `zilliz cluster versions --backup-id <backup-id>` and pass the choice explicitly.
- Suggest setting up a backup policy for production clusters.
