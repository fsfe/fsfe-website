#!/bin/bash

#FILES=$(git grep -i -l "<\?xml.*encoding=\"iso" .)
FILES=$(find . -type f)

while read -r file; do
  enc=$(file --mime-encoding ${file} | cut -d" " -f2)
  if [ "${enc}" != "utf-8" ] && [ "${enc}" != "us-ascii" ] && [ $(echo $file | grep -qoE "(\.xml$|\.xhtml$|\.xsl$)"; echo $?) -eq 0 ]; then
    iconv -f ${enc} -t UTF-8 ${file} -o ${file}.utf8
    sed -Ei "s@(<?xml.*)($enc|iso-8859-1|iso-8859-2|iso8859-1)@\1UTF-8@I" ${file}.utf8
    mv ${file}.utf8 ${file}
    enc_new=$(file --mime-encoding ${file} | cut -d" " -f2)
    echo "Converted $file from $enc to $enc_new"
  fi
done <<< "${FILES}"
