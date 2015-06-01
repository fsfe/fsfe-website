#!/bin/sh

inc_xmlfiles=true

include_xml(){
  # include second level elements of a given XML file
  # this emulates the behaviour of the original
  # build script which wasn't able to load top
  # level elements from any file
  file="$1"

  if [ -f "$file" ]; then
    # guess encoding from xml header
    # we will convert everything to utf-8 prior to processing
    enc="$(sed -nr 's:^.*<\?.*encoding="([^"]+)".*$:\1:p' "$file")"
    [ -z "$enc" ] && enc="UTF-8"

    iconv -f "$enc" -t "UTF-8" "$file" \
    | tr '\n\t\r' '   ' \
    | sed -r 's:<(\?[xX][mM][lL]|!DOCTYPE) [^>]+>::g
              s:<[^!][^>]*>::;
              s:</[^>]*>([^<]*((<[^>]+/>|<!([^>]|<[^>]*>)*>|<\?[^>]+>)[^<]*)*)?$:\1:;'
  fi
}

get_attributes(){
  # get attributes of top level element in a given
  # XHTML file
  file="$1"

  cat "$file" \
  | tr '\n\t\r' '   ' \
  | sed -rn 's;^.*< *([xX]|[xX]?[hH][tT])[mM][lL] +([^>]*)>.*$;\2;p'
}

