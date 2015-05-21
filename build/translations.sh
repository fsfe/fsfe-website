#!/bin/sh

inc_translations=true
[ -z "$inc_filenames" ] && . "$basedir/build/filenames.sh"
[ -z "$inc_languages" ] && . "$basedir/build/languages.sh"

cache_textsfile(){
  cache_textsfile="$(for lang in $(get_languages); do
    if [ -f "$basedir/tools/texts-${lang}.xml" ]; then
      echo -n " ${lang}:<$basedir/tools/texts-${lang}.xml> "
    else
      echo -n " ${lang}:<$basedir/tools/texts-en.xml> "
    fi
  done)"
}

get_textsfile(){
  # get the texts file for a given language
  # fall back to english if necessary
  lang="$1"

  if [ -n "$cache_textsfile" ]; then
    echo "$cache_textsfile" |sed -r 's;^.* '"$lang"':<([^>]+)> .*$;\1;p'
  elif [ -f "$basedir/tools/texts-${1}.xml" ]; then
    echo "$basedir/tools/texts-${1}.xml"
  else
    echo "$basedir/tools/texts-en.xml"
  fi
}
