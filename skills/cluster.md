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

### Create a Serverless Cluster

```bash
zilliz cluster create --name <name> --project-id <project-id> --region <region-id>
```

To find available project IDs and regions:
```bash
zilliz project list
zilliz region list
```

### Create a Free Tier Cluster

```bash
zilliz cluster create-free --name <name> --project-id <project-id> --region <region-id>
```

### Create a Dedicated Cluster

```bash
zilliz cluster create-dedicated \
  --name <name> \
  --project-id <project-id> \
  --region <region-id> \
  --cu-type <cu-type> \
  --cu-size <cu-size>
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

- Before creating a cluster, help the user choose a region by listing available regions first.
- Cluster creation is **asynchronous**. After `cluster create`, the cluster status will be `CREATING`. Poll with `zilliz cluster describe --cluster-id <id>` until the status becomes `RUNNING` before proceeding with data-plane operations.
- Before deleting a cluster, always confirm with the user — this is irreversible.
- After creating a cluster, suggest setting it as the active context with `zilliz context set --cluster-id <id>`.
- When a cluster is suspended, remind the user it must be resumed before data-plane operations.
- Different cluster types have different capabilities. See the "Cluster Type Differences" table in the setup skill for details.
