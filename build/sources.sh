#!/bin/sh

inc_sources=true
[ -z "$inc_xmlfiles" ] && . "$basedir/build/xmlfiles.sh"

sourceglobs(){
  # read a .sources file and glob up referenced
  # source files for processing in list_sources
  sourcesfile="$1"

  if [ -f "$sourcesfile" ]; then
    sed -rn 's;:global$;*.[a-z][a-z].xml;gp' "$sourcesfile" \
    | while read glob; do
      echo "$basedir/"$glob
    done \
    | sed -rn 's:\.[a-z]{2}\.xml( |$):\n:gp' \
    | sort -u
  fi
}

all_sources(){
  # read a .sources file and glob up all referenced
  # source files
  sourcesfile="$1"

  if [ -f "$sourcesfile" ]; then
    sed -rn 's;:global$;*.[a-z][a-z].xml;gp' "$sourcesfile" \
    | while read glob; do
      echo "$basedir/"$glob
    done |grep -vF "[a-z][a-z].xml"
  fi
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

  globfile="$(echo "$sourcesfile" |sed -r 's;(^|.*/)([^/]+).sources$;\1._._\2.'"$lang"'.sourceglobs;')"

  if [ -e "$globfile" ];then
    cat "$globfile"
  else
    list_sources "$sourcesfile" "$lang"
  fi | while read source; do
    echo -n "$source\t"
    include_xml "$source" 
    echo
  done \
  | sed -r 's:^([^\t]+)\t[^<]*(< *[^ >]+)([^>]*>):\2 filename="\1" \3:'
}

cast_globfile(){
  sourceglobfile="$1"
  lang="$2"
  globfile="$3"

  sources="$(list_sources "###" "$lang" "$(cat "$sourceglobfile")")"

  [ -f "$globfile" ] && \
    [ "$sources" = "$(cat "$globfile")" ] \
  || echo "$sources" >"$globfile"

  if [ "$sourceglobfile" -nt "$globfile" ]; then
    echo "$sources" |while read incfile; do
      [ "$incfile" -nt "$globfile" ] && touch "$globfile" || true
    done
  fi
}

