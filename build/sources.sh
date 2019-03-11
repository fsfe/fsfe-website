#!/bin/bash

inc_sources=true
[ -z "$inc_misc" ] && . "$basedir/build/misc.sh"
[ -z "$inc_xmlfiles" ] && . "$basedir/build/xmlfiles.sh"

list_sources(){
  # read a .xmllist file and generate a list
  # of all referenced xml files with preference
  # for a given language
  shortname="$1"
  lang="$2"

  cat "`dirname ${shortname}`/.`basename ${shortname}`.xmllist" | while read base; do
    echo "${basedir}/${base}".[a-z][a-z].xml "${basedir}/${base}".en.[x]ml "${basedir}/${base}.${lang}".[x]ml
  done | sed -rn 's;^(.* )?([^ ]+\.[a-z]{2}\.xml).*$;\2;p'
}

auto_sources(){
  # import elements from source files, add file name
  # attribute to first element included from each file
  shortname="$1"
  lang="$2"

  list_sources "$shortname" "$lang" \
  | while read source; do
    printf '\n### filename="%s" ###\n%s' "$source" "$(include_xml "$source")" 
  done \
  | sed -r ':X; N; $!bX;
            s;\n### (filename="[^\n"]+") ###\n[^<]*(<![^>]+>[^<]*)*(<([^/>]+/)*([^/>]+))(/?>);\2\3 \1\6;g;
           '
}
