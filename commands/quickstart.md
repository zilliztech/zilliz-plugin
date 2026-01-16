---
description: "Initialize a new project with Milvus/Zilliz Cloud integration"
---

Help the user set up Milvus or Zilliz Cloud integration for their project.

## Steps

1. Check if MILVUS_URI and MILVUS_TOKEN environment variables are set
2. If not configured, guide the user to:
   - For Zilliz Cloud: Get credentials from https://cloud.zilliz.com
   - For local Milvus: Use `MILVUS_URI=http://localhost:19530`
3. Test the connection using the `list_collections` MCP tool
4. Show available collections or guide to create one
