#!/bin/sh

basedir="$(dirname $0)/.."

[ -z "$inc_misc" ] && . "$basedir/build/misc.sh"
[ -z "$inc_processor" ] && . "$basedir/build/processor.sh"

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
    -h|--help)
      print_help
      exit 0
      ;;
    *)
      if [ -z "$workfile" ]; then
        workfile="$1"
      elif [ -z "$processor" ]; then
        processor="$1"
      elif [ -z "$olang" ]; then
        olang="$1"
      else
        print_error "Unknown option $1"
        exit 1
      fi
      ;;
  esac
  [ -n "$*" ] && shift 1
done

[ -z "$workfile" ] && print_error "Need at least input file" && exit 1
process_file "$workfile" "$processor" "$olang"
