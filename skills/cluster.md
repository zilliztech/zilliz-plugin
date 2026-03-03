---
name: cluster
description: Use when the user wants to create, list, describe, delete, suspend, resume, or modify Zilliz Cloud clusters.
---

## Prerequisites

1. CLI installed and logged in (see setup skill).
2. No cluster context required — these are control-plane operations.

## Commands Reference

### List Clusters

```bash
zilliz cluster list
# Paginated:
zilliz cluster list --page-size 10 --page 1
# Fetch all pages:
zilliz cluster list --all
```

### Describe a Cluster

```bash
zilliz cluster describe --cluster-id <cluster-id>
```

### Create a Cluster

```bash
# Serverless (default)
zilliz cluster create --type serverless --name <name> --project-id <project-id> --region <region-id>

# Free tier
zilliz cluster create --type free --name <name> --project-id <project-id> --region <region-id>

# Dedicated
zilliz cluster create --type dedicated \
  --name <name> \
  --project-id <project-id> \
  --region <region-id> \
  --cu-type <cu-type> \
  --cu-size <cu-size>
```

To find available project IDs, cloud providers, and regions:
```bash
zilliz project list
zilliz cluster providers
zilliz cluster regions
# Filter by cloud provider:
zilliz cluster regions --cloud-id <cloud-id>
```

### Delete a Cluster

```bash
zilliz cluster delete --cluster-id <cluster-id>
```

### Suspend a Cluster

```bash
zilliz cluster suspend --cluster-id <cluster-id>
```

### Resume a Cluster

```bash
zilliz cluster resume --cluster-id <cluster-id>
```

### Modify a Cluster

```bash
zilliz cluster modify --cluster-id <cluster-id> --cu-size <new-size>
zilliz cluster modify --cluster-id <cluster-id> --replica <count>
# Or use raw JSON body:
zilliz cluster modify --cluster-id <cluster-id> --body '{"cuSize": 2, "replica": 2}'
```

## Guidance

- Before creating a cluster, help the user choose a region by running `zilliz cluster providers` and `zilliz cluster regions`.
- Cluster creation is **asynchronous**. After `cluster create`, the cluster status will be `CREATING`. Poll with `zilliz cluster describe --cluster-id <id>` until the status becomes `RUNNING` before proceeding with data-plane operations.
- Before deleting a cluster, always confirm with the user — this is irreversible.
- After creating a cluster, suggest setting it as the active context with `zilliz context set --cluster-id <id>`.
- When a cluster is suspended, remind the user it must be resumed before data-plane operations.
- Different cluster types have different capabilities. See the "Cluster Type Differences" table in the setup skill for details.
