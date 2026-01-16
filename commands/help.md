---
description: "Show help for Milvus plugin commands and tools"
---

Display help information for the Milvus plugin.

## Available Commands

- `/milvus:quickstart` - Initialize Milvus/Zilliz Cloud integration
- `/milvus:query` - Query vectors in a collection
- `/milvus:help` - Show this help message

## MCP Tools

The plugin provides MCP tools for:
- Collection management (list, create, describe, drop)
- Vector operations (insert, search, query, delete)
- Index management (create, describe)

## Configuration

Set these environment variables:
- `MILVUS_URI` - Milvus/Zilliz Cloud endpoint
- `MILVUS_TOKEN` - API token (required for Zilliz Cloud)

## Resources

- Milvus Documentation: https://milvus.io/docs
- Zilliz Cloud: https://cloud.zilliz.com
- GitHub: https://github.com/zilliztech/milvus-plugin
