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

  make -C "$basedir" | t_logstatus premake

  dir_maker "$basedir" "$stagedir"

  tree_maker "$basedir" "$stagedir" "$@" > "$(logname Makefile)"

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
    die "GIT reported the following problem:\n" \
        "$(cat "$GITerrors")"
  #elif egrep '^(C...|.C..|...C) .+' "$SVNchanges"; then
  #  die "GIT encountered a conflict:\n" \
  #      "$(cat "$SVNchanges")"
  elif egrep '^Already up-to-date\.' "$GITchanges"; then
    debug "No changes to GIT:\n" \
          "$(cat "$GITchanges")"
    # Exit status should only be 0 if there was a successful build.
    # So set it to 1 here.
    exit 1
  else
    logstatus GITlatest <"$GITchanges"
    regen_xhtml=false
    regen_xsldeps=false
    regen_copy=false

    # What to do, if a certain file type gets added, deleted, modified
    egrep -q '^ (delete|rename) .*\.xhtml'	"$GITchanges" && regen_xhtml=true
    egrep -q '^ (create|rename) .*\.sources'	"$GITchanges" && regen_xhtml=true
    egrep -q '^ (delete|rename) .*\.sources'	"$GITchanges" && regen_xhtml=true
    egrep -q '^ (create|rename) .*\.xsl'	"$GITchanges" && regen_xhtml=true
    egrep -q '^ (delete|rename) .*\.xsl'	"$GITchanges" && regen_xhtml=true && regen_xsldeps=true
    egrep -q '^ .*\.xsl *\|'			"$GITchanges" && regen_xsldeps=true
    egrep -v '.*(\.xml|\.xsl|\.xhtml|\.sources|Makefile)' "$GITchanges" \
    | egrep -q '^ (delete|rename)' && regen_copy=true

    build_into $(sed -rn '
      /^ create mode [0-7]{6} .*(Makefile|\.xml)/d
      /^ rename .* => .*(Makefile|\.xml)\}? \([0-9]+%\)/d
      s;^ create mode [0-7]{6} (.+);\1;p;
      s;^ rename ([^{]+ => )(.*) \([0-9]+%\);\2;p;
      s;^ rename ([^{]*)(\{.* => )(.+)\}(.*) \([0-9]+%\);\1\3\4;p
      ' "$GITchanges" \
      | xargs -d\\n printf "${basedir}"/%s\\n
    )
  fi
}

svn_build_into(){
  forcelog SVNchanges; SVNchanges="$(logname SVNchanges)"
  forcelog SVNerrors;  SVNerrors="$(logname SVNerrors)"

  svn --non-interactive update "$basedir" >"$SVNchanges" 2>"$SVNerrors"
  svnterm="$?"

  if [ "$svnterm" -ne 0 ]; then
    die "SVN reported the following problem:\n" \
        "$(cat "$SVNerrors")"
  elif egrep '^(C...|.C..|...C) .+' "$SVNchanges"; then
    die "SVN encountered a conflict:\n" \
        "$(cat "$SVNchanges")"
  elif egrep '^At revision [0-9]+\.' "$SVNchanges"; then
    debug "No changes to SVN:\n" \
          "$(cat "$SVNchanges")"
    # Exit status should only be 0 if there was a successful build.
    # So set it to 1 here.
    exit 1
  else
    logstatus SVNlatest <"$SVNchanges"
    regen_xhtml=false
    regen_xsldeps=false
    regen_copy=false

    # What to do, if a certain file type gets added, deleted, modified
    egrep -q '^[A]... .*\.xml'		"$SVNchanges" && true
    egrep -q '^[D]... .*\.xml'		"$SVNchanges" && true
    egrep -q '^[UGR]... .*\.xml'	"$SVNchanges" && true
    egrep -q '^[A]... .*\.xhtml'	"$SVNchanges" && true
    egrep -q '^[D]... .*\.xhtml'	"$SVNchanges" && regen_xhtml=true
    egrep -q '^[UGR]... .*\.xhtml'	"$SVNchanges" && true
    egrep -q '^[A]... .*\.sources'	"$SVNchanges" && regen_xhtml=true
    egrep -q '^[D]... .*\.sources'	"$SVNchanges" && regen_xhtml=true
    egrep -q '^[UGR]... .*\.sources'	"$SVNchanges" && true
    egrep -q '^[A]... .*\.xsl'		"$SVNchanges" && regen_xhtml=true
    egrep -q '^[D]... .*\.xsl'		"$SVNchanges" && regen_xhtml=true && regen_xsldeps=true
    egrep -q '^[UGR]... .*\.xsl'	"$SVNchanges" && regen_xsldeps=true
    egrep -v '.*(\.xml|\.xsl|\.xhtml|\.sources|Makefile)$' "$SVNchanges" \
    | egrep -q '^[D]... .*' && regen_copy=true

    build_into $(sed -rn '/.*(Makefile|\.xml)$/d;s;^A... (.+)$;\1;p' "$SVNchanges")
  fi
}
