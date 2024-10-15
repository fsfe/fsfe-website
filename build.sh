#!/usr/bin/env bash
set -euo pipefail

usage() {
    echo "Usage: $0 -f|--full -s|--serve" 1>&2
    exit 1
}
command="build_run"
serve=""
while [ "$#" -gt 0 ]; do
    case "$1" in
    --full | -f)
        command="build_into" && shift 1
        ;;
    --serve | -s)
        serve="true" && shift 1
        ;;
    *)
        usage
        ;;
    esac
done
mkdir -p ./output
./build/build_main.sh "$command" ./output/final --statusdir ./output/final/status.fsfe.org/fsfe.org/data
if [[ "$serve" ]]; then
    python3 ./serve-websites.py
fi
