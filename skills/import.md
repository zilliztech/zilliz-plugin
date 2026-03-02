---
name: import
description: Use when the user wants to import bulk data into a Milvus collection via Zilliz Cloud import jobs.
---

## Prerequisites

1. CLI installed and logged in (see setup skill).
2. Target collection must exist on the target cluster.

## Commands Reference

### Create an Import Job

```bash
zilliz import-job create \
  --cluster-id <cluster-id> \
  --collection <collection-name> \
  --body '{
    "files": [["s3://bucket/path/to/file.parquet"]],
    "options": {}
  }'
```

Supported file formats: Parquet, JSON, CSV.

### List Import Jobs

```bash
zilliz import-job list --cluster-id <cluster-id>
# Filter by database:
zilliz import-job list --cluster-id <cluster-id> --database <db-name>
# Pagination:
zilliz import-job list --cluster-id <cluster-id> --page-size 10 --page 1
```

### Check Import Progress

```bash
zilliz import-job get-progress --cluster-id <cluster-id> --job-id <job-id>
```

## Guidance

- Import jobs run asynchronously. After creating a job, use `get-progress` to track status.
- The data files must be accessible from Zilliz Cloud (e.g., S3, GCS with proper integration configured).
- The collection schema must match the data file structure.
