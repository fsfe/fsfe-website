#!/usr/bin/env bash

# Dependency check function
check_dependencies() {
  depends="$@"
  deperrors=''
  for depend in $depends; do
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
  fi 1>&2
}

# Check dependencies for all kinds of build envs (e.g. development, fsfe.org)
check_dependencies realpath rsync xsltproc xmllint sed find egrep grep wc make tee date iconv wget

if ! make --version | grep -q "GNU Make 4"; then
  echo "The build script requires GNU Make 4.x"
  exit 1
fi

basedir="${0%/*}/.."
[ -z "$inc_misc" ] && . "$basedir/build/misc.sh"
readonly start_time="$(date +%s)"

. "$basedir/build/arguments.sh"

# Check special dependencies for (test.)fsfe.org build server
if [ "$build_env" == "fsfe.org" ] || [ "$build_env" == "test.fsfe.org" ]; then
  check_dependencies lessc
fi

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
if [ $command = "build_into" -o $command = "git_build_into" ] && [ "$buildpids" -gt 2 ]; then
  debug "build script is already running"
  exit 1
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
  git_build_into)  if [ "${statusdir}/full_build" -nt "${statusdir}/index.cgi" ]; then
                     debug "discovered flag file, performing full build"
                     build_into
                   else
                     git_build_into
                   fi ;;
  build_into)      build_into ;;
  process_file)    process_file "$workfile" "$processor" ;;
  build_xmlstream) build_xmlstream "$(get_shortname "$workfile")" "$(get_language "$workfile")" ;;
  tree_maker)      tree_maker "$tree" "$target" ;;
esac
