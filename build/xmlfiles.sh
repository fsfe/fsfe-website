#!/usr/bin/env bash

inc_xmlfiles=true

include_xml(){
  # include second level elements of a given XML file
  # this emulates the behaviour of the original
  # build script which wasn't able to load top
  # level elements from any file
  if [ -f "$1" ]; then
    sed -r ':X; $bY; N; bX; :Y;
            s:<(\?[xX][mM][lL]|!DOCTYPE)[[:space:]]+[^>]+>::g
            s:<[^!][^>]*>::;
            s:</[^>]*>([^<]*((<[^>]+/>|<!([^>]|<[^>]*>)*>|<\?[^>]+>)[^<]*)*)?$:\1:;' "$1"
  fi
}

get_attributes(){
  # get attributes of top level element in a given
  # XHTML file
  sed -rn ':X; N; $!bX;
           s;^.*<[\n\t\r ]*([xX]|[xX]?[hH][tT])[mM][lL][\n\t\r ]+([^>]*)>.*$;\2;p' "$1"
}

