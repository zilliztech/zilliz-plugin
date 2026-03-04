---
name: import
description: Use when the user wants to import bulk data into a Milvus collection via Zilliz Cloud import jobs.
---

## Prerequisites

1. CLI installed and logged in (see setup skill).
2. Target collection must exist on the target cluster.

## Commands Reference

### Start an Import Job

```bash
zilliz import start \
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
zilliz import list --cluster-id <cluster-id>
# Filter by database:
zilliz import list --cluster-id <cluster-id> --database <db-name>
# Pagination:
zilliz import list --cluster-id <cluster-id> --page-size 10 --page 1
```

### Check Import Status

```bash
zilliz import status --cluster-id <cluster-id> --job-id <job-id>
```

## Guidance

- Import jobs run asynchronously. After starting a job, use `import status` to track progress.
- The data files must be accessible from Zilliz Cloud (e.g., S3, GCS with proper integration configured).
- The collection schema must match the data file structure.
