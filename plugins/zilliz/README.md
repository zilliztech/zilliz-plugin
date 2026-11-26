# Zilliz Cloud

Manage [Zilliz Cloud](https://zilliz.com/) clusters, Milvus vector collections, hybrid search, RBAC, backups, volumes, and bulk data imports through natural language using `zilliz-cli`.

## What You Can Do

- **Provision and scale clusters**: Create Serverless, Dedicated, Free, or Vector Lake on-demand clusters, check available regions and Milvus versions, suspend, resume, or resize compute units.
- **Operate collections and search**: Create schemas and AutoIndex indexes, load/release collections and partitions, and run dense, sparse, or hybrid vector search and filtered queries.
- **Stage and import bulk data**: Create managed Volumes or connect AWS S3 / GCS / Azure Blob storage integrations, upload datasets, start import jobs, and track async job progress.
- **Diagnostics, monitoring, and governance**: Run read-only health and latency diagnostics, inspect cluster and per-collection metrics, manage backups and restore policies, configure cloud-level ACL and Milvus RBAC, and review billing usage.
- **Architecture and pricing guidance**: Plan capacity (CU vs vCU), design multi-tenant schemas, and generate production SDK code (`pymilvus`, Java, Go, Node.js, REST) with the `ask-zilliz` skill.

## Prerequisites

1. **Zilliz Cloud account**: Sign up and sign in at least once at [cloud.zilliz.com](https://cloud.zilliz.com) to initialize your account and default organization (no credit card required for a Free cluster).
2. **`zilliz-cli` (`zilliz` >= 2.0.5)**:
   - Ask your agent to run the **`quickstart`** or **`setup`** skill (which uses the audited local installer bundled with this plugin and verifies SHA-256 checksums against `sha256sums.txt`; Windows ARM64 runs via x64 emulation), or install manually via `uv tool install zilliz-cli` or [Zilliz CLI Releases](https://github.com/zilliztech/zilliz-cli/releases).
3. **Interactive authentication**:
   - In your own terminal, run `zilliz login` (browser OAuth, recommended) or `zilliz login --api-key` (or set `ZILLIZ_API_KEY`).
   - For security, interactive login commands run in your terminal -- never paste API keys directly into chat.

## Getting Started

Try one of these prompts right after enabling the plugin:

1. `"Set up zilliz-cli, check my authentication status, and select a Zilliz Cloud cluster"`
2. `"Show the status of my Zilliz Cloud clusters, databases, and collections"`
3. `"Diagnose slow queries or high latency on my active Zilliz Cloud cluster"`
4. `"Create a serverless cluster in aws-us-east-1, create a 768-dim collection with COSINE metric, and run a test vector search"`

## Included Skills (24)

| Category | Skills |
|---|---|
| **Onboarding & Assistant** | `quickstart`, `setup`, `status`, `ask-zilliz` |
| **Clusters & Projects** | `cluster`, `on-demand-cluster`, `project-region`, `privatelink` |
| **Collections & Vector Data** | `database`, `collection`, `external-collection`, `index`, `partition`, `vector` |
| **Data Staging & Import** | `volume`, `storage-integration`, `import`, `job` |
| **Operations, Security & Billing** | `diagnose`, `monitoring`, `backup`, `acl`, `user-role`, `billing` |

## Documentation & Support

- **Documentation**: [docs.zilliz.com](https://docs.zilliz.com)
- **CLI Reference**: [docs.zilliz.com/reference/cli/overview](https://docs.zilliz.com/reference/cli/overview)
- **Installation Guide**: [github.com/zilliztech/zilliz-plugin#installation](https://github.com/zilliztech/zilliz-plugin#installation)
- **Source Repository**: [github.com/zilliztech/zilliz-plugin](https://github.com/zilliztech/zilliz-plugin)
- **Support**: [support.zilliz.com](https://support.zilliz.com) | [support@zilliz.com](mailto:support@zilliz.com)
- **License**: Apache-2.0
