#!/usr/bin/env bash

# Makes all access/modified file dates in the whole repository match with the file's last git commit date
# This is important because Make is based on file timestamps, not git commits

total=$(git ls-files "$(git rev-parse --show-toplevel)" | wc -l)
i=1
for f in $(git ls-files "$(git rev-parse --show-toplevel)"); do
  echo "[${i}/${total}] $f" 
  # TODO the line directly below this is because after moving main website to fsfe.org dir the translation status
  # stuff based on dates became a bit useless.
  # So we use the second to last commit date for every file.
  # after 6 months or so (february 2025) remove the line below with --follow in it, and uncomment the touch underneath it
  # TLDR: If after February 2025 remove line directly below this, containign follow and uncomment the touch line below that, 
  # without a follow. Please also remove this comment then
  touch -a -m --date="@$(git log --pretty="%ct" --follow -2 "$f"| tail -n1)" "$f"
  # touch -a -m --date="@$(git log --pretty="%ct" -1 "$f")" "$f"
  ((i++))
done
