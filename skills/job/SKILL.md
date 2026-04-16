---
name: job
description: Use when the user wants to describe job resources.
---
# job

_Section: Cloud Management_ — Query status of async Cloud Jobs.

## Prerequisites

- `zilliz` CLI installed (see `/zilliz:setup`).
- Authenticated (`zilliz login`) and context set (`zilliz context set`).

## Commands Reference

### Describe — Get status of an async job (backup, restore, migration, import, etc.).

```bash
zilliz job describe --job-id <job-id>
#   [--api-key <api-key>]
```

**Flags:**
- `--job-id` (**required**, `string`) — job ID (e.g. job-xxxxxxxxxxxxxxxxxxxx)
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

## Live help

```bash
zilliz job --help
```

Destructive operations (`delete`, `drop`, `restore`) require explicit user confirmation before execution.
