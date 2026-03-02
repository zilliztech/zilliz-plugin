---
name: status
description: Show a comprehensive overview of the current Zilliz Cloud cluster — context, cluster details, databases, and collections with stats.
---

Gather and display a status overview of the user's current Zilliz Cloud environment. Run commands with `--output json` for structured data, then present a formatted summary.

## Step 1: Check Prerequisites

Verify CLI is installed and user is logged in:

```bash
zilliz auth status
```

If not set up, suggest running `/quickstart` first.

## Step 2: Show Current Context

```bash
zilliz context current --output json
```

If no context is set, suggest running `zilliz context set --cluster-id <id>`.

## Step 3: Cluster Details

Using the cluster ID from context:

```bash
zilliz cluster describe --cluster-id <cluster-id> --output json
```

Present: cluster name, status, plan, region.

## Step 4: Database List

```bash
zilliz database list --output json
```

## Step 5: Collections Summary

```bash
zilliz collection list --output json
```

For each collection, gather stats:

```bash
zilliz collection get-stats --name <name> --output json
zilliz collection get-load-state --name <name> --output json
```

## Step 6: Present Summary

Format the results as a readable summary:

**Cluster:** <name> (<cluster-id>)
**Status:** RUNNING | **Region:** <region> | **Plan:** <plan>
**Database:** <current-db>

**Collections:**

| Collection | Rows | Load State |
|---|---|---|
| my_collection | 10,000 | Loaded |
| ... | ... | ... |

If the cluster is suspended, show a warning that data operations are unavailable.
