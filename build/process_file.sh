#!/bin/bash

basedir="${0%/*}/.."
[ -z "$inc_processor" ] && . "$basedir/build/processor.sh"

. "$basedir/build/arguments.sh"

case "$command" in
  process_file) process_file "$workfile" "$processor" "$olang" ;;
  *) die "Unrecognised command or no command given" ;;
esac
