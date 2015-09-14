#!/bin/sh

inc_misc=true
[ -z "$inc_logging" ] && . "$basedir/build/logging.sh"

print_help(){
  cat "$basedir/build/HELP"
}

match(){
  printf %s "$1" |egrep -q "$2"
}

debug(){
  if [ "$#" -ge 1 ]; then
    echo "$(date '+%F %T'): $@" |logappend debug >&2
  else
    logappend debug >&2
  fi
}

print_error(){
  echo "Error - $@" |logappend lasterror >&2
  echo "Run '$0 --help' to see usage instructions" >&2
}

die(){
  echo "$(date '+%F %T'): Fatal - $@" |logappend lasterror >&2
  date +%s |logstatus end_time
  exit 1
}
