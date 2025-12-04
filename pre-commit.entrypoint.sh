#!/usr/bin/env bash
set -euo pipefail

# Get the changed files
target_branch="${1:-master}"
source_branch="$(git rev-parse --abbrev-ref HEAD)"
files_args=""

for file in git diff --name-only "$source_branch" "$target_branch"; do
	if [ -f "$file" ]; then
		files_args+="--file $file "
	fi
done

# run pre-commit
#shellcheck disable=2086 # We want to expand the string as args
uv run lefthook run pre-commit $files_args
uv run lefthook run ci-checks
