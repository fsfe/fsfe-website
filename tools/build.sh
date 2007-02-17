#!/bin/bash
# -----------------------------------------------------------------------------
# Web page build script
# -----------------------------------------------------------------------------
# This script is called every 5 minutes on www.fsfeurope.org to rebuild the
# HTML pages from the .xhtml, .xml and .xsl source files. Most of the work,
# however, is done by the Perl script build.pl.
# -----------------------------------------------------------------------------

SOURCE=/home/www/fsfe
DEST=/home/www/html
TMP=/home/www/tmp.$$
STATUS=/var/www/web

# If build is already running, don't run it again.
if ps -C build.sh -o pid= | grep -q -v "$$"; then
  exit
fi

# Redirect output
exec 1> ${STATUS}/status.txt 2>&1

cd ${SOURCE}

# -----------------------------------------------------------------------------
echo "$(date)  Cleaning old build directories."
# -----------------------------------------------------------------------------

rm -rf /home/www/tmp.*

# -----------------------------------------------------------------------------
echo "$(date)  Updating source files from CVS."
# -----------------------------------------------------------------------------

# Rebuild only if changes were made or it hasn't run yet today. We must run it
# once every day at least to move events from future to current and from
# current to past.
if test -z "$(cvs update -Pd 2>/dev/null)" \
    -a "$(date -r ${STATUS}/last-run +%F)" == "$(date +%F)"; then
  echo "$(date)  No changes to CVS."
  exit
fi

# Make sure build.sh and build.pl are executable (damn CVS!)
chmod +x tools/build.sh tools/build.pl

# -----------------------------------------------------------------------------
echo "$(date)  Building HTML pages."
# -----------------------------------------------------------------------------

touch ${STATUS}/last-run

tools/build.pl -q -o ${TMP} -i .

if test $? -ne 0; then
   echo "$(date)  Build not complete. Aborting."
   cp ${STATUS}/status.txt ${STATUS}/status-finished.txt
   exit 1
fi

# -----------------------------------------------------------------------------
echo "$(date)  Linking source files."
# -----------------------------------------------------------------------------

for target in ${TMP}/*; do
  test -d ${target} && ln -s ${SOURCE} ${target}/source
done

# -----------------------------------------------------------------------------
echo "$(date)  Creating symlinks."
# -----------------------------------------------------------------------------

for f in $(find ${TMP} -name .symlinks); do
  cd $(dirname $f)
  cat $f | while read source destination; do
    ln -sf ${source} ${destination} 2>/dev/null
  done
done
cd ${SOURCE}

# -----------------------------------------------------------------------------
echo "$(date)  Obfuscating email addresses."
# -----------------------------------------------------------------------------

# This replaces all '@' in all html files with '&#64;'. We use '-type f'
# because we want to exclude symlinks. Because 'sed -i' is a very expensive
# operation, even if there is no replacement done anyway, we first limit the
# files to operate on to those files that actually contain an '@'.
find ${TMP} -type f -name "*.html" | xargs grep -l '@' | xargs sed -i 's/@/\&#64;/g'

# -----------------------------------------------------------------------------
echo "$(date)  Creating test site."
# -----------------------------------------------------------------------------

cp -rf ${TMP}/global ${TMP}/test
for file in $(find ${TMP}/test -name "*.test.*"); do
  ln -sf $(basename ${file}) ${file/.test/}
done

# -----------------------------------------------------------------------------
echo "$(date)  Activating new output."
# -----------------------------------------------------------------------------

mv ${DEST} ${DEST}.old
mv ${TMP} ${DEST}
rm -rf ${DEST}.old

# -----------------------------------------------------------------------------
echo "$(date)  Generating translation logs."
# -----------------------------------------------------------------------------

tools/translation-log.sh ${DEST}/translations.log ${STATUS}

# -----------------------------------------------------------------------------
echo "$(date)  Build complete."
# -----------------------------------------------------------------------------

cp ${STATUS}/status.txt ${STATUS}/status-finished.txt
cp tools/status.php ${STATUS}/index.php
