---
name: vector
description: Use when the user wants to insert, upsert, search, hybrid search,
  query, get, or delete vector resources.
---
# vector

_Section: Data Operations_ — Search, insert, and query vector data.

## Prerequisites

- `zilliz` CLI installed (see `/zilliz:setup`).
- Authenticated (`zilliz login`) and context set (`zilliz context set`).

## Commands Reference

### Insert — Insert entities into a collection.

```bash
zilliz vector insert --collection <collection>
#   [--data <data-json-array>]
#   [--database <database>]
#   [--api-key <api-key>]
```

**Flags:**
- `--collection` (**required**, `string`) — collection name
- `--data` (`array`) — entities as JSON array or file://path.json
- `--database` (`string`) — database name
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### Upsert — Upsert entities (insert or update if exists).

```bash
zilliz vector upsert --collection <collection>
#   [--data <data-json-array>]
#   [--partition <partition>]
#   [--database <database>]
#   [--api-key <api-key>]
```

**Flags:**
- `--collection` (**required**, `string`) — collection name
- `--data` (`array`) — entities as JSON array or file://path.json
- `--partition` (`string`) — partition name
- `--database` (`string`) — database name
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### Search — Search for similar vectors.

```bash
zilliz vector search --collection <collection> --data <data-json-array>
#   [--anns-field <anns-field>]
#   [--limit <limit>  # default: 10]
#   [--filter <filter>]
#   [--output-fields <output-fields-json-array>]
#   [--database <database>]
#   [--api-key <api-key>]
```

**Flags:**
- `--collection` (**required**, `string`) — collection name
- `--data` (**required**, `array`) — query vectors as JSON array
- `--anns-field` (`string`) — vector field to search on
- `--limit` (`integer`, default `10`) — max results to return
- `--filter` (`string`) — scalar filter expression
- `--output-fields` (`array`) — fields to return as JSON array
- `--database` (`string`) — database name
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### Hybrid Search — Perform hybrid search with multiple vectors and reranking.

```bash
zilliz vector hybrid-search --collection <collection>
#   [--search <search-json-array>]
#   [--rerank <rerank>]
#   [--limit <limit>  # default: 10]
#   [--output-fields <output-fields-json-array>]
#   [--database <database>]
#   [--api-key <api-key>]
```

**Flags:**
- `--collection` (**required**, `string`) — collection name
- `--search` (`array`) — search requests as JSON array (unless --body)
- `--rerank` (`object`) — reranking strategy as JSON (unless --body)
- `--limit` (`integer`, default `10`) — max results to return
- `--output-fields` (`array`) — fields to return as JSON array
- `--database` (`string`) — database name
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### Query — Query entities by scalar filter expression.

```bash
zilliz vector query --collection <collection> --filter <filter>
#   [--limit <limit>  # default: 10]
#   [--output-fields <output-fields-json-array>]
#   [--database <database>]
#   [--api-key <api-key>]
```

**Flags:**
- `--collection` (**required**, `string`) — collection name
- `--filter` (**required**, `string`) — scalar filter expression
- `--limit` (`integer`, default `10`) — max results to return
- `--output-fields` (`array`) — fields to return as JSON array
- `--database` (`string`) — database name
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### Get — Get entities by primary key IDs.

```bash
zilliz vector get --collection <collection> --id <id-json-array>
#   [--output-fields <output-fields-json-array>]
#   [--database <database>]
#   [--api-key <api-key>]
```

**Flags:**
- `--collection` (**required**, `string`) — collection name
- `--id` (**required**, `array`) — primary key IDs as JSON array
- `--output-fields` (`array`) — fields to return as JSON array
- `--database` (`string`) — database name
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

### Delete — Delete entities by filter expression.

```bash
zilliz vector delete --collection <collection> --filter <filter>
#   [--partition <partition>]
#   [--database <database>]
#   [--api-key <api-key>]
```

**Flags:**
- `--collection` (**required**, `string`) — collection name
- `--filter` (**required**, `string`) — filter expression for entities to delete
- `--partition` (`string`) — partition name
- `--database` (`string`) — database name
- `--api-key` (`string`, env `ZILLIZ_API_KEY`) — API key (overrides env/config)

## Live help

```bash
zilliz vector --help
```

Destructive operations (`delete`, `drop`, `restore`) require explicit user confirmation before execution.
