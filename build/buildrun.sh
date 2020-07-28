#!/usr/bin/env bash

inc_buildrun=true
[ -z "$inc_makerules" ] && . "$basedir/build/makerules.sh"
[ -z "$inc_logging" ] && . "$basedir/build/logging.sh"
[ -z "$inc_misc" ] && . "$basedir/build/misc.sh"

match(){
  printf %s "$1" | egrep -q "$2"
}

dir_maker(){
  # set up directory tree for output
  # optimise by only issuing mkdir commands
  # for leaf directories
  input="${1%/}"
  output="${2%/}"

  curpath="$output"
  find "$input" -depth -type d \
       \! -path '*/.svn' \! -path '*/.svn/*' \
       \! -path '*/.git' \! -path '*/.git/*' \
       -printf '%P\n' \
  | while read filepath; do
    oldpath="$curpath"
    curpath="$output/$filepath/"
    srcdir="$output/source/$filepath/"
    match "$oldpath" "^$curpath" || mkdir -p "$curpath" "$srcdir"
  done
}

# The actual build
buildrun(){
  set -o pipefail

  printf %s "$start_time" > "$(logname start_time)"

  ncpu="$(grep -c ^processor /proc/cpuinfo)"

  [ -n "$statusdir" ] && cp "$basedir/build/status.html.sh" "$statusdir/index.cgi"

  [ -f "$(logname lasterror)" ] && rm "$(logname lasterror)"
  [ -f "$(logname debug)" ] && rm "$(logname debug)"

  {
    echo "Starting phase 1" \
    && make --silent --directory="$basedir" build_env="${build_env:-development}" 2>&1 \
    && echo "Finishing phase 1" \
    || die "Error during phase 1"
  } | t_logstatus phase_1 || exit 1

  dir_maker "$basedir" "$stagedir" || exit 1

  forcelog Makefile

  {
    tree_maker "$basedir" "$stagedir" 2>&1 \
    || die "Error during phase 2 Makefile generation"
  } > "$(logname Makefile)" || exit 1

  {
    echo "Starting phase 2" \
    && make --silent --jobs=$ncpu --file="$(logname Makefile)" 2>&1 \
    && echo "Finishing phase 2" \
    || die "Error during phase 2"
  } | t_logstatus phase_2 || exit 1

  if [ "$stagedir" != "$target" ]; then
    # rsync issues a "copying unsafe symlink" message for each of the "unsafe"
    # symlinks which we copy while rsyncing. These messages are issued even if
    # the files have not changed and clutter up the output, so we filter them
    # out.
    rsync -av --copy-unsafe-links --del "$stagedir/" "$target/" | grep -v "copying unsafe symlink" | t_logstatus stagesync
  fi

  date +%s > "$(logname end_time)"

  if [ -n "$statusdir" ]; then
    ( cd "$statusdir"; ./index.cgi | tail -n+3 > status_$(date +%s).html )
  fi
}

# Update git (try 3x) and then do an actual build
git_build_into(){
  forcelog GITchanges; GITchanges="$(logname GITchanges)"
  forcelog GITerrors;  GITerrors="$(logname GITerrors)"

  gitterm=1
  i=0
  while [[ ( $gitterm -ne 0 ) && ( $i -lt 3) ]]; do
    ((i++))

    git -C "$basedir" pull >"$GITchanges" 2>"$GITerrors"
    gitterm="$?"

    if [ $gitterm -ne 0 ]; then
      debug "Git pull unsuccessful. Trying again in a few seconds."
      sleep $(shuf -i 10-30 -n1)
    fi
  done

  if [ "$gitterm" -ne 0 ]; then
    die "GIT reported the following problem:\n$(cat "$GITerrors")"
  fi

  if egrep '^Already up[ -]to[ -]date' "$GITchanges"; then
    debug "No changes to GIT:\n$(cat "$GITchanges")"
    # Exit status should only be 0 if there was a successful build.
    # So set it to 1 here.
    exit 1
  fi

  logstatus GITlatest < "$GITchanges"
  buildrun
}

# Clean up everything and then do an actual (full) build
build_into(){

  # Clean up source directory.
  git -C "${basedir}" clean -dxf

  # Remove old stage directory.
  rm -rf "${stagedir}"

  buildrun
}
