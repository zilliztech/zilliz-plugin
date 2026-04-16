---
name: import
description: Use when the user wants to start, list, or status import resources.
---
# import

_Section: Cloud Management_ — Import data from cloud storage.

## Prerequisites

- `zilliz` CLI installed (see `/zilliz:setup`).
- Authenticated (`zilliz login`) and context set (`zilliz context set`).

## Commands Reference

### Start — Start a data import job.

```bash
zilliz import start --cluster-id <cluster-id> --collection <collection>
#   [--api-key <api-key>]
```

**Flags:**
- `--cluster-id` (**required**, `string`) — target cluster ID
- `--collection` (**required**, `string`) — target collection name
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### List — List import jobs for a cluster.

```bash
zilliz import list --cluster-id <cluster-id>
#   [--page-size <page-size>]
#   [--page <page>]
#   [--database <database>]
#   [--api-key <api-key>]
```

**Flags:**
- `--cluster-id` (**required**, `string`) — cluster ID
- `--page-size` (`integer`) — items per page
- `--page` (`integer`) — page number
- `--database` (`string`) — database name
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### Status — Get status of an import job.

```bash
zilliz import status --job-id <job-id> --cluster-id <cluster-id>
#   [--api-key <api-key>]
```

**Flags:**
- `--job-id` (**required**, `string`) — import job ID
- `--cluster-id` (**required**, `string`) — cluster ID
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

## Live help

```bash
zilliz import --help
```

Destructive operations (`delete`, `drop`, `restore`) require explicit user confirmation before execution.
