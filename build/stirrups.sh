#!/bin/bash

inc_stirrups=true
[ -z "$inc_misc" ] && . "$basedir/build/misc.sh"
# [ -z "$inc_sources" ] && . "$basedir/build/sources.sh"

dir_maker(){
  # set up directory tree for output
  # optimise by only issuing mkdir commands
  # for leaf directories
  input="${1%/}"
  output="${2%/}"

  curpath="$output"
  find "$input" -depth -type d \
       \! -path '*/.svn' \! -path '*/.svn/*' \
       \! -path '*/.git' \! -path '*/.git/*' \
       -printf '%P\n' \
  | while read filepath; do
    oldpath="$curpath"
    curpath="$output/$filepath/"
    srcdir="$output/source/$filepath/"
    match "$oldpath" "^$curpath" || mkdir -p "$curpath" "$srcdir"
  done
}

wakeup_news(){
  # Performs a `touch` on all files which are to be released at the
  # presented date.
  today="$1"

  find "$basedir" -name '*.xml' \
  | xargs egrep -l "<[^>]+ date=[\"']${today}[\"'][^>]*>" \
  | xargs touch -c 2>&- || true
}
