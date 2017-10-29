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
  grep -l '</tag>' "$@" \
  | while read xml; do
    printf '%s ' "$xml"
    unicat "$xml" \
    | sed -rn '# Normalise XML (strip comments, unify white-spaces)
               :X; $bY; N; bX; :Y;
               s;[\n\t ]+; ;g;
               s; ?([</>]) ?;\1;g
               s;<!([^>]|<[^>]*>)*>;;g

               # Loop over <tags> section
               s;.*<tags( [^>])?>(.+)</tags>.*;\2;
               tK; b; :K;

               # Collect new format tags
               /<tag key="[^"]+"(\/>|>[^<]*<\/tag>)/{
                 H; s;.*<tag key="([^"]+)"(/>|>[^<]*</tag>).*;\1;
                 x; s;(.*)<tag key="([^"]+)"(/>|>[^<]*</tag>);\1;
                 bK;
               }

               # Collect old format tags
               /<tag( [^>]+)?>([^<]+)<\/tag>/{
                 H; s;.*<tag( [^>]+)?>([^<]+)</tag>.*;\2;
                 x; s;(.*)<tag( [^>]+)?>([^<]+)</tag>;\1;
                 bK;
               }

               H;x;
               # Loop end

               # delete junk (non-tag content in the tags section)
               s;\n+[^\n]*$;;

               # normalise tagnames
               y;ABCDEFGHIJKLMNOPQRSTUVWXYZ;abcdefghijklmnopqrstuvwxyz;
               s;[-_+ /];;g

               # put tags in one line and print
               s;(\n|$); ;g; p;
              '
  done
}

tagging_sourceglobs(){
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
