#!/bin/bash

file=$1
basedir=$(dirname "$(dirname "$(realpath "$0")")")

# Get file extension
ext="${file##*.}"

# remove "en.$ext"
base=$(echo "${file}" | sed -E "s/\.[a-z][a-z]\.${ext}//")
# get change date of English file
en="${base}".en."${ext}"
envers=$(xsltproc "${basedir}"/build/xslt/get_version.xsl "${en}")

enxml=$(python3 "${basedir}"/tools/compare-xml-structure.py "${en}")
#enxml="${enxml//translator/}"

for i in "${base}".[a-z][a-z]."${ext}"; do
  if [[ $i != *".en."* ]]; then
    # get version of translation
    trvers=$(xsltproc "${basedir}"/build/xslt/get_version.xsl "${i}")
    # only execute check if version number identical
    if [ "${trvers:-0}" -eq "${envers:-0}" ]; then
      trxml=$(python3 "${basedir}"/tools/compare-xml-structure.py "${i}")
      trxml="${trxml//translator/}"

      diff="$(diff -B <(echo "$enxml") <(echo "$trxml"))"
      #diff="$(comm --nocheck-order -1 -3 <(echo "$enxml") <(echo "$trxml"))"

      #diff="$(sed -e 's/translator//g' <<< "$diff")"

      if [[ -n $diff ]]; then
        #echo "$diff"
        diff=$(echo "$diff" | grep -E "(<|>)" | sed  s/..//)
        echo "${i}: $(paste -s -d ' ' <<< "$diff")"
      fi
    fi
  fi
done
