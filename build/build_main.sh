#!/bin/sh

basedir="$(realpath -m "$0/../..")"

[ -z "$inc_misc" ] && . "$basedir/build/misc.sh"

buildpids=$(
  ps -eo pid,command \
  | egrep 'sh .*[b]uild_main.sh .*' \
  | wc -l
)
if [ "$buildpids" -gt 2 ]; then
  print_error "build script is already running"
  exit 0
fi

[ -z "$inc_filenames" ] && . "$basedir/build/filenames.sh"
[ -z "$inc_buildrun" ] && . "$basedir/build/buildrun.sh"
[ -z "$inc_languages" ] && . "$basedir/build/languages.sh"
[ -z "$inc_makerules" ] && . "$basedir/build/makerules.sh"
[ -z "$inc_processor" ] && . "$basedir/build/processor.sh"
[ -z "$inc_scaffold" ] && . "$basedir/build/scaffold.sh"
[ -z "$inc_sources" ] && . "$basedir/build/sources.sh"

domain="www.fsfe.org"

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
      command="help"
      ;;
    build_into)
      command="$1$command"
      [ -n "$*" ] && shift 1 && target="$1"
      ;;
    build_xmlstream)
      command="$1$command"
      [ -n "$*" ] && shift 1 && workfile="$1"
      [ -n "$*" ] && shift 1 && olang="$1"
      ;;
    tree_maker)
      command="$1$command"
      [ -n "$target" -o -n "$3" ] && shift 1 && tree="$1"
      shift 1; [ -n "$1" ] && target="$1"
      ;;
    process_file)
      command="$1$command"
      [ -n "$*" ] && shift 1 && workfile="$1"
      [ -n "$*" ] && shift 1 && processor="$1"
      [ -n "$*" ] && shift 1 && olang="$1"
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

[ -z "$tree" ] && tree="$basedir"
tree="$(realpath "$tree")"
basedir="$(realpath "$basedir")"
target="$(realpath "$target")"

if [ -n "$statusdir" ]; then
  mkdir -p "$statusdir"
  statusdir="$(realpath "$statusdir")"
  if [ ! -w "$statusdir" -o ! -d "$statusdir" ]; then
    print_error "Unable to set up status directory in \"$statusdir\",
either select a status directory that exists and is writable,
or run the build script without output to a status directory"
    exit 1
  fi
fi

case "$command" in
  build_into)
    [ -z "$target" ] && print_error "Missing destination directory" && exit 1
    build_into
    ;;
  process_file)
    [ -z "$workfile" ] && print_error "Need at least input file" && exit 1
    process_file "$workfile" "$processor" "$olang"
    ;;
  build_xmlstream)
    [ -z "$workfile" ] && print_error "Missing xhtml file name" && exit 1
    build_xmlstream "$(get_shortname "$workfile")" "$(get_language "$workfile")" "$olang"
    ;;
  tree_maker)
    [ -z "$target" ] && print_error "Missing target location" && exit 1
    tree_maker "$tree" "$target"
    ;;
  sourceglobs)
    [ -z "$sourcesfile" ] && print_error "Missing .sources file" && exit 1
    sourceglobs "$sourcesfile"
    ;;
  cast_globfile)
    [ -z "$sourceglobfile" -o -z "$lang" -o -z "$globfile" ] && print_error "Need source globfile language and globfile" && exit 1
    cast_globfile "$sourceglobfile" "$lang" "$globfile"
    ;;
  *help*)
    print_help
    ;;
  *)
    print_error "Urecognised command or no command given"
    ;;
esac
