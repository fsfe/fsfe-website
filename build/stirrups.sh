#!/bin/sh

inc_stirrups=true
[ -z "$inc_misc" ] && . "$basedir/build/misc.sh"

dir_maker(){
  # set up directory tree for output
  # optimise by only issuing mkdir commands
  # for leaf directories
  input="${1%/}"
  output="${2%/}"

  curpath="$output"
  find "$input" -depth -type d \! -path '*/.svn' -printf '%P\n' \
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
           s;\$\{OUTPUTDIR\}/([^:]+) :.*;\1;p'
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
  # Remaining single files exist only in the tree and are to be removed

  (find "$dtree" -type f -o -type l; sed "s;^.*$;$dtree/&;") \
  | sort \
  | uniq -u \
  | while read file; do
    match "$file" "^$dtree" && rm -v "$file"
  done
}
