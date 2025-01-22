#!/usr/bin/env bash
set -euo pipefail

usage() {
	cat <<-EOF
		# build.sh Usage
		## General
		This script is a wrapper script over ./build/build_main.sh that provides nicer option names, and the options to serve the files.
		For documentation on the build script itself see ./build/README.md
		## Flags
		### -f | --full
		Perform a full rebuild of the webpages.
		### -s | --serve
		Serve the build webpages over localhost.
		### --
		Everything after this is passed directly to build_main.
		See ./build/README.md for valid options.
	EOF
	exit 1
}
command="build_run"
serve=""
extra_args=""
while [ "$#" -gt 0 ]; do
	case "$1" in
	--full | -f)
		command="build_into" && shift 1
		;;
	--serve | -s)
		serve="true" && shift 1
		;;
	--)
		shift 1
		while [ "$#" -gt 0 ]; do
			extra_args+="$1 "
			shift 1
		done
		;;
	*)
		usage
		;;
	esac
done
mkdir -p ./output
./build/build_main.sh "$command" ./output/final --statusdir ./output/final/status.fsfe.org/fsfe.org/data $extra_args
if [[ "$serve" ]]; then
	python3 ./serve-websites.py
fi
