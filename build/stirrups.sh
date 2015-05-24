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
  # pass Makefile throug on pipe and generate
  # list of all make tagets

  outfile="$1"
  truncate -s 0 "$outfile"

  while line="$(line)"; do
    echo "$line"
    echo "$line" \
    | sed -nr 's;/\./;/;g;s;\\ ; ;g;s;([^:]+) :.*;\1;p' \
    >> "$outfile"
  done
}

remove_orphans(){
  # read list of files which should be in a directory tree
  # and remove everything else

  tree="$1"

  # idea behind the algorithm:
  # `find` will list every existing file once
  # the manifest of all make targets will list all wanted files once
  # concatenate all lines from manifest and `find`
  # every file which is listed twice is wanted and exists,
  # we use 'uniq -u' to drop those from the list
  # remaining single files exist only in the tree and are to be removed

  (find "$tree" -type f -or -type l; cat) \
  | sort \
  | uniq -u \
  | while read file; do
    match "$file" "^$tree" && rm -v "$file"
  done
}
