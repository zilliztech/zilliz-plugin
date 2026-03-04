---
name: index
description: Use when the user wants to create, list, describe, or drop indexes on Milvus collections.
---

## Prerequisites

1. CLI installed, logged in, and cluster context set (see setup skill).
2. Target collection must exist (see collection skill).

## Commands Reference

### Create an Index

```bash
zilliz index create --collection <collection-name> --body '{
  "indexParams": [
    {
      "fieldName": "vector",
      "indexName": "vector_index",
      "metricType": "COSINE",
      "indexType": "AUTOINDEX"
    }
  ]
}'
```

Common index types:
- `AUTOINDEX` — recommended, automatically selects the best index
- `IVF_FLAT`, `IVF_SQ8`, `HNSW` — manual selection for advanced users

Common metric types:
- `COSINE` — cosine similarity (default)
- `L2` — Euclidean distance
- `IP` — inner product

### List Indexes

```bash
zilliz index list --collection <collection-name>
```

### Describe an Index

```bash
zilliz index describe --collection <collection-name> --index-name <index-name>
```

### Drop an Index

```bash
zilliz index drop --collection <collection-name> --index-name <index-name>
```

## Guidance

- On Zilliz Cloud, `AUTOINDEX` is recommended for most use cases.
- An index is required before loading a collection for search.
- Before creating an index, check the collection schema to identify vector fields.
- After creating an index, remind the user to load the collection.
