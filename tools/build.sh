#! /bin/bash
TMP=/home/fsfe/tmp
DEST=/home/www/

tools/build.pl -o $TMP -i .
if test $? -ne 0; then
   echo "Build not complete. Aborting."
   exit 1
fi
rm -r $DEST/*
mv $TMP/* $DEST/

