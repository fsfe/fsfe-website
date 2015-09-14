#!/bin/sh

inc_buildrun=true
[ -z "$inc_makerules" ] && . "$basedir/build/makerules.sh"
[ -z "$inc_stirrups" ] && . "$basedir/build/stirrups.sh"
[ -z "$inc_logging" ] && . "$basedir/build/logging.sh"
[ -z "$inc_misc" ] && . "$basedir/build/misc.sh"

build_into(){
  ncpu="$(grep -c ^processor /proc/cpuinfo)"

  printf %s "$start_time" |logstatus start_time
  [ -s "$(logname debug)" ] && truncate -s 0 "$(logname debug)"
  forcelog Makefile

  validate_caches

  make -j $ncpu -C "$basedir" \
  | logstatus premake

  dir_maker "$basedir" "$stagedir"

  tree_maker "$basedir" "$stagedir" "$@" \
  | logstatus Makefile \
  | build_manifest \
  | logstatus manifest \
  | remove_orphans "$stagedir" \
  | logstatus removed

  make -j $ncpu -f "$(logname Makefile)" all \
  | logstatus buildlog

  [ "$stagedir" != "$target" ] && \
    rsync -av --del "$stagedir/" "$target/" \
    | logstatus stagesync

  date +%s |logstatus end_time
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
    regen_globs=false
    regen_xhtml=false
    regen_xsldeps=false
    regen_copy=false

    egrep -q '^[^UGR]... .*\.xml'    "$SVNchanges" && regen_globs=true
    egrep -q '^[^A]... .*\.sources'  "$SVNchanges" && regen_globs=true
    egrep -q '^A... .*\.xhtml'       "$SVNchanges" && regen_globs=true
    egrep -q '^[^AUGR]... .*\.xhtml' "$SVNchanges" && regen_xhtml=true
    egrep -q '^A... .*\.xsl'         "$SVNchanges" && regen_xhtml=true
    egrep -q '^[^A]... .*\.xsl'      "$SVNchanges" && regen_xsldeps=true
    sed -r '/.*\.(xml|xsl|xhtml|sources)$/d;/Makefile$/d' "$SVNchanges" \
    | egrep -q '^[^AUGR]... .*'                     && regen_copy=true

    build_into $(sed -rn '/.*(Makefile|\.xml)$/d;s;^A... (.+)$;\1;p' "$SVNchanges")
  fi
}
