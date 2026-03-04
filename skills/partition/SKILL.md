---
name: partition
description: Use when the user wants to create, list, load, release, or drop partitions in a Milvus collection.
---

## Prerequisites

1. CLI installed, logged in, and cluster context set (see setup skill).
2. Target collection must exist (see collection skill).

## Commands Reference

### List Partitions

```bash
zilliz partition list --collection <collection-name>
```

### Create a Partition

```bash
zilliz partition create --collection <collection-name> --name <partition-name>
```

### Check if Partition Exists

```bash
zilliz partition has --collection <collection-name> --name <partition-name>
```

### Get Partition Statistics

```bash
zilliz partition get-stats --collection <collection-name> --name <partition-name>
```

### Load Partitions

```bash
zilliz partition load --collection <collection-name> --names '["partition1", "partition2"]'
```

### Release Partitions

```bash
zilliz partition release --collection <collection-name> --names '["partition1", "partition2"]'
```

### Drop a Partition

```bash
zilliz partition drop --collection <collection-name> --name <partition-name>
```

## Guidance

- Every collection has a default `_default` partition.
- Partitions allow organizing data for more targeted searches.
- A partition must be loaded before it can be searched.
- Before dropping a partition, confirm with the user — all data in it will be deleted.
- Use partition stats to check row counts per partition.
