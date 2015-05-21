#!/bin/sh

inc_misc=true

debug(){
  dbg_file=/dev/stderr

  if [ "$#" -ge 1 ]; then
    echo "$*" >"$dbg_file"
  else
    tee -a "$dbg_file"
  fi
}

match(){
  echo -E "$1" |egrep -q "$2"
}

logstatus(){
  # pipeline atom to write data streams into a log file
  # log file will be created inside statusdir
  # if statusdir is not enabled, we won't log to a file
  file="$1"

  if [ -w "$statusdir" ]; then
    tee "$statusdir/$file"
  else
    cat
  fi
}

print_error(){
  echo "Error: $*" |logstatus lasterror >/dev/stderr
  echo "Run '$0 --help' to see usage instructions" >/dev/stderr
}
