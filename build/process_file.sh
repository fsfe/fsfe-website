#!/bin/sh

basedir="$(dirname $0)/.."
[ -z "$inc_processor" ] && . "$basedir/build/processor.sh"

. "$basedir/build/arguments.sh"

[ "$command" = process_file ] && process_file "$workfile" "$processor" "$olang" \
|| die "Urecognised command or no command given"
