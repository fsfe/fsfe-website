#!/usr/bin/env bash

set -euo pipefail

# Check is there are any frontpage news items that do not have an english translation
#

# select all items which have the front-page tag
exit=0
matched_files="$(grep "<tag.*front-page" --files-with-matches "$@" || true)"

for file in $matched_files; do
	base="${file%.*}"  # file.xx
	base="${base%.*}"  # file
	sfx=${file##*.}    # xhtml
	en="$base.en.$sfx" # file.en.xhtml
	if [[ ! -f "$en" ]]; then
		echo "$file has no english version"
		exit=1
	fi
done

exit $exit
