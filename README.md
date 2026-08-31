# Zilliz Plugin for OpenAI

This branch contains the skills-only Zilliz plugin prepared for the public plugin directory shared by ChatGPT and Codex. It teaches an agent to operate the [`zilliz-cli`](https://github.com/zilliztech/zilliz-cli) for cluster management, collection operations, vector search, backups, monitoring, billing, and access control.

## Repository layout

```text
.codex-plugin/plugin.json       Plugin manifest
skills/                         Runtime skills included in the release archive
scripts/                        Validation and packaging utilities
docs/openai-submission/         Public submission copy and test cases
.github/workflows/              Validation and release automation
```

Only `.codex-plugin/` and `skills/` are copied into the release archive. Submission documentation, automation, and repository metadata are never included.

## Requirements

- A [Zilliz Cloud](https://cloud.zilliz.com/) account or a compatible local Milvus environment.
- `zilliz-cli`, installed by following the `quickstart` or `setup` skill.
- Authentication configured in the user's own terminal. Credentials must never be committed to this repository or pasted into an agent conversation.

## Validate and package

```bash
python3 scripts/validate_openai_plugin.py
scripts/package_openai_plugin.sh
```

The packaging command writes a versioned ZIP archive and checksum to `dist/`:

```text
dist/zilliz-openai-plugin-v<version>.zip
dist/zilliz-openai-plugin-v<version>.zip.sha256
```

The ZIP has a single top-level `zilliz/` directory containing the manifest and skills.

## Release process

1. Update skills and public submission materials.
2. Update the semantic version in `.codex-plugin/plugin.json`.
3. Run validation and inspect the generated ZIP locally.
4. Push the branch for continuous validation.
5. Tag the release as `openai-v<version>` to create a GitHub release with the ZIP and checksum.
6. Upload the ZIP to the OpenAI plugin submission portal and complete the review form.

## Submission materials and secrets

Public, reusable submission copy lives in `docs/openai-submission/`. Reviewer credentials, API keys, tokens, real resource identifiers, business verification documents, and partner correspondence must be entered directly in the OpenAI submission portal or stored in an approved secret manager. Do not add them to this repository, even in ignored files.

## License

Apache License 2.0
