#!/bin/bash

inc_sources=true
[ -z "$inc_misc" ] && . "$basedir/build/misc.sh"
[ -z "$inc_xmlfiles" ] && . "$basedir/build/xmlfiles.sh"

sourceglobs(){
  # read a .sources file and glob up referenced xml files for processing in list_sources
  sourcesfile="$1"

  [ -f "$sourcesfile" ] && grep ':\[.*\]$' "$sourcesfile" \
  | while read line; do
    glob="${line%:\[*\]}"
    tags="$(printf %s "$line" \
            | sed -r 's;^.+:\[(.*)\]$;\1;;
                      y;ABCDEFGHIJKLMNOPQRSTUVWXYZ;abcdefghijklmnopqrstuvwxyz;
                      s;[-_+ /];;g
                      s;,; ;g
                     ')"

    sourcefiles="$(printf '%s\n' "$basedir/"${glob}*.[a-z][a-z].xml)"
    
    for tag in $tags; do
      sourcefiles="$(printf '%s\n' "$sourcefiles" |grep -Ff "$basedir/tools/tagmaps/${tag}.map")"
    done
    printf '%s\n' "$sourcefiles"
  done \
  | sed -rn 's;^(.+).[a-z]{2}.xml$;\1;p' \
  | sort -u
}

list_sources(){
  # read a .sources file and generate a list
  # of all referenced xml files with preference
  # for a given language
  sourcesfile="$1"
  lang="$2"

  # Optional 3rd parameter: preglobbed list of source files
  # can lead to speed gain in some cases
  [ "$#" -ge 3 ] && \
     sourceglobs="$3" \
  || sourceglobs="$(sourceglobs "$sourcesfile")"

  for base in $sourceglobs; do
    echo "${base}".[a-z][a-z].xml "${base}".en.[x]ml "${base}.${lang}".[x]ml
  done |sed -rn 's;^(.* )?([^ ]+\.[a-z]{2}\.xml).*$;\2;p'
}

auto_sources(){
  # import elements from source files, add file name
  # attribute to first element included from each file
  sourcesfile="$1"
  lang="$2"

  list_sources "$sourcesfile" "$lang" \
  | while read source; do
    printf '\n### filename="%s" ###\n%s' "$source" "$(include_xml "$source")" 
  done \
  | sed -r ':X; N; $!bX;
            s;\n### (filename="[^\n"]+") ###\n[^<]*(<![^>]+>[^<]*)*(<([^/>]+/)*([^/>]+))(/?>);\2\3 \1\6;g;
           '
}

lang_sources(){
  sourcesfile="$1"
  lang="$2"

  list_sources "$sourcesfile" "$lang"
}

cast_refglobs(){
  true
}

cast_langglob(){
  true
}
