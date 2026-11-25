---
name: cluster
description: Use when the user wants to create, list, describe, delete, suspend, resume, or modify Zilliz Cloud clusters.
---

## Prerequisites

1. CLI installed and logged in (see setup skill).
2. No cluster context required -- these are control-plane operations.

## Commands Reference

### Create a Cluster

```bash
# Serverless cluster
zilliz cluster create \
  --name <cluster-name> \
  --type serverless \
  --project-id <project-id> \
  --region <region-id>

# Free-tier cluster
zilliz cluster create \
  --name <cluster-name> \
  --type free \
  --project-id <project-id> \
  --region <region-id>

# Dedicated cluster
zilliz cluster create \
  --name <cluster-name> \
  --type dedicated \
  --project-id <project-id> \
  --region <region-id> \
  --cu-type <Performance-optimized|Capacity-optimized> \
  --cu-size <cu-size>

# Dedicated cluster on a specific Milvus version
zilliz cluster create \
  --name <cluster-name> \
  --type dedicated \
  --project-id <project-id> \
  --region <region-id> \
  --cu-type <Performance-optimized|Capacity-optimized> \
  --cu-size <cu-size> \
  --version <version-family> \
  --channel <GA|PUBLIC_PREVIEW>
```

Take `--version` (e.g. `2.6.x`) and `--channel` from an option listed by
`zilliz cluster versions --region-id <region-id>` for the same region.

To find available project IDs, cloud providers, and regions:

```bash
zilliz project list
zilliz cluster providers
zilliz cluster regions --cloud-id <aws|gcp|azure>
```

### Create a Vector Lake instance

A Vector Lake (sometimes called a "VectorLake" cluster) is the storage layer
that on-demand clusters attach to (see the `on-demand-cluster` skill). It is
created via a hand-written subcommand calling
`POST /v2/clusters/createVectorLake`:

```bash
zilliz cluster create-vectorlake \
  --project-id <project-id> \
  --region-id <region-id> \
  [--session-ttl <duration>] \      # idle auto-suspend TTL, min 60s
  [--max-query-node-cu <integer>] \
  [--max-query-node-replicas <integer>]
```

After the Vector Lake is `RUNNING`, attach a query workload with
`zilliz on-demand-cluster create --project-id <id> --region-id <region> --cu-size <n> --cluster-name <name>`.

### List Clusters

```bash
zilliz cluster list
# Optional: --region-id <filter-by-region-id>, --project-id <filter-by-project-id>
# Pagination: --page-size <n> --page <n>
# Fetch all pages: --all
```

### Describe a Cluster

```bash
zilliz cluster describe --cluster-id <cluster-id>
```

### Modify a Cluster

```bash
zilliz cluster modify --cluster-id <cluster-id-to-modify>
# Optional: --cu-size <number-of-compute-units>, --replica <number-of-replicas>
# Or use raw JSON: --body '{"cuSize": 2, "replica": 2}'
```

### Suspend a Cluster

```bash
zilliz cluster suspend --cluster-id <cluster-id-to-suspend>
```

### Resume a Cluster

```bash
zilliz cluster resume --cluster-id <cluster-id-to-resume>
```

### Delete a Cluster

```bash
zilliz cluster delete --cluster-id <cluster-id-to-delete>
```

### List Cloud Providers

```bash
zilliz cluster providers
```

### List Regions

```bash
zilliz cluster regions
# Optional: --cloud-id <aws|gcp|azure>
```

### List Milvus versions available for creating a dedicated cluster or restoring a backup

```bash
zilliz cluster versions
# Optional: --region-id <region-id>, --backup-id <backup-id>
```

## Guidance

- Before creating a cluster, help the user choose a region by running `zilliz cluster providers` and `zilliz cluster regions`.
- Cluster creation is **asynchronous**. After `cluster create`, the cluster status will be `CREATING`. Poll with `zilliz cluster describe --cluster-id <id>` until the status becomes `RUNNING` before proceeding with data-plane operations.
- Before deleting a cluster, always confirm with the user -- this is irreversible.
- After creating a cluster, suggest setting it as the active context with `zilliz context set --cluster-id <id>`.
- When a cluster is suspended, remind the user it must be resumed before data-plane operations.
- Different cluster types have different capabilities. See the "Cluster Type Differences" table in the setup skill for details.
- `cluster create-vectorlake` creates a Vector Lake storage instance, not a regular cluster. Query workloads against it run on on-demand clusters (see the `on-demand-cluster` skill). Do not pass `--type` to this subcommand; it has its own dedicated parameter set.
- To create a dedicated cluster on a specific Milvus version, first run `zilliz cluster versions --region-id <region>` and pass the chosen option's `milvusVersion` as `--version` and its `channel` as `--channel`. Both flags are required together, only `GA` and `PUBLIC_PREVIEW` are valid for creation, and they are not supported for serverless or free clusters. Without them, the default version is used. An empty list (or error `96018` on endpoints where explicit version listing is not yet enabled) means no version can be selected explicitly in that region; omit `--version` and `--channel` to use the default Milvus version.
- `cluster create --type dedicated` only prompts for missing `--cu-type`, `--cu-size` and `--version` in an interactive terminal. Agent runs are non-interactive: ask the user for the CU type and size and pass them explicitly, otherwise the command fails. When the user cares about the version, list the options with `zilliz cluster versions` and let them choose; omitting `--version` silently uses the default version.
- `cluster list` supports `--region-id <region>` and `--project-id <project-id>` filters for scoping to a single region or project. Filtering is server-side, so `--page`, `--page-size` and the total count apply to the filtered result. When the user asks about clusters in a specific project, use `--project-id` instead of listing everything and filtering client-side.
