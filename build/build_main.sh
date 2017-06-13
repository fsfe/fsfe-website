#!/bin/sh

# Check dependencies
deperrors=''
for depend in realpath rsync xsltproc xmllint sed find egrep grep wc make tee date iconv wget; do
  if ! which "$depend" >/dev/null 2>&1; then
    deperrors="$depend $deperrors"
  fi
done
if [ -n "$deperrors" ]; then
  printf '\033[1;31m'
  cat <<-EOF
	The build script depends on some other programs to function.
	Not all of those programs could be located on your system.
	Please use your package manager to install the following programs:
	EOF
  printf '\n\033[0;31m%s\n' "$deperrors"
  exit 1
fi >>/dev/stderr

basedir="${0%/*}/.."
[ -z "$inc_misc" ] && . "$basedir/build/misc.sh"
readonly start_time="$(date +%s)"

. "$basedir/build/arguments.sh"

if [ -n "$statusdir" ]; then
  mkdir -p "$statusdir"
  [ ! -w "$statusdir" -o ! -d "$statusdir" ] && \
  die "Unable to set up status directory in \"$statusdir\",\n" \
      "either select a status directory that exists and is writable,\n" \
      "or run the build script without output to a status directory"
fi
readonly statusdir="${statusdir:+$(realpath "$statusdir")}"

buildpids=$(
  ps -eo command \
  | egrep "[s]h ${0} .*" \
  | wc -l
)
if [ $command = "build_into" -o $command = "svn_build_into" ] && [ "$buildpids" -gt 2 ]; then
  debug "build script is already running"
  exit 0
fi

[ -z "$inc_filenames" ] && . "$basedir/build/filenames.sh"
[ -z "$inc_buildrun" ]  && . "$basedir/build/buildrun.sh"
[ -z "$inc_languages" ] && . "$basedir/build/languages.sh"
[ -z "$inc_makerules" ] && . "$basedir/build/makerules.sh"
[ -z "$inc_processor" ] && . "$basedir/build/processor.sh"
[ -z "$inc_scaffold" ]  && . "$basedir/build/scaffold.sh"
[ -z "$inc_sources" ]   && . "$basedir/build/sources.sh"
[ -z "$inc_stirrups" ]  && . "$basedir/build/stirrups.sh"

case "$command" in
  map_tags)        map_tags "$@";;
  build_into)      build_into ;;
  svn_build_into)  svn_build_into ;;
  process_file)    process_file "$workfile" "$processor" "$olang" ;;
  build_xmlstream) build_xmlstream "$(get_shortname "$workfile")" "$(get_language "$workfile")" "$olang" ;;
  tree_maker)      tree_maker "$tree" "$target" ;;
  sourceglobs)     sourceglobs "$sourcesfile" ;;
  lang_sources)    lang_sources "$sourceglobfile" "$lang" ;;
  cast_refglobs)   cast_refglobs "$globfile" "$reffile" ;;
  wakeup_news)     wakeup_news "$today" ;;
esac
