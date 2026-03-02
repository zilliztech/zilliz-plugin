---
name: vector
description: Use when the user wants to search, query, insert, upsert, get, or delete vectors in a Milvus collection.
---

## Prerequisites

1. CLI installed, logged in, and cluster context set (see setup skill).
2. Target collection must exist and be loaded (see collection skill).

## Commands Reference

### Vector Search

```bash
zilliz vector search \
  --collection <collection-name> \
  --data '[[0.1, 0.2, 0.3, ...]]' \
  --limit 10
# Optional:
#   --filter 'age > 20 and status == "active"'
#   --output-fields '["field1", "field2"]'
#   --anns-field <vector-field-name>  (if collection has multiple vector fields)
#   --database <db-name>
```

The `--data` parameter accepts a JSON array of vectors. Each vector is an array of floats.

### Hybrid Search

```bash
zilliz vector hybrid-search \
  --collection <collection-name> \
  --search '[
    {"data": [[0.1, 0.2, ...]], "annsField": "dense_vector", "limit": 10},
    {"data": [["search text"]], "annsField": "sparse_vector", "limit": 10}
  ]' \
  --rerank '{"strategy": "rrf", "params": {"k": 60}}' \
  --limit 10
# Optional:
#   --output-fields '["field1", "field2"]'
```

Or use `--body` for complex hybrid search configurations.

### Query (Filter-Based Retrieval)

```bash
zilliz vector query \
  --collection <collection-name> \
  --filter 'id in [1, 2, 3]' \
  --limit 10
# Optional:
#   --output-fields '["field1", "field2"]'
```

### Get by ID

```bash
zilliz vector get \
  --collection <collection-name> \
  --id '[1, 2, 3]'
# Optional:
#   --output-fields '["field1", "field2"]'
```

### Insert Vectors

```bash
zilliz vector insert \
  --collection <collection-name> \
  --data '[
    {"id": 1, "vector": [0.1, 0.2, ...], "text": "hello"},
    {"id": 2, "vector": [0.3, 0.4, ...], "text": "world"}
  ]'
```

For large datasets, consider reading data from a file:
```bash
zilliz vector insert --collection <name> --data "$(cat data.json)"
```

### Upsert Vectors

```bash
zilliz vector upsert \
  --collection <collection-name> \
  --data '[{"id": 1, "vector": [0.1, ...], "text": "updated"}]'
# Optional:
#   --partition <partition-name>
```

### Delete Vectors

```bash
zilliz vector delete \
  --collection <collection-name> \
  --filter 'id in [1, 2, 3]'
# Optional:
#   --partition <partition-name>
```

## Filter Expression Syntax

Common filter patterns:

| Expression | Example |
|---|---|
| Comparison | `age > 20` |
| Equality | `status == "active"` |
| IN list | `id in [1, 2, 3]` |
| AND/OR | `age > 20 and status == "active"` |
| String match | `text like "hello%"` |
| Array contains | `tags array_contains "ml"` |

## Guidance

- Before searching, inspect the collection schema with `zilliz collection describe` to understand field names and vector dimensions.
- The collection must be loaded before search/query operations.
- For search, the `--data` value must match the collection's vector dimension exactly.
- When the user provides a text query and wants semantic search, explain that they need to convert text to vectors first (using an embedding model) before passing to `--data`.
- For large insert operations, suggest writing data to a JSON file first, then reading it.
- Always show `--output-fields` when the user wants specific fields in results.
