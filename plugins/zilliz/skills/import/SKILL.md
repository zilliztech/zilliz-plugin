---
name: import
description: Use when the user wants to import bulk data into a Milvus collection via Zilliz Cloud import jobs, from object storage or from files uploaded to a volume.
---

## Prerequisites

1. CLI installed and logged in (see setup skill).
2. Target collection must exist on the target cluster.

## Commands Reference

### Start an Import Job

```bash
zilliz import start --collection <target-collection-name>
# Optional:
#   --cluster-id <target-cluster-id>
#   --project-id <project-id>
#   --region-id <region-id>
# Or use raw JSON: --body '{"volumeName": "my-volume", "dataPaths": [["data/part-1.parquet"]]}'
```

### List Imports

```bash
zilliz import list
# Optional:
#   --cluster-id <cluster-id>
#   --project-id <project-id>
#   --region-id <region-id>
#   --database <database-name>
```

### Check Import Status

```bash
zilliz import status --job-id <import-job-id>
# Optional:
#   --cluster-id <cluster-id>
#   --project-id <project-id>
#   --region-id <region-id>
```

## Import Sources

`import start` reads its source from `--body`. There are two kinds of source:

- **A managed volume** (preferred when the files are local). Upload them with
  `zilliz volume upload` (see the volume skill), then reference the
  volume and the file paths inside it:

  ```bash
  zilliz import start --cluster-id <cluster-id> --collection <collection> \
    --body '{"volumeName": "<volume-name>", "dataPaths": [["data/2026-10/part-1.parquet"]]}'
  ```

- **Object storage URLs** the user already has, with access keys when the
  bucket is not public:

  ```bash
  zilliz import start --cluster-id <cluster-id> --collection <collection> \
    --body '{"objectUrls": [["s3://bucket/path/data.parquet"]], "accessKey": "<ak>", "secretKey": "<sk>"}'
  ```

Each inner list in `dataPaths` / `objectUrls` is one file group. Supported
file formats: Parquet, JSON, CSV. `--body` also accepts `dbName` and
`partitionName`.

Import stages (`zilliz stage ...`) are deprecated in favor of volumes. The
commands still work for existing stages, but do not suggest them for new
imports.

## Import Targets

`import start`, `import list`, and `import status` accept either:

- `--cluster-id <id>` (legacy form, still supported), or
- `--project-id <id>` together with `--region-id <region>` (the server then
  resolves the target instance from the project + region pair).

You must supply exactly one of those two grouping forms -- the CLI rejects
an import command that provides neither, or that provides `--project-id`
without `--region-id`.

## Guidance

- Import jobs run asynchronously. After starting a job, use `import status` to track progress.
- Never echo the user's `accessKey` / `secretKey` back in a reply; prefer a volume when the files are local.
- The collection schema must match the data file structure.
- When importing into a Vector Lake / on-demand-cluster setup, prefer the `--project-id` + `--region-id` form -- on-demand clusters do not have a stable single cluster ID to point at.
