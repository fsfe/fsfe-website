#!/bin/sh

inc_stirrups=true
[ -z "$inc_misc" ] && . "$basedir/build/misc.sh"

dir_maker(){
  # set up directory tree for output
  # optimise by only issuing mkdir commands
  # for leaf directories

  input="$(echo "$1" |sed -r 's:/$::')"
  output="$(echo "$2" |sed -r 's:/$::')"

  curpath="$output"
  find "$input" -depth -type d \
  | sed -r "/(^|\/)\.svn($|\/)|^\.\.$/d;s;^$input/*;;" \
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

  sed -nr 's;/\./;/;g;
           s;\\ ; ;g;
           s;\\#;#;g;
           s;\$\{OUTPUTDIR\}/([^:]+) :.*;\1;p'
}

remove_orphans(){
  # read list of files which should be in a directory tree
  # and remove everything else
  tree="${1%/}"

  # Idea behind the algorithm:
  # `find` will list every existing file once.
  # The manifest of all make targets will list all wanted files once.
  # Concatenate all lines from manifest and `find`.
  # Every file which is listed twice is wanted and exists.
  # We use 'uniq -u' to drop those from the list.
  # Remaining single files exist only in the tree and are to be removed

  (find "$tree" -type f -o -type l; sed "s;^.*$;$tree/&;") \
  | sort \
  | uniq -u \
  | while read file; do
    match "$file" "^$tree" && rm -v "$file"
  done
}
