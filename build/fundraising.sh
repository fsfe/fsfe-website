#!/bin/sh

inc_fundraising=true
[ -z "$inc_filenames" ] && . "$basedir/build/filenames.sh"
[ -z "$inc_languages" ] && . "$basedir/build/languages.sh"

cache_fundraising(){
  cache_fundraising="$(for lang in $(get_languages); do
    if [ -f "$basedir/fundraising-${lang}.xml" ]; then
      echo -n " ${lang}:<$basedir/fundraising-${lang}.xml> "
    elif [ -f "$basedir/fundraising-en.xml" ]; then
      echo -n " ${lang}:<$basedir/fundraising-en.xml> "
    fi
  done)"
}

get_fundraisingfile(){
  # get the fundraising file for a given language
  # TODO: integrate with regular texts function
  lang="$1"

  if [ -n "$cache_fundraising" ]; then
    echo "$cache_fundraising" |sed -r 's;^.* '"$lang"':<([^>]+)> .*$;\1;p'
  elif [ -f "$basedir/fundraising-${lang}.xml" ]; then
    echo "$basedir/fundraising-${lang}.xml"
  elif [ -f "$basedir/fundraising-en.xml" ]; then
    echo "$basedir/fundraising-en.xml"
  fi
}
