#! /bin/bash
#
# This is a simple wrapper that will build the web pages in two steps.
# First, it will call build.pl with options that will not produce any
# output files. If this run is successful, it will make a second run
# and create the files.
#
SOURCE=/home/www/fsfe
DEST=/home/www/html

cd $SOURCE
tools/build.pl -n -o $DEST -i .

if test $? -ne 0; then
   echo "Build not complete. Aborting."
   exit 1
fi

tools/build.pl -o $DEST -i .

cd $DEST
symlinks
