#!/usr/bin/env bash

inc_fundraising=true
[ -z "$inc_filenames" ] && . "$basedir/build/filenames.sh"
[ -z "$inc_languages" ] && . "$basedir/build/languages.sh"

get_fundraisingfile(){
  # get the fundraising file for a given language
  # TODO: integrate with regular texts function
  lang="$1"

  if [ -f "$basedir/fundraising-${lang}.xml" ]; then
    echo "$basedir/fundraising-${lang}.xml"
  elif [ -f "$basedir/fundraising-en.xml" ]; then
    echo "$basedir/fundraising-en.xml"
  fi
}
