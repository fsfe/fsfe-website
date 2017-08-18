#!/bin/sh

inc_stirrups=true
[ -z "$inc_misc" ] && . "$basedir/build/misc.sh"
# [ -z "$inc_sources" ] && . "$basedir/build/sources.sh"

validate_caches(){
  # outdate / remove cache files if necessary
  # hook functions here as required

  # validate_tagmap  # hook from sources.sh
  true
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

build_manifest(){
  # read a Makefile from stdin and generate
  # list of all make tagets

  sed -nr 's;\\ ; ;g;
           s;\\#;#;g;
           s;\$\{OUTPUTDIR\}/([^:]+):.*;\1;p'
}

remove_orphans(){
  # read list of files which should be in a directory tree
  # and remove everything else
  dtree="${1%/}"

  # Idea behind the algorithm:
  # `find` will list every existing file once.
  # The manifest of all make targets will list all wanted files once.
  # Concatenate all lines from manifest and `find`.
  # Every file which is listed twice is wanted and exists.
  # We use 'uniq -u' to drop those from the list.
  # Remaining single files exist only in the tree and are to be
  # removed (or were just added to the manifest and cannot be removed
  # from the tree)

  (find "$dtree" \( -type f -o -type l \) -printf '%P\n' ; cat) \
  | sort \
  | uniq -u \
  | while read file; do
    rm -v "$dtree/$file"
  done
}

wakeup_news(){
  # Performs a `touch` on all files which are to be released at the
  # presented date.
  today="$1"

  find "$basedir" -name '*.xml' \
  | xargs egrep -l "<[^>]+ date=[\"']${today}[\"'][^>]*>" \
  | xargs touch -c 2>&- || true
}
