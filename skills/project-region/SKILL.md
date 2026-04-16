---
name: project-region
description: Use when the user wants to manage Zilliz Cloud projects or storage volumes. For cloud regions and providers, see the cluster skill.
---

## Prerequisites

1. CLI installed and logged in (see setup skill).

## Commands Reference

### Projects

#### Create a Project

```bash
zilliz project create --name <project-name> --plan <Standard|Enterprise|BusinessCritical>
```

#### List Projects

```bash
zilliz project list
```

#### Describe a Project

```bash
zilliz project describe --project-id <project-id>
```

#### Upgrade a Project

```bash
zilliz project upgrade --project-id <project-id> --plan <Standard|Enterprise|BusinessCritical>
```

### Volumes

Volumes are project-level object stores for staging data used by import, migration, and merge workflows. Any cluster in the same project and region can read from them. See the `import` skill for how volumes feed bulk-import jobs.

#### Create a Volume

```bash
zilliz volume create \
  --project-id <project-id> \
  --region <cloud-region> \
  --name <volume-name>
# --region must match the target cluster's region (e.g. aws-us-west-2); a volume
# is only readable by clusters in the same project and region.
```

#### List Volumes

```bash
zilliz volume list --project-id <project-id>
# Pagination: --page-size <n> --page <n>
```

#### Delete a Volume

```bash
zilliz volume delete --name <volume-name-to-delete>
```

## Guidance

- When the user wants to create a cluster, they need a project ID and region ID first. Guide them through `zilliz project list` and `zilliz cluster regions` (see cluster skill).
- Project `upgrade` does not include `Free` as a valid target plan -- only Serverless, Standard, and Enterprise.
- Before deleting a volume, confirm with the user.
- Volumes are scoped to a project + region. To import into a cluster, create the volume in that cluster's region.
- Free-trial volumes are limited to 1 per org, 5 GB, with 30-day auto-retention. Pay-as-you-go volumes have no retention limit -- see the pricing reference in the `ask-zilliz` skill for details.
- The CLI covers `create`, `list`, and `delete` only; uploading files into a volume is SDK-only today. After creating a volume, the typical next step is an SDK upload followed by `zilliz import start` (see `import` skill).
