#!/usr/bin/env bash

set -euo pipefail

# =============================================================================
# Check dependencies
# =============================================================================

deperrors=''
for depend in xmllint find cat read wc; do
	if ! command -v "$depend" >/dev/null 2>&1; then
		deperrors="$depend $deperrors"
	fi
done
if [ -n "$deperrors" ]; then
	cat <<-EOF
		The githook script depends on some other programs to function. Not all of
		those programs could be located on your system. Please use your package
		manager to install the following programs: $deperrors

	EOF
	exit 1
fi >>/dev/stderr
all_files="$(find . -type f \( -iname "*\.xml" -o -iname "*\.xsl" -o -iname "*\.xhtml" \))"
style_class_files="$(
	echo "$all_files" | while read -r file; do
		if xmllint --xpath "//style" "${file}" &>/dev/null; then
			echo "$file"
		fi
	done
)"
style_attribute_files="$(
	echo "$all_files" | while read -r file; do
		if xmllint --xpath "//@style" "${file}" &>/dev/null; then
			echo "$file"
		fi
	done
)"
cat <<-EOF
	The following files contain <style> class:
	$style_class_files
	$(echo "$style_class_files" | wc -l) files contain style class

	--------------------------------------------

	The following files contain style attributes:
	$style_attribute_files
	$(echo "$style_attribute_files" | wc -l) files contain style attribute
EOF
