#! /bin/bash
#
# This is a simple wrapper that will build the web pages in two steps.
# First, it will call build.pl with options to send the output to a
# temporary directory. After that is done, it will move the contents of
# that directory over the normal root.
#
SOURCE=/home/www/fsfe
DEST=/home/www/html
TMP=/home/www/tmp.$$

cd $SOURCE
tools/build.pl -q -o $TMP -i .

if test $? -ne 0; then
   echo "Build not complete. Aborting."
   exit 1
fi
cd $TMP
/usr/local/bin/symlinks

mv $DEST ${DEST}.old
mv $TMP $DEST
rm -rf ${DEST}.old
echo "Build complete."
