#!/bin/sh

inc_buildrun=true
[ -z "$inc_makerules" ] && . "$basedir/build/makerules.sh"
[ -z "$inc_misc" ] && . "$basedir/build/misc.sh"
[ -z "$inc_stirrups" ] && . "$basedir/build/stirrups.sh"

build_into(){
  ncpu="$(cat /proc/cpuinfo |grep ^processor |wc -l)"

  [ -w "$statusdir" -a -d "$statusdir" ] && \
     manifest="$(tempfile -d "$statusdir" -p mnfst)" \
  || manifest="$(tempfile -p w3bld)"

  make -j $ncpu -C "$basedir" \
  | logstatus premake

  dir_maker "$basedir" "$target"
  tree_maker "$basedir" "$target" \
  | logstatus Makefile \
  | build_manifest "$manifest" \
  | make -j $ncpu -f - \
  | logstatus buildlog

  remove_orphans "$target" <"$manifest" \
  | logstatus removed

  [ -w "$statusdir" -a -d "$statusdir" ] && \
     mv "$manifest" "$statusdir/manifest" \
  || rm "$manifest"
}
