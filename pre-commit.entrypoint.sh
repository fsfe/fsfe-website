#!/usr/bin/env bash
set -euo pipefail

# Get the changed files
target_branch="${1:-master}"
source_branch="$(git rev-parse --abbrev-ref HEAD)"
files="$(git diff --name-only "$source_branch" "$target_branch")"
files_args=""
for file in $files; do
	files_args+="--file $file "
done

# run pre-commit
uv run lefthook run pre-commit "$files_args"
