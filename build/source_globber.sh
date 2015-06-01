#!/bin/sh

basedir="$(dirname $0)/.."
[ -z "$inc_sources" ] && . "$basedir/build/sources.sh"

. "$basedir/build/arguments.sh"

case "$command" in
  sourceglobs)   sourceglobs "$sourcesfile" ;;
  cast_globfile) cast_globfile "$sourceglobfile" "$lang" "$globfile" ;;
  *)             die "Urecognised command or no command given" ;;
esac
