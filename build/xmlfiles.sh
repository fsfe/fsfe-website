#!/bin/sh

inc_xmlfiles=true

unicat(){
  # convert XML files to UTF-8
  for file in "$@"; do
    enc="$(sed -nr 'bA; :Q q; :A s:^.*<\?.*encoding="([^"]+)".*$:\1:p; tQ' "$file")"
    iconv -f "${enc:-UTF-8}" -t "UTF-8" "$file"
  done
}

include_xml(){
  # include second level elements of a given XML file
  # this emulates the behaviour of the original
  # build script which wasn't able to load top
  # level elements from any file
  file="$1"

  if [ -f "$file" ]; then
    unicat "$file" \
    | sed -r ':X; $bY; N; bX; :Y;
              s:<(\?[xX][mM][lL]|!DOCTYPE)[[:space:]]+[^>]+>::g
              s:<[^!][^>]*>::;
              s:</[^>]*>([^<]*((<[^>]+/>|<!([^>]|<[^>]*>)*>|<\?[^>]+>)[^<]*)*)?$:\1:;'
  fi
}

get_attributes(){
  # get attributes of top level element in a given
  # XHTML file
  file="$1"

  sed -rn ':X; N; $!bX;
           s;^.*<[\n\t\r ]*([xX]|[xX]?[hH][tT])[mM][lL][\n\t\r ]+([^>]*)>.*$;\2;p' \
    "$file"
}

