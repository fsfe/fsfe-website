#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Select files
#FILES=$(git grep -i -l "<\?xml.*encoding=\"iso" .)
FILES=$(find . -type f)

while read -r file; do
  enc=$(file --mime-encoding ${file} | cut -d" " -f2)
  # Only run if not correct encoding, and if XML, XHTML, or XSL file
  if [ "${enc}" != "utf-8" ] && [ "${enc}" != "us-ascii" ] && [ $(echo $file | grep -qoE "(\.xml$|\.xhtml$|\.xsl$)"; echo $?) -eq 0 ]; then
    # Only run if file is not outdated
    trstatus=$(tools/check-translation-status.sh -f "$file" -q; echo $?)
    if [ $trstatus = 0 ]; then
      # Convert to UTF-8
      iconv -f ${enc} -t UTF-8 ${file} -o ${file}.utf8
      # Replace XML encoding in first line
      sed -Ei "s@^<\?xml.*($enc|iso-8859-1|iso-8859-2|iso8859-1).*@<?xml version=\"1.0\" encoding=\"UTF-8\" ?>@I" ${file}.utf8
      # Move edited file to original location
      mv ${file}.utf8 ${file}
      # Status report
      enc_new=$(file --mime-encoding ${file} | cut -d" " -f2)
      echo "Converted $file from $enc to $enc_new"
    elif [ $trstatus = 1 ]; then
      echo "WARNING: $file is outdated"
    fi
  fi
done <<< "${FILES}"
