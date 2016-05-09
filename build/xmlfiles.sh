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
    | sed -r ':X; N; $!bX;
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

