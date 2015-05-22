#!/bin/sh

basedir="$(dirname $0)/.."

[ -z "$inc_misc" ] && . "$basedir/build/misc.sh"
[ -z "$inc_sources" ] && . "$basedir/build/sources.sh"

while [ -n "$*" ]; do
  case "$1" in
    -s|--statusdir|--status-dir)
      [ -n "$*" ] && shift 1 && statusdir="$1"
      ;;
    --domain)
      [ -n "$*" ] && shift 1 && domain="$1"
      ;;
    --source)
      [ -n "$*" ] && shift 1 && basedir="$1"
      ;;
    -d|--dest|--destination)
      [ -n "$*" ] && shift 1 && target="$1"
      ;;
    -h|--help)
      print_help
      exit 0
      ;;
    sourceglobs)
      command="$1$command"
      [ -n "$*" ] && shift 1 && sourcesfile="$1"
      ;;
    cast_globfile)
      command="$1$command"
      [ -n "$*" ] && shift 1 && sourceglobfile="$1"
      [ -n "$*" ] && shift 1 && lang="$1"
      [ -n "$*" ] && shift 1 && globfile="$1"
      ;;
    *)
      print_error "Unknown option $1"
      exit 1
      ;;
  esac
  [ -n "$*" ] && shift 1
done

case "$command" in
  sourceglobs)
    [ -z "$sourcesfile" ] && print_error "Missing .sources file" && exit 1
    sourceglobs "$sourcesfile"
    ;;
  cast_globfile)
    [ -z "$sourceglobfile" -o -z "$lang" -o -z "$globfile" ] && print_error "Need source globfile language and globfile" && exit 1
    cast_globfile "$sourceglobfile" "$lang" "$globfile"
    ;;
  *)
    print_error "Urecognised command or no command given"
    ;;
esac
