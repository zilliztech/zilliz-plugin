#!/usr/bin/env python3

import json
import re
import sys
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parents[1]
MANIFEST_PATH = REPO_ROOT / ".codex-plugin" / "plugin.json"
SKILLS_PATH = REPO_ROOT / "skills"
SEMVER_PATTERN = re.compile(r"^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-[0-9A-Za-z.-]+)?(?:\+[0-9A-Za-z.-]+)?$")
FORBIDDEN_RUNTIME_PATTERNS = {
    "Claude Code": re.compile(r"Claude Code", re.IGNORECASE),
    "Claude slash command": re.compile(r"/zilliz:", re.IGNORECASE),
    "Claude user configuration": re.compile(r"\$\{user_config\.", re.IGNORECASE),
    "undeclared Inkeep MCP dependency": re.compile(r"mcp__inkeep|Inkeep MCP", re.IGNORECASE),
    "legacy Zilliz MCP server": re.compile(r"zilliz-mcp-server", re.IGNORECASE),
}
FORBIDDEN_PLUGIN_PATHS = (
    REPO_ROOT / ".claude-plugin",
    REPO_ROOT / ".agents",
    REPO_ROOT / "commands",
    REPO_ROOT / "plugins",
    REPO_ROOT / ".mcp.json",
    REPO_ROOT / ".app.json",
)


def fail(message: str) -> None:
    print(f"ERROR: {message}", file=sys.stderr)
    raise SystemExit(1)


def require_mapping_value(mapping: dict, key: str, context: str) -> object:
    value = mapping.get(key)
    if value in (None, "", [], {}):
        fail(f"{context}.{key} must be set")
    return value


def validate_manifest() -> str:
    if not MANIFEST_PATH.is_file():
        fail(f"missing manifest: {MANIFEST_PATH.relative_to(REPO_ROOT)}")

    try:
        manifest = json.loads(MANIFEST_PATH.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        fail(f"invalid manifest: {exc}")

    for key in ("name", "version", "description", "skills", "author", "interface"):
        require_mapping_value(manifest, key, "plugin")

    if manifest["name"] != "zilliz":
        fail("plugin.name must be 'zilliz'")
    if not SEMVER_PATTERN.fullmatch(str(manifest["version"])):
        fail("plugin.version must use semantic versioning")
    if manifest["skills"] != "./skills/":
        fail("plugin.skills must be './skills/'")
    if "[TODO:" in json.dumps(manifest):
        fail("manifest contains a TODO placeholder")

    author = manifest["author"]
    if not isinstance(author, dict):
        fail("plugin.author must be an object")
    require_mapping_value(author, "name", "plugin.author")

    interface = manifest["interface"]
    if not isinstance(interface, dict):
        fail("plugin.interface must be an object")
    for key in ("displayName", "shortDescription", "category"):
        require_mapping_value(interface, key, "plugin.interface")

    return str(manifest["version"])


def validate_skills() -> int:
    if not SKILLS_PATH.is_dir():
        fail("missing skills directory")

    skill_directories = sorted(path for path in SKILLS_PATH.iterdir() if path.is_dir())
    if not skill_directories:
        fail("the plugin must contain at least one skill")

    seen_names: set[str] = set()
    for skill_directory in skill_directories:
        skill_file = skill_directory / "SKILL.md"
        if not skill_file.is_file():
            fail(f"missing {skill_file.relative_to(REPO_ROOT)}")

        content = skill_file.read_text(encoding="utf-8")
        if not content.startswith("---\n"):
            fail(f"{skill_file.relative_to(REPO_ROOT)} must start with YAML frontmatter")

        closing_marker = content.find("\n---\n", 4)
        if closing_marker < 0:
            fail(f"{skill_file.relative_to(REPO_ROOT)} has unterminated YAML frontmatter")

        frontmatter = content[4:closing_marker]
        name_match = re.search(r"(?m)^name:\s*([^\s#]+)\s*$", frontmatter)
        description_match = re.search(r"(?m)^description:\s*(.+)$", frontmatter)
        if not name_match or not description_match:
            fail(f"{skill_file.relative_to(REPO_ROOT)} requires name and description")

        skill_name = name_match.group(1)
        if skill_name != skill_directory.name:
            fail(f"skill name '{skill_name}' must match directory '{skill_directory.name}'")
        if skill_name in seen_names:
            fail(f"duplicate skill name: {skill_name}")
        seen_names.add(skill_name)

        for label, pattern in FORBIDDEN_RUNTIME_PATTERNS.items():
            if pattern.search(content):
                fail(f"{skill_file.relative_to(REPO_ROOT)} contains {label}")

    return len(skill_directories)


def validate_release_tree() -> None:
    for forbidden_path in FORBIDDEN_PLUGIN_PATHS:
        if forbidden_path.exists():
            fail(f"unsupported OpenAI release path exists: {forbidden_path.relative_to(REPO_ROOT)}")


def main() -> None:
    version = validate_manifest()
    skill_count = validate_skills()
    validate_release_tree()
    print(f"Validated Zilliz OpenAI plugin v{version} with {skill_count} skills.")


if __name__ == "__main__":
    main()
