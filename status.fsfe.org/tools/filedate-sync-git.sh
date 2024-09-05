#!/usr/bin/env bash
set -euo pipefail

# Makes all access/modified file dates in the whole repository match with the file's last git commit date
# This is important because Make is based on file timestamps, not git commits

# We have the -z flag so that git does not replace unicode chars with escape codes, and quote the filenames
# This also uses null bytes instead of newlines, so we swap them
files=$(git ls-files -z "$(git rev-parse --show-toplevel)" | sed 's/\x0/\n/g')

total=$(echo "$files" | wc -l)
i=1
echo "$files" | while read -r file; do
  echo "[${i}/${total}] $file" 
  # TODO the line directly below this is because after moving main website to fsfe.org dir the translation status
  # stuff based on dates became a bit useless.
  # So we use the second to last commit date for every file.
  # after 6 months or so (february 2025) remove the line below with --follow in it, and uncomment the touch underneath it
  # TLDR: If after February 2025 remove line directly below this, containign follow and uncomment the touch line below that, 
  # without a follow. Please also remove this comment then
  touch -a -m --date="@$(git log --pretty="%ct" --follow -2 "$file"| tail -n1)" "$file"
  # touch -a -m --date="@$(git log --pretty="%ct" -1 "$file")" "$file"
  ((i++))
done
