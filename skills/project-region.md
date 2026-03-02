---
name: project-region
description: Use when the user wants to manage Zilliz Cloud projects, query available cloud regions and providers, or manage storage volumes.
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

### Regions and Cloud Providers

List cloud providers:

```bash
zilliz region list-providers
```

List available regions:

```bash
zilliz region list
# Filter by cloud provider:
zilliz region list --cloud-id <cloud-id>
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

- When the user wants to create a cluster, they need a project ID and region ID first. Guide them through listing projects and regions.
- Before deleting a volume, confirm with the user.
- Use `region list-providers` and `region list` to help users choose where to deploy.
