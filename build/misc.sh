#!/bin/sh

inc_misc=true
[ -z "$inc_logging" ] && . "$basedir/build/logging.sh"

print_help(){
  cat "$basedir/build/HELP"
}

match(){
  echo -E "$1" |egrep -q "$2"
}

debug(){
  dbg_file="$(logname debug)"

  if [ "$#" -ge 1 ]; then
    echo "$@" |tee -a "$dbg_file"
  else
    tee -a "$dbg_file"
  fi
}
[ -s "$(logname debug)" ] && truncate -s 0 "$(logname debug)"

print_error(){
  echo "Error: $@" |logstatus lasterror >&2
  echo "Run '$0 --help' to see usage instructions" >&2
}

die(){
  print_error "$@"
  exit 1
}
