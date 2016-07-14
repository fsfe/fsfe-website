#!/bin/bash
# This file takes a .pot file and makes the xhtml
set -e
set -o pipefail

which html2po

dirname="$(dirname $1)"
pofile="$1"
lang="$(expr match "$pofile" ".*\.\(.*\)\.po")"
translated_xhtml="${dirname}/$(basename "$pofile" .po).xhtml"
original_xhtml="${dirname}/$(basename "$pofile" ".${lang}.po").en.xhtml"
po2html -t "${original_xhtml}" "${pofile}" "${translated_xhtml}"
