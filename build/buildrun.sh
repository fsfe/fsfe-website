#!/bin/sh

inc_buildrun=true
[ -z "$inc_makerules" ] && . "$basedir/build/makerules.sh"
[ -z "$inc_stirrups" ] && . "$basedir/build/stirrups.sh"
[ -z "$inc_logging" ] && . "$basedir/build/logging.sh"
[ -z "$inc_misc" ] && . "$basedir/build/misc.sh"

build_into(){
  ncpu="$(grep -c ^processor /proc/cpuinfo)"

  forcelog Makefile

  make -j $ncpu -C "$basedir" \
  | logstatus premake

  dir_maker "$basedir" "$target"

  tree_maker "$basedir" "$target" "$@" \
  | logstatus Makefile \
  | build_manifest \
  | logstatus manifest \
  | remove_orphans "$target" \
  | logstatus removed

  make -j $ncpu -f "$(logname Makefile)" all \
  | logstatus buildlog
}

svn_build_into(){
  forcelog SVNchanges; SVNchanges="$(logname SVNchanges)"
  forcelog SVNerrors;  SVNerrors="$(logname SVNerrors)"

  svn --non-interactive update "$basedir" >"$SVNchanges" 2>"$SVNerrors"

  if [ -s "$SVNerrors" ]; then
    print_error "SVN reported the following problem:\n" \
                "$(cat "$SVNerrors")"
    exit 1
  elif egrep '^(C...|.C..|...C) .+' "$SVNchanges"; then
    print_error "SVN encountered a conflict:\n" \
                "$(cat "$SVNchanges")"
    exit 1
  elif egrep '^At revision [0-9]+\.' "$SVNchanges"; then
    debug "No changes to SVN:\n" \
          "$(cat "$SVNchanges")"
    exit 0
  else
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
