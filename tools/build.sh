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
STATUS=/var/www/web

cd $SOURCE
tools/build.pl -q -o $TMP -i .

if test $? -ne 0; then
   echo "Build not complete. Aborting."
   exit 1
fi

for target in ${TMP}/*; do
  test -d ${target} && ln -s ${SOURCE} ${target}/source
done

cd $TMP

echo "$(date)  Creating symlinks"
/usr/local/bin/symlinks

echo "$(date)  Obfuscating email addresses"
# This replaces all '@' in all html files with '&#64;'. We use '-type f'
# because we want to exclude symlinks. Because 'sed -i' is a very expensive
# operation, even if there is no replacement done anyway, we first limit the
# files to operate on to those files that actually contain an '@'.
find . -type f -name "*.html" | xargs grep -l '@' | xargs sed -i 's/@/\&#64;/g'

mv $DEST ${DEST}.old
mv $TMP $DEST
rm -rf ${DEST}.old

cd $SOURCE

echo "$(date)  Generating translation logs"
tools/translation-log.sh ${DEST}/translations.log ${STATUS}
echo "$(date)  Build complete"
