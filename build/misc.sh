#!/bin/sh

inc_misc=true

print_help(){
  cat "$basedir/build/HELP"
}

match(){
  echo -E "$1" |egrep -q "$2"
}

debug(){
  dbg_file=/dev/stderr

  if [ "$#" -ge 1 ]; then
    echo "$*" >>"$dbg_file"
  else
    tee -a "$dbg_file"
  fi
}

logname(){
  name="$1"

  if [ -w "$statusdir" ] && touch "$statusdir/$name"; then
    echo "$statusdir/$name"
  elif echo "$forcedlog" |egrep -q "^${name}=.+"; then
    echo "$forcedlog" |sed -rn "s;^${name}=;;p"
  else
    echo /dev/null
  fi
}
rmforcedlog(){
  echo "$forcedlog" \
  | while read logfile; do
    [ -f "$logfile" ] && rm "$logfile"
  done
}
forcelog(){
  name="$1"

  [ -n "$(logname "$name")" ] \
  || forcedlog="$forcedlog\n${name}=$(tempfile)"

  trap rmforcedlog 0
}
logstatus(){
  # pipeline atom to write data streams into a log file
  # log file will be created inside statusdir
  # if statusdir is not enabled, we won't log to a file
  file="$(logname "$1")"

  if [ -f "$file" ]; then
    tee "$file"
  else
    cat
  fi
}

print_error(){
  echo "Error: $*" |logstatus lasterror >/dev/stderr
  echo "Run '$0 --help' to see usage instructions" >/dev/stderr
}
