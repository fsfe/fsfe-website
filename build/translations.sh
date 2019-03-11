#!/bin/bash

inc_translations=true
[ -z "$inc_filenames" ] && . "$basedir/build/filenames.sh"
[ -z "$inc_languages" ] && . "$basedir/build/languages.sh"

get_textsfile(){
  # get the texts file for a given language
  # fall back to english if necessary
  lang="$1"

  if [ -f "$basedir/tools/texts-${1}.xml" ]; then
    echo "$basedir/tools/texts-${1}.xml"
  else
    echo "$basedir/tools/texts-en.xml"
  fi
}
