#!/usr/bin/env bash

# Makes all access/modified file dates in the whole repository match with the file's last git commit date
# This is important because Make is based on file timestamps, not git commits

total=$(git ls-files $(git rev-parse --show-toplevel) | wc -l)
i=1
for f in $(git ls-files $(git rev-parse --show-toplevel)); do
  echo "[${i}/${total}] $f" 
  touch -a -m --date="@$(git log --pretty="%ct" -1 "$f")" "$f"
  ((i++))
done
