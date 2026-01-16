# Milvus MCP Server

Official MCP (Model Context Protocol) server for [Milvus](https://milvus.io/) and [Zilliz Cloud](https://zilliz.com/), enabling Claude Code to interact with Milvus vector databases.

## Installation

```bash
pip install milvus-mcp
```

## Usage

> TODO: Add usage instructions after design is finalized

## Development

### Setup

```bash
# Clone the repository
git clone https://github.com/zilliztech/milvus-plugin.git
cd milvus-plugin

# Create virtual environment
python -m venv .venv
source .venv/bin/activate  # On Windows: .venv\Scripts\activate

# Install dependencies
pip install -e ".[dev]"
```

### Testing

```bash
pytest
```

### Linting

```bash
ruff check .
ruff format .
mypy src/
```

## License

Apache License 2.0 - see [LICENSE](LICENSE) for details.
