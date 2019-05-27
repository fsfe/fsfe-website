#!/usr/bin/env bash

[ -z "$inc_misc" ] && . "$basedir/build/misc.sh"

if [ -z "$inc_arguments" ]; then
  inc_arguments=true
  basedir="$(realpath "${0%/*}/..")"

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
      --stage|--stagedir)
        [ "$#" -gt 0 ] && shift 1 && stagedir="$1"
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
      git_build_into)
        command="$1$command"
        [ "$#" -gt 0 ] && shift 1 && target="$1"
        ;;
      build_xmlstream)
        command="$1$command"
        [ "$#" -gt 0 ] && shift 1 && workfile="$1"
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
        ;;
      wakeup)
        command="$1$command"
        [ "$#" -gt 0 ] && shift 1 && today="$1"
        ;;
      *)
        print_error "Unknown option: $1"
        exit 1
        ;;
    esac
    [ "$#" -gt 0 ] && shift 1
  done
  
  tree="${tree:-$basedir}"
  stagedir="${stagedir:-$target}"
  today="${today:-$(date +%F)}"
  readonly tree="${tree:+$(realpath "$tree")}"
  readonly stagedir="${stagedir:+$(realpath "$stagedir")}"
  readonly basedir="${basedir:+$(realpath "$basedir")}"
  readonly domain="${domain:-www.fsfe.org}"
  readonly command
  if [ "$stagedir" != "$target" ] && printf %s "$target" |egrep -q '^.+@.+:(.+)?$'; then
    readonly target
  else 
    readonly target="${target:+$(realpath "$target")}"
  fi
  
  case "$command" in
    build_into)      [ -z "$target" ]      && die "Missing destination directory" ;;
    git_build_into)  [ -z "$target" ]      && die "Missing destination directory" ;;
    process_file)    [ -z "$workfile" ]    && die "Need at least input file" ;;
    build_xmlstream) [ -z "$workfile" ]    && die "Missing xhtml file name" ;;
    tree_maker)      [ -z "$target" ]      && die "Missing target location" ;;
    wakeup)          true;;
    *help*)          print_help; exit 0 ;;
    *)               die "Urecognised command or no command given" ;;
  esac
fi
