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
  dbg_file=/dev/stderr

  if [ "$#" -ge 1 ]; then
    echo "$@" >>"$dbg_file"
  else
    tee -a "$dbg_file"
  fi
}

print_error(){
  echo "Error: $@" |logstatus lasterror >/dev/stderr
  echo "Run '$0 --help' to see usage instructions" >/dev/stderr
}
