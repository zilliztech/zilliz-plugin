---
name: volume
description: Use when the user wants to create, list, describe, or delete a Zilliz Cloud volume, upload local files or directories into a managed volume, or get temporary upload credentials for one.
---

## Prerequisites

1. CLI installed and logged in (see setup skill).
2. A project and cloud region to create the volume in (see project-region skill).

## Commands Reference

### Upload Local Files to a Volume

`volume upload` copies a local file or directory into a managed volume. It
requests temporary credentials itself (the same ones `volume apply` returns),
so there is no separate credential step.

```bash
# Upload one file to the volume root
zilliz volume upload --name <volume-name> --source ./data.parquet

# Upload a directory's contents under data/2026-10/
zilliz volume upload --name <volume-name> --source ./dataset --path data/2026-10/

# Optional:
#   --path <dir-in-volume>    Target directory inside the volume (default: volume root)
#   --policy <policy>         overwrite | skip-if-exists | skip-if-same-size | size-and-mtime
#                             (default: skip-if-same-size)
#   --concurrency <n>         Concurrent upload requests (default: 5)
#   --part-size <MiB>         Multipart part size, 5-5120 (default: auto)
#   --max-retries <n>         Retries per failed storage request (default: 5)
```

A file is uploaded as `<path>/<file name>`; a directory's contents are
uploaded under `<path>/` keeping their relative layout. Uploads work on AWS,
GCP, Alibaba Cloud, and Tencent Cloud volumes.

### Create a Volume

```bash
zilliz volume create \
  --project-id <project-id> \
  --region <cloud-region> \
  --name <volume-name>
```

### List Volumes

```bash
zilliz volume list --project-id <project-id>
# Pagination: --page-size <n> --page <n>
# Fetch all pages: --all
```

### Delete a Volume

```bash
zilliz volume delete --name <volume-name-to-delete>
```

### Describe a Volume

```bash
zilliz volume describe --name <volume-name>
```

### Apply temporary upload credentials for a managed volume path

```bash
zilliz volume apply --name <volume-name>
# Optional: --path <path>
```

## Guidance

- Before deleting a volume, confirm with the user.
- To put local files into a managed volume, use `volume upload` rather than `volume apply` -- `apply` only returns temporary credentials for the user's own tooling. External volumes are read-only and reject uploads.
- Re-running an upload skips files already present with the same size, so an interrupted upload can simply be re-run. Use `--policy overwrite` to force a re-upload.
- To load uploaded files into a collection, start an import job that references the volume (see the import skill).
