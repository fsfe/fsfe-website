#!/bin/bash
# This file takes a .pot file and makes the xhtml
i10ndirname="$(dirname $1)"
pofile="$1"
lang="$(expr match "$pofile" ".*\.\(.*\)\.po")"
translated_xhtml="${i10ndirname#*/*/}/$(basename "$pofile" .po).xhtml"
original_xhtml="${i10ndirname#*/*/}/$(basename "$pofile" ".${lang}.po").en.xhtml"
po2html -t "${original_xhtml}" "${pofile}" "${translated_xhtml}"
