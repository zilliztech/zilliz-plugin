---
name: billing
description: Use when the user wants to usage, or invoices billing resources.
---
# billing

_Section: Cloud Management_ — View usage, invoices, and billing information.

## Prerequisites

- `zilliz` CLI installed (see `/zilliz:setup`).
- Authenticated (`zilliz login`) and context set (`zilliz context set`).

## Commands Reference

### Usage — Show billing usage summary.

```bash
zilliz billing usage
#   [--month <month>  # default: today]
#   [--last <last>]
#   [--start <start>]
#   [--end <end>]
```

**Flags:**
- `--month` (`string`, default `today`) — Month: YYYY-MM, 'this', or 'last'
- `--last` (`string`) — Relative period: 7d, 1m, 1y
- `--start` (`string`) — Start time (ISO 8601 or YYYY-MM-DD)
- `--end` (`string`) — End time (ISO 8601 or YYYY-MM-DD)

### Invoices — List invoices.

```bash
zilliz billing invoices
#   [--page-size <page-size>  # default: 20]
#   [--page <page>  # default: 1]
```

**Flags:**
- `--page-size` (`integer`, default `20`) — Number of invoices per page
- `--page` (`integer`, default `1`) — Page number

## Live help

```bash
zilliz billing --help
```

Destructive operations (`delete`, `drop`, `restore`) require explicit user confirmation before execution.
