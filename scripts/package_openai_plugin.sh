#!/usr/bin/env bash

set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
manifest_path="$repo_root/.codex-plugin/plugin.json"
dist_dir="$repo_root/dist"
staging_dir=$(mktemp -d)

cleanup() {
  rm -rf "$staging_dir"
}
trap cleanup EXIT

python3 "$repo_root/scripts/validate_openai_plugin.py"

version=$(python3 -c 'import json, sys; print(json.load(open(sys.argv[1], encoding="utf-8"))["version"])' "$manifest_path")
archive_name="zilliz-openai-plugin-v${version}.zip"
archive_path="$dist_dir/$archive_name"

mkdir -p "$dist_dir" "$staging_dir/zilliz"
cp -R "$repo_root/.codex-plugin" "$staging_dir/zilliz/.codex-plugin"
cp -R "$repo_root/skills" "$staging_dir/zilliz/skills"

find "$staging_dir" -name '.DS_Store' -delete
rm -f "$archive_path" "$archive_path.sha256"

(
  cd "$staging_dir"
  zip -X -q -r "$archive_path" zilliz
)

if command -v sha256sum >/dev/null 2>&1; then
  (
    cd "$dist_dir"
    sha256sum "$archive_name" > "$archive_name.sha256"
  )
else
  (
    cd "$dist_dir"
    shasum -a 256 "$archive_name" > "$archive_name.sha256"
  )
fi

printf 'Created %s\n' "$archive_path"
printf 'Created %s\n' "$archive_path.sha256"
