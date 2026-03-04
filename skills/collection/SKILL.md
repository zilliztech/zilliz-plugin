---
name: collection
description: Use when the user wants to create, list, describe, drop, rename, load, release, or manage collections and collection aliases in Milvus.
---

## Prerequisites

1. CLI installed, logged in, and cluster context set (see setup skill).

## Commands Reference

### List Collections

```bash
zilliz collection list
zilliz collection list --database <db-name>
```

### Describe a Collection

```bash
zilliz collection describe --name <collection-name>
```

### Create a Collection

Quick create with auto schema:

```bash
zilliz collection create --name <name> --dimension <dim>
# Optional parameters:
#   --metric-type COSINE|L2|IP (default: COSINE)
#   --id-type Int64|VarChar
#   --auto-id true|false
#   --primary-field <name>
#   --vector-field <name>
```

Advanced create with custom schema using `--body`:

```bash
zilliz collection create --name <name> --body '{
  "schema": {
    "fields": [
      {"fieldName": "id", "dataType": "Int64", "isPrimary": true},
      {"fieldName": "vector", "dataType": "FloatVector", "elementTypeParams": {"dim": "768"}},
      {"fieldName": "text", "dataType": "VarChar", "elementTypeParams": {"max_length": "1024"}}
    ]
  }
}'
```

### Drop a Collection

```bash
zilliz collection drop --name <collection-name>
```

### Check if Collection Exists

```bash
zilliz collection has --name <collection-name>
```

### Rename a Collection

```bash
zilliz collection rename --name <old-name> --new-name <new-name>
# Move to another database:
zilliz collection rename --name <old-name> --new-name <new-name> --new-database <db-name>
```

### Load a Collection into Memory

```bash
zilliz collection load --name <collection-name>
```

### Release a Collection from Memory

```bash
zilliz collection release --name <collection-name>
```

### Get Collection Statistics

```bash
zilliz collection get-stats --name <collection-name>
```

### Get Load State

```bash
zilliz collection get-load-state --name <collection-name>
```

### Flush a Collection

```bash
zilliz collection flush --name <collection-name>
```

### Compact a Collection

```bash
zilliz collection compact --name <collection-name>
```

### Collection Aliases

Create an alias:

```bash
zilliz alias create --collection <collection-name> --alias <alias-name>
```

List aliases:

```bash
zilliz alias list --database <db-name>
# Filter by collection:
zilliz alias list --database <db-name> --collection <collection-name>
```

Describe an alias:

```bash
zilliz alias describe --alias <alias-name>
```

Alter an alias (point to a different collection):

```bash
zilliz alias alter --collection <new-collection-name> --alias <alias-name>
```

Drop an alias:

```bash
zilliz alias drop --alias <alias-name>
```

## Guidance

- When the user wants to create a collection, ask about their use case to recommend appropriate dimension, metric type, and schema.
- Before dropping a collection, always confirm with the user — this deletes all data.
- A collection must be loaded before it can be searched or queried.
- After creating a collection, suggest loading it if the user plans to query immediately.
- Use `describe` to inspect schema before performing vector operations.
