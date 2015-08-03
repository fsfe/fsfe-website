#!/bin/sh

basedir="$(dirname $0)/.."
[ -z "$inc_sources" ] && . "$basedir/build/sources.sh"

. "$basedir/build/arguments.sh"

case "$command" in
  map_tags)      map_tags "$@";;
  sourceglobs)   sourceglobs "$sourcesfile" ;;
  lang_sources)  lang_sources "$sourceglobfile" "$lang" ;;
  cast_refglobs) cast_refglobs "$globfile" "$reffile" ;;
  *)             die "Urecognised command or no command given" ;;
esac
