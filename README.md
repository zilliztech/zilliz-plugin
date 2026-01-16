# Milvus Plugin for Claude Code

Official [Claude Code](https://claude.ai/code) plugin for [Milvus](https://milvus.io/) and [Zilliz Cloud](https://zilliz.com/), enabling seamless vector database operations within your AI-assisted development workflow.

## Features

- **Collection Management** - Create, list, describe, and drop collections
- **Vector Operations** - Insert, search, query, and delete vectors
- **Index Management** - Create and manage vector indexes
- **Zilliz Cloud Support** - Full support for Zilliz Cloud managed service

## Installation

```bash
# Add the marketplace
/plugin marketplace add zilliztech/milvus-plugin

# Install the plugin
/plugin install milvus@zilliztech
```

## Configuration

Set these environment variables before using the plugin:

```bash
# For Zilliz Cloud
export MILVUS_URI="https://your-instance.zillizcloud.com"
export MILVUS_TOKEN="your-api-token"

# For local Milvus
export MILVUS_URI="http://localhost:19530"
```

## Commands

| Command | Description |
|---------|-------------|
| `/milvus:quickstart` | Initialize Milvus/Zilliz Cloud integration |
| `/milvus:query` | Query vectors in a collection |
| `/milvus:help` | Show help information |

## Usage Examples

```
# Initialize connection
/milvus:quickstart

# Search for similar vectors
/milvus:query
```

## Development

### Setup

```bash
git clone https://github.com/zilliztech/milvus-plugin.git
cd milvus-plugin

python -m venv .venv
source .venv/bin/activate
pip install -e ".[dev]"
```

### Testing

```bash
pytest
```

## License

Apache License 2.0 - see [LICENSE](LICENSE) for details.
