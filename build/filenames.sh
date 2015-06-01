#!/bin/sh

inc_filenames=true
[ -z "$inc_languages" ] && . "$basedir/build/languages.sh"

list_langs(){
  # list all languages a file exists in by globbing up
  # the shortname (i.e. file path with file ending omitted)
  # output is readily formated for inclusion
  # in xml stream
  shortname="$1"

  langfilter=$(
    echo "$shortname".[a-z][a-z].xhtml \
    | sed -r 's;[^ ]+.([a-z]{2}).xhtml;\1;g;s; ;|;g'
  )
  languages |egrep "^($langfilter) " \
  | sed -r 's:^([a-z]{2}) (.+)$:<tr id="\1">\2</tr>:g'
}

get_language(){
  # extract language indicator from a given file name
  echo "$(echo "$1" |sed -r 's:^.*\.([a-z]{2})\.[^\.]+$:\1:')";
}

get_shortname(){
  # get shortened version of a given file name
  # required for internal processing

  #echo "$(echo "$1" | sed -r 's:\.[a-z]{2}.xhtml$::')";
  echo "${1%.??.xhtml}"
}

get_processor(){
  # find the xslt script which is responsible for processing
  # a given xhtml file.
  # expects the shortname of the file as input (i.e. the
  # the file path without language and file endings)
  
  shortname="$1"
  
  if [ -f "${shortname}.xsl" ]; then
    echo "${shortname}.xsl"
  else
    location="$(dirname "$shortname")" 
    until [ -f "$location/default.xsl" -o "$location" = . -o "$location" = / ]; do
      location="$(dirname "$location")"
    done
    echo "$location/default.xsl"
  fi
}
