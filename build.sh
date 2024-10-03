#!/usr/bin/env bash
set -euo pipefail

usage() {
    echo "Usage: $0 -f|--full" 1>&2
    exit 1
}
command="build_run"
while [ "$#" -gt 0 ]; do
    case "$1" in
    --full | -f)
        command="build_into" && shift 1
        ;;
    *)
        usage
        ;;
    esac
done
./build/build_main.sh "$command" ./output/final --statusdir ./output/final/status.fsfe.org/fsfe.org/data
