# Onboarding, Capacity Estimation & Troubleshooting Quick Reference

Detailed reference tables for Beginner onboarding, first-app SDK setup, Dedicated CU capacity estimation, common errors, and migrations.

---

## 1. Beginner Path: "What is Zilliz Cloud?"

For users new to vector databases, explain concepts before products.

### What is a Vector Database?

A vector database stores data as high-dimensional vectors (lists of numbers) that capture semantic meaning. Instead of matching exact keywords, you search by meaning -- "find items similar to this."

**Common use cases**: semantic search, RAG (retrieval-augmented generation), recommendation systems, image/audio similarity, anomaly detection.

### Why Zilliz Cloud?

- **Fully managed Milvus** -- no infrastructure to maintain
- **Scales from free to billions of vectors**
- **Built-in embedding & reranking functions** -- optional server-side text-to-vector pipelines
- **Multi-language SDKs**: Python, Java, Go, Node.js, REST API, plus `zilliz-cli`
- **Enterprise-grade**: encryption, RBAC, backup, PrivateLink, global replication

### Recommended First Steps

1. **Sign up** at [cloud.zilliz.com](https://cloud.zilliz.com) (no credit card required)
2. **Create a Free cluster** (5GB, GCP us-west1) for learning and prototyping
3. **Use trial credits** -- new accounts receive trial credits to test Dedicated clusters
4. **Follow the Quickstart** at [docs.zilliz.com/docs/quick-start](https://docs.zilliz.com/docs/quick-start)

### Key Concepts for Beginners

| Concept | Analogy |
| --- | --- |
| **Collection** | A table in a traditional database |
| **Entity** | A row -- one data record with scalar and vector fields |
| **Vector field** | A column storing semantic meaning as an array of floats/ints |
| **Index** | Zilliz Cloud uses AutoIndex to automatically build the optimal index |
| **Metric type** | How similarity is measured (`COSINE` for text, `L2` for images, `IP` for inner product) |
| **Schema** | The blueprint defining the fields of a collection |

---

## 2. Getting Started: First App, SDKs & AI Agent Tooling

### Connect & Create Collection (Python Quickstart)

```python
from pymilvus import MilvusClient

client = MilvusClient(
    uri="YOUR_CLUSTER_ENDPOINT",
    token="YOUR_API_KEY",
)

# Quick create -- auto schema + AutoIndex
client.create_collection(
    collection_name="my_docs",
    dimension=768,
    metric_type="COSINE",
)
```

### Schema Design Quick Reference

| Use Case | Key Decisions |
| --- | --- |
| RAG | `auto_id=True`, `COSINE` metric, `text` + `source` fields |
| E-commerce | Scalar index on `category` / `price` filters |
| Multi-tenant | `partition_key` on tenant ID for isolation and faster filtered scans |
| Image search | `L2` metric |
| Hybrid search | Dense + sparse vectors, or dense + BM25 function. **Ranker: use `RRFRanker(k=60)` or `WeightedRanker(0.7, 0.3)` from `pymilvus` -- NEVER use `Function(FunctionType.RERANK)`** |
| Full-text search | BM25 function on `VARCHAR` text field |

### Official SDKs & Tools

| Language / Tool | Package / Repo | Docs |
| --- | --- | --- |
| Python | `pymilvus` | [Python SDK](https://docs.zilliz.com/reference/python) |
| Java | `milvus-sdk-java` | [Java SDK](https://docs.zilliz.com/reference/java) |
| Go | `milvus/client/v2` | [Go SDK](https://docs.zilliz.com/reference/go) |
| Node.js | `@zilliz/milvus2-sdk-node` | [Node.js SDK](https://docs.zilliz.com/reference/nodejs) |
| REST | cURL / any HTTP client | [RESTful API](https://docs.zilliz.com/reference/restful) |
| CLI | `zilliz-cli` (`zilliz`) | [CLI Overview](https://docs.zilliz.com/reference/cli/overview) |
| AI Coding Agents | `zilliztech/zilliz-plugin` | Google Antigravity, Claude Code, OpenAI Codex (`zilliz-cli` + Skills; replaces legacy unmaintained `zilliz-mcp-server`) |
| Terraform | `zillizcloud` provider | [Terraform Provider](https://docs.zilliz.com/docs/terraform-provider) |

---

## 3. Dedicated Cluster Sizing & Capacity Estimation

### Dedicated Cluster Types (768-dim baseline)

| Type | Data Factor | Typical QPS / Replica | Typical Latency | Best For |
| --- | --- | --- | --- | --- |
| Performance-optimized | 1.5M per CU | 500-1500 | ~10ms | Real-time low-latency search |
| Capacity-optimized | 5M per CU | 100-300 | 50-100ms | Cost-efficient large datasets |
| Tiered-storage | 20M per CU | 100-150 | 20-40ms (hot) | Massive datasets with hot/warm/cold access |

### Capacity Estimation Formula

```text
Equivalent_M = Entities_M * (Dim / 768)
Data_CU      = ROUNDUP(Equivalent_M / Data_Factor)
Replica      = MAX(1, ROUNDUP(Target_QPS / QPS_per_Replica))
Total_CU     = Replica * Data_CU
Monthly_Est  = Total_CU * Hourly_CU_Rate * 730 + Storage_GB * Monthly_Storage_Rate
```

**Worked Example**: 100M vectors, 768-dim, 500 QPS, Performance-optimized

```text
Data_CU  = ROUNDUP(100 * (768 / 768) / 1.5) = 67 CU
Replica  = ROUNDUP(500 / 1000)              = 1
Total_CU = 67 CU
Monthly  ~ 67 * Hourly_Rate * 730 + Storage (verify current rates on official pricing page)
```

Always include the pricing disclaimer linking to [Pricing Calculator](https://zilliz.com/pricing#calculator) and [Price List](https://zilliz.com/pricing/pricing-guide).

---

## 4. Performance Quick Fixes & Common Errors

### Performance Quick Fixes

| Problem | Quick Fix |
| --- | --- |
| Slow search | Verify collection is loaded; use `partition_key` for multi-tenant filters; check CU utilization |
| Cold start | Call `client.load_collection()` before serving traffic |
| Slow inserts | Batch inserts (`batch_size=5000`); use Volume + bulk import for >100K entities |
| Latency spikes | Inspect cluster/collection metrics (`diagnose` / `monitoring` skills) and consider scaling CUs or replicas |

### Common Errors

| Error | Cause | Solution |
| --- | --- | --- |
| Connection refused | Missing `https://` or wrong port | Check endpoint format and cloud gRPC port (`references/cloud-regions.md`) |
| Dimension mismatch | Vector length differs from schema `dim` | Verify embedding model output dimensions |
| `node not match` | Cluster scaling or rolling update in progress | Retry after 2-5 seconds |
| `nq too large` | Query batch limit exceeded | Split search vectors into smaller batches |
| Auth failed | Invalid/expired token or wrong format | Verify API key or `user:password` credentials |

---

## 5. Migration Overview

Use Zilliz Cloud **Data Import** / migration tools for supported sources (Pinecone, Qdrant, Elasticsearch, pgvector, self-hosted Milvus).

For self-hosted Milvus -> Zilliz Cloud:
- **Backup file migration**: export Milvus backup -> upload to Zilliz Cloud Volume -> restore
- **Milvus Endpoint migration**: live migration supporting Milvus 2.6 types (Geometry, Struct)

Docs: [docs.zilliz.com/docs/migrations](https://docs.zilliz.com/docs/migrations)
