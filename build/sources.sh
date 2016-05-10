#!/bin/sh

inc_sources=true
[ -z "$inc_xmlfiles" ] && . "$basedir/build/xmlfiles.sh"

validate_tagmap(){
  tagmap="$basedir/tagmap"
  sed -rn 's;^(.*\.xml) +.*$;\1;p' "$tagmap" |while read fn; do
    [ -f "$fn" ] || touch -cd@0 "$tagmap"
  done
}

map_tags(){
  for xml in "$@"; do
    printf '%s ' "$xml"
    sed -rn ':a;N;$!ba
             s;<!([^>]|<[^>]*>)*>;;g
             s;[\n\t ]+; ;g
             s; ?([</>]) ?;\1;g
             tb;Tb;:b
             s;.*<tags( [^>]+)?>[^<]*<tag( [^>]+)?>(.*)</tag>[^<]*</tags>.*;\3;;Tc
             s; ;+;g
             s;</tag>[^<]*<tag(\+[^>]+)?>; ;g;p;q
             :c;a\
             ' "$xml"
  done
}

tagging_sourceglobs(){
  # read a .sources file and glob up referenced xml files for processing in list_sources
  sourcesfile="$1"

  [ -f "$sourcesfile" ] && grep ':\[.*\]$' "$sourcesfile" \
  | while read line; do
    glob="${line%:\[*\]}"
    tags="$(printf %s "$line" |sed -r 's;^.+:\[(.*)\]$;\1;;s; ;+;g;s;,; ;g')"
 
    # Input file must match *all* tags from line definition.
    # Build a sed expression, that performs conjunctive match
    # at once, e.g. to match all of the tags 'spam', 'eggs',
    # and 'bacon' the expression will have roughly the form 
    # "/spam/{/eggs/{/bacon/{p}}}"
  
    match="$(printf '%s' "$glob" |sed -r 's;\*;.*;g;s;\?;.;g')"
    matchline="s;^(${basedir}/${match}.*)\.[a-z]{2}\.xml .*$;\1;p"
    for tag in $tags ; do
      matchline="/ $tag( |$)/{${matchline}}"
    done

    if [ -z "$tags" ]; then
      # save the i/o if tags are empty, i.e. always match
      printf '%s \n' "$basedir/"${glob}*.[a-z][a-z].xml |sed -rn "$matchline"
    elif [ -f "$basedir/tagmap" ]; then
      sed -rn "$matchline" <"$basedir/tagmap"
    else
      map_tags "$basedir/"${glob}*.[a-z][a-z].xml \
      | sed -rn "$matchline"
    fi 
  done \
  | sort -u
}

legacy_sourceglobs(){
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

[ -z "$inc_misc" ] && . "$basedir/build/misc.sh"
sourceglobs(){
  if [ "$legacyglobs" = true ]; then
    legacy_sourceglobs "$@"
  elif [ -f "$1" ] && ! egrep -q '^.+:\[.*\]$' "$1"; then
    debug "WARNING! File in legacy format: $1"
    legacy_sourceglobs "$@"
  else
    tagging_sourceglobs "$@"
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
    printf '\n### filename="%s" ###\n%s' "$source" "$(include_xml "$source")" 
  done \
  | sed -r ':X; N; $!bX; s;\n### (filename="[^\n"]+") ###\n[^<]*(<![^>]+>[^<]*)*(<[^>]+)>;\2\3 \1>;g'
}

lang_sources(){
  sourcesfile="$1"
  lang="$2"

  list_sources "$sourcesfile" "$lang"
}

cast_refglobs(){
  globfile="$1"
  reffile="$2"

  read globsize refsize <<-x
	$(stat --printf=\ %s "$globfile" "$reffile" 2>/dev/null)
	x

  if [ "$globsize" != "$refsize" ]; then  # quick pre check
    cp "$globfile" "$reffile"
  elif [ "$globsize" -gt 0 ] && diff -q "$globfile" "$reffile" >/dev/null; then
    incfile="$(cat "$globfile" |xargs -d\\n ls -t |sed -n '1p')"
    [ "$incfile" -nt "$reffile" ] && touch "$reffile" || true
  elif [ "$globsize" -gt 0 ]; then  # files passed pre check, but are different anyway
    cp "$globfile" "$reffile"
  fi
}

cast_langglob(){
  shortname="$1"
  langglob="$2"

  langsources="$(printf %s\\n "${shortname}".*.xhtml)"
  if [ -e "$langglob" ] && printf %s "$langsources" |diff -q - "$langglob" >/dev/null; then
    true
  else
    printf %s "$langsources" >"$langglob"
  fi
}
