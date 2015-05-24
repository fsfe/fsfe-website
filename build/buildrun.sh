#!/bin/sh

inc_buildrun=true
[ -z "$inc_makerules" ] && . "$basedir/build/makerules.sh"
[ -z "$inc_misc" ] && . "$basedir/build/misc.sh"
[ -z "$inc_stirrups" ] && . "$basedir/build/stirrups.sh"

svn_build(){
  run_make=true
  regen_globs=false
  regen_xsldeps=false
  regen_xhtml=false
  regen_copy=false

  forcelog additions

  svn update "$basedir" 2>&1 \
  | logstatus SVNchanges \
  | while read update; do
    case "$update" in
      Updating*) true;;
      Updated*) true;;
      "At revision"*) run_make=false;;
      C???" "*) conflict=true;;
      ?C??" "*) conflict=true;;
      ???C" "*) conflict=true;;
      A???" "*.xml) regen_globs=true;;
  [UGR]???" "*.xml) true;;
      ????" "*.xml) regen_globs=true;;
      A???" "*.sources) echo "$update";;
  [UGR]???" "*.sources) regen_globs=true;;
      ????" "*.sources) regen_globs=true;;
      A???" "*.xsl) echo "$update";;
  [UGR]???" "*.xsl) regen_xsldeps=true;;
      ????" "*.xsl) regen_xsldeps=true;;
      A???" "*.xhtml) regen_xhtml=true;;
  [UGR]???" "*.xhtml) true;;
      ????" "*.xhtml) regen_xhtml=true;;
      ????" "*Makefile) true;;
      A???" "*) echo "$update";;
  [UGR]???" "*) true;;
      ????" "*) regen_copy=true;;
      *) true;;
    esac
  done \
  | cut -c6- \
  | logstatus additions
}

build_into(){
  ncpu="$(cat /proc/cpuinfo |grep ^processor |wc -l)"

  forcelog manifest

  make -j $ncpu -C "$basedir" \
  | logstatus premake

  dir_maker "$basedir" "$target"

  tree_maker "$basedir" "$target" \
  | logstatus Makefile \
  | build_manifest "$(logname manifest)" \
  | make -j $ncpu -f - \
  | logstatus buildlog

  remove_orphans "$target" <"$(logname manifest)" \
  | logstatus removed
}
