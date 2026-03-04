---
name: project-region
description: Use when the user wants to manage Zilliz Cloud projects or storage volumes. For cloud regions and providers, see the cluster skill.
---

## Prerequisites

1. CLI installed and logged in (see setup skill).

## Commands Reference

### Projects

List projects:

```bash
zilliz project list
```

Describe a project:

```bash
zilliz project describe --project-id <project-id>
```

Create a project:

```bash
zilliz project create --name <project-name> --plan <plan-type>
```

Upgrade a project:

```bash
zilliz project upgrade --project-id <project-id> --plan <new-plan>
```

### Volumes

Create a volume:

```bash
zilliz volume create --project-id <project-id> --region <region-id> --name <volume-name>
```

List volumes:

```bash
zilliz volume list --project-id <project-id>
```

Delete a volume:

```bash
zilliz volume delete --name <volume-name>
```

## Guidance

- When the user wants to create a cluster, they need a project ID and region ID first. Guide them through `zilliz project list` and `zilliz cluster regions` (see cluster skill).
- Before deleting a volume, confirm with the user.
