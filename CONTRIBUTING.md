# Contributing to Milvus MCP Server

Thank you for your interest in contributing!

## Development Setup

1. Fork and clone the repository
2. Create a virtual environment: `python -m venv .venv`
3. Activate: `source .venv/bin/activate`
4. Install dev dependencies: `pip install -e ".[dev]"`

## Code Style

- Use [ruff](https://github.com/astral-sh/ruff) for linting and formatting
- Run `ruff check .` and `ruff format .` before committing
- Use type hints and run `mypy src/` for type checking

## Pull Request Process

1. Create a feature branch from `main`
2. Make your changes with clear commit messages
3. Ensure all tests pass: `pytest`
4. Submit a PR with a clear description

## Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` new feature
- `fix:` bug fix
- `docs:` documentation
- `refactor:` code refactoring
- `test:` adding tests
- `chore:` maintenance

## Questions?

Open an issue or discussion if you have questions.
