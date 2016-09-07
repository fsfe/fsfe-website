#!/bin/sh

inc_buildrun=true
[ -z "$inc_makerules" ] && . "$basedir/build/makerules.sh"
[ -z "$inc_stirrups" ] && . "$basedir/build/stirrups.sh"
[ -z "$inc_logging" ] && . "$basedir/build/logging.sh"
[ -z "$inc_misc" ] && . "$basedir/build/misc.sh"

build_into(){
  ncpu="$(grep -c ^processor /proc/cpuinfo)"

  [ -n "$statusdir" ] && cp "$basedir/build/status.html.sh" "$statusdir/index.cgi"
  printf %s "$start_time" |logstatus start_time
  [ -s "$(logname debug)" ] && truncate -s 0 "$(logname debug)"

  forcelog Makefile

  validate_caches

  make -j $ncpu -C "$basedir" \
  | t_logstatus premake

  dir_maker "$basedir" "$stagedir"

  tree_maker "$basedir" "$stagedir" "$@" \
  | logstatus Makefile \
  | build_manifest \
  | logstatus manifest \
  | remove_orphans "$stagedir" \
  | logstatus removed

  make -j $ncpu -f "$(logname Makefile)" all \
  | t_logstatus buildlog

  [ "$stagedir" != "$target" ] && \
    rsync -av --del "$stagedir/" "$target/" \
    | t_logstatus stagesync

  date +%s |logstatus end_time
  if [ -n "$statusdir" ]; then
    cd "$statusdir"
    ./index.cgi |tail -n+3 >status_$(date +%s).html
    cd -
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
    exit 0
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
