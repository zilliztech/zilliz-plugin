---
name: cluster
description: Use when the user wants to create, metrics, list, describe, modify,
  suspend, resume, delete, providers, or regions cluster resources.
---
# cluster

_Section: Cloud Management_ — Create, scale, and manage cloud clusters.

## Prerequisites

- `zilliz` CLI installed (see `/zilliz:setup`).
- Authenticated (`zilliz login`) and context set (`zilliz context set`).

## Commands Reference

### Create — Create a new cluster.

```bash
zilliz cluster create --name <name> --type <type>
#   [--project-id <project-id>]
#   [--region <region>]
#   [--cu-type <cu-type>]
#   [--cu-size <cu-size>]
#   [--plan <plan>]
```

**Flags:**
- `--name` (**required**, `string`) — Cluster name
- `--type` (**required**, `string`) — Cluster type: free, serverless, dedicated
- `--project-id` (`string`) — Project ID (prompted if omitted)
- `--region` (`string`) — Region ID (prompted if omitted)
- `--cu-type` (`string`) — CU type (dedicated only): Performance-optimized, Capacity-optimized
- `--cu-size` (`integer`) — Number of CUs (dedicated only)
- `--plan` (`string`) — Billing plan: Standard, Enterprise, BusinessCritical

### Metrics — Show cluster metrics.

```bash
zilliz cluster metrics
#   [--cluster-id <cluster-id>]
```

**Flags:**
- `--cluster-id` (`string`) — Cluster ID (uses context if omitted)

### List — List all clusters.

```bash
zilliz cluster list
#   [--page-size <page-size>]
#   [--page <page>]
#   [--api-key <api-key>]
```

**Flags:**
- `--page-size` (`integer`) — items per page
- `--page` (`integer`) — page number
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### Describe — Get details of a cluster.

```bash
zilliz cluster describe --cluster-id <cluster-id>
#   [--api-key <api-key>]
```

**Flags:**
- `--cluster-id` (**required**, `string`) — cluster ID (e.g. in01-xxxxxxxxxxxx)
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### Modify — Modify cluster configuration (scale CU or replicas).

```bash
zilliz cluster modify --cluster-id <cluster-id>
#   [--cu-size <cu-size>]
#   [--replica <replica>]
#   [--api-key <api-key>]
```

**Flags:**
- `--cluster-id` (**required**, `string`) — cluster ID to modify
- `--cu-size` (`integer`) — number of compute units
- `--replica` (`integer`) — number of replicas
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### Suspend — Suspend a running cluster. Suspending stops compute charges.

```bash
zilliz cluster suspend --cluster-id <cluster-id>
#   [--api-key <api-key>]
```

**Flags:**
- `--cluster-id` (**required**, `string`) — cluster ID to suspend
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### Resume — Resume a suspended cluster.

```bash
zilliz cluster resume --cluster-id <cluster-id>
#   [--api-key <api-key>]
```

**Flags:**
- `--cluster-id` (**required**, `string`) — cluster ID to resume
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### Delete — Delete a cluster. This action is irreversible.

```bash
zilliz cluster delete --cluster-id <cluster-id>
#   [--api-key <api-key>]
```

**Flags:**
- `--cluster-id` (**required**, `string`) — cluster ID to delete
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### Providers — List all cloud providers (aws, gcp, azure).

```bash
zilliz cluster providers
#   [--api-key <api-key>]
```

**Flags:**
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### Regions — List available regions for a cloud provider.

```bash
zilliz cluster regions
#   [--cloud-id <cloud-id>]
#   [--api-key <api-key>]
```

**Flags:**
- `--cloud-id` (`string`) — [aws, gcp, azure]    cloud provider
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

## Live help

```bash
zilliz cluster --help
```

Destructive operations (`delete`, `drop`, `restore`) require explicit user confirmation before execution.
