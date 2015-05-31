#!/bin/sh

basedir="$(realpath -m "$0/../..")"
[ -z "$inc_misc" ] && . "$basedir/build/misc.sh"

while [ "$#" -gt 0 ]; do
  case "$1" in
    -s|--statusdir|--status-dir)
      [ "$#" -gt 0 ] && shift 1 && statusdir="$1"
      ;;
    --domain)
      [ "$#" -gt 0 ] && shift 1 && domain="$1"
      ;;
    --source)
      [ "$#" -gt 0 ] && shift 1 && basedir="$1"
      ;;
    -d|--dest|--destination)
      [ "$#" -gt 0 ] && shift 1 && target="$1"
      ;;
    -h|--help)
      command="help"
      ;;
    build_into)
      command="$1$command"
      [ "$#" -gt 0 ] && shift 1 && target="$1"
      ;;
    svn_build_into)
      command="$1$command"
      [ "$#" -gt 0 ] && shift 1 && target="$1"
      ;;
    build_xmlstream)
      command="$1$command"
      [ "$#" -gt 0 ] && shift 1 && workfile="$1"
      [ "$#" -gt 0 ] && shift 1 && olang="$1"
      ;;
    tree_maker)
      command="$1$command"
      [ -n "$target" -o -n "$3" ] && shift 1 && tree="$1"
      shift 1; [ -n "$1" ] && target="$1"
      ;;
    process_file)
      command="$1$command"
      [ "$#" -gt 0 ] && shift 1 && workfile="$1"
      [ "$#" -gt 0 ] && shift 1 && processor="$1"
      [ "$#" -gt 0 ] && shift 1 && olang="$1"
      ;;
    sourceglobs)
      command="$1$command"
      [ "$#" -gt 0 ] && shift 1 && sourcesfile="$1"
      ;;
    cast_globfile)
      command="$1$command"
      [ "$#" -gt 0 ] && shift 1 && sourceglobfile="$1"
      [ "$#" -gt 0 ] && shift 1 && lang="$1"
      [ "$#" -gt 0 ] && shift 1 && globfile="$1"
      ;;
    *)
      print_error "Unknown option $1"
      exit 1
      ;;
  esac
  [ "$#" -gt 0 ] && shift 1
done

olang="${olang:-en}"
tree="${tree:-$basedir}"
readonly tree="${tree:+$(realpath "$tree")}"
readonly basedir="${basedir:+$(realpath "$basedir")}"
readonly statusdir="${statusdir:+$(realpath "$statusdir")}"
readonly target="${target:+$(realpath "$target")}"
readonly domain="${domain:-www.fsfe.org}"
readonly command

case "$command" in
  build_into)      [ -z "$target" ]      && die "Missing destination directory" ;;
  svn_build_into)  [ -z "$target" ]      && die "Missing destination directory" ;;
  process_file)    [ -z "$workfile" ]    && die "Need at least input file" ;;
  build_xmlstream) [ -z "$workfile" ]    && die "Missing xhtml file name" ;;
  tree_maker)      [ -z "$target" ]      && die "Missing target location" ;;
  sourceglobs)     [ -z "$sourcesfile" ] && die "Missing .sources file" ;;
  cast_globfile)   [ -z "$sourceglobfile" -o -z "$lang" -o -z "$globfile" ] && die "Need source globfile language and globfile" ;;
  *help*)          print_help; exit 0 ;;
  *)               die "Urecognised command or no command given" ;;
esac

