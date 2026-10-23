---
name: project-region
description: Use when the user wants to create, list, describe, delete, or upgrade Zilliz Cloud projects, or bind additional regions to a project. For cloud regions and providers, see the cluster skill; for volumes, see the volume skill.
---

## Prerequisites

1. CLI installed and logged in (see setup skill).

## Commands Reference

### Create a Project

```bash
zilliz project create --name <project-name> --plan <Standard|Enterprise|BusinessCritical>
# Optional: --region '[...]'
```

### List Projects

```bash
zilliz project list
```

### Describe a Project

```bash
zilliz project describe --project-id <project-id>
```

### Delete a Project

```bash
zilliz project delete --project-id <project-id>
```

### Upgrade a Project

```bash
zilliz project upgrade --project-id <project-id> --plan <Standard|Enterprise|BusinessCritical>
```

### Bind additional regions to an existing project

```bash
zilliz project add-regions --project-id <project-id> --region '[...]'
```

## Guidance

- When the user wants to create a cluster, they need a project ID and region ID first. Guide them through `zilliz project list` and `zilliz cluster regions` (see cluster skill).
- Project `upgrade` does not include `Free` as a valid target plan -- only Serverless, Standard, and Enterprise.
