#!/bin/sh

inc_logging=true

logname(){
  name="$1"

  if [ -w "$statusdir" ] && touch "$statusdir/$name"; then
    echo "$statusdir/$name"
  elif echo "$forcedlog" |egrep -q "^${name}=.+"; then
    echo "$forcedlog" \
    | sed -rn "s;^${name}=;;p"
  else
    echo /dev/null
  fi
}

forcelog(){
  name="$1"

  [ "$(logname "$name")" = "/dev/null" ] \
  && forcedlog="$forcedlog\n${name}=$(tempfile -p w3bld -s $$)"
}

[ -z "$USER" ] && USER="$(whoami)"
trap "trap - 0 2 3 6 9 15; find \"${TMPDIR:-/tmp}/\" -maxdepth 1 -user \"$USER\" -name \"w3bld*$$\" -delete" 0 2 3 6 9 15

logstatus(){
  # pipeline atom to write data streams into a log file
  tee "$(logname "$1")"
}

t_logstatus(){
  # pipeline atom to write data streams into a log file
  while read line; do
    printf "[$(date +%T)] %s\n" "$line"
  done |logstatus "$@"
}

logappend(){
  # pipeline atom to write data streams into a log file
  tee -a "$(logname "$1")"
}
