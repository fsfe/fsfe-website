#!/bin/bash

inc_buildrun=true
[ -z "$inc_makerules" ] && . "$basedir/build/makerules.sh"
[ -z "$inc_stirrups" ] && . "$basedir/build/stirrups.sh"
[ -z "$inc_logging" ] && . "$basedir/build/logging.sh"
[ -z "$inc_misc" ] && . "$basedir/build/misc.sh"

build_into(){
  ncpu="$(grep -c ^processor /proc/cpuinfo)"

  [ -n "$statusdir" ] && cp "$basedir/build/status.html.sh" "$statusdir/index.cgi"
  printf %s "$start_time" |logstatus start_time
  [ -f "$(logname lasterror)" ] && rm "$(logname lasterror)"
  [ -f "$(logname debug)" ] && rm "$(logname debug)"

  forcelog Makefile

  (
    # Make sure that the following pipe exits with a nonzero exit code if the
    # make run fails.
    set -o pipefail

    make -C "$basedir" | t_logstatus premake
  ) || exit 1

  dir_maker "$basedir" "$stagedir" || exit 1

  tree_maker "$basedir" "$stagedir" > "$(logname Makefile)" || exit 1

  (
    # Make sure that the following pipe exits with a nonzero exit code if the
    # make run fails.
    set -o pipefail

    if ! make -j $ncpu -f "$(logname Makefile)" all 2>&1; then
      die "See buildlog for errors reported by Make"
    fi | t_logstatus buildlog
  ) || exit 1

  if [ "$stagedir" != "$target" ]; then
    rsync -av --del "$stagedir/" "$target/" | t_logstatus stagesync
  fi

  date +%s | logstatus end_time
  if [ -n "$statusdir" ]; then
    cd "$statusdir"
    ./index.cgi |tail -n+3 >status_$(date +%s).html
    cd -
  fi
}

git_build_into(){
  forcelog GITchanges; GITchanges="$(logname GITchanges)"
  forcelog GITerrors;  GITerrors="$(logname GITerrors)"

  git -C "$basedir" pull >"$GITchanges" 2>"$GITerrors"
  gitterm="$?"

  if [ "$gitterm" -ne 0 ]; then
    die "GIT reported the following problem:\n$(cat "$GITerrors")"
  fi

  if egrep '^Already up-to-date\.' "$GITchanges"; then
    debug "No changes to GIT:\n$(cat "$GITchanges")"
    # Exit status should only be 0 if there was a successful build.
    # So set it to 1 here.
    exit 1
  fi

  logstatus GITlatest < "$GITchanges"
  build_into
}
