#!/bin/bash
# -----------------------------------------------------------------------------
# Web page build script
# -----------------------------------------------------------------------------
# This script is called every 5 minutes on www.fsfe.org to rebuild the
# HTML pages from the .xhtml, .xml and .xsl source files. Most of the work,
# however, is done by the Perl script build2.pl.
# -----------------------------------------------------------------------------

SOURCE=.
DEST=../fsfe-web-out/home/www/html
TMP=../fsfe-web-out/home/www/tmp.$$
STATUS=../fsfe-web-out/var/www/web
SVNUPOUTFILE=../fsfe-web-out/tmp/fsfe-svnup-out
SVNUPERRFILE=../fsfe-web-out/tmp/fsfe-svnup-err

# Since we must grep for svn output messages,
# let's ensure we get English messages
export LANG=C

# If there is a build2.pl script started more than 10 minutes ago, kill it and mail alarm
BUILD_STARTED=$(ps --no-headers -C build2.pl -o etime | cut -c 7-8 | sort -r | head -n 1)
if [[ -n "$BUILD_STARTED" && "10#${BUILD_STARTED}" -gt 10 ]] ; then
  echo -e "
  A build2.pl script has been running for more than 10 minutes,
  and was automatically killed.

  Please check the build script log at http://status.fsfe.org/web-test/
  and fix the cause of the problem.
 
  In case of doubt, please write to system-hackers@fsfeurope.org 

  " | mail -s "www.fsfe.org: build2.pl warning" web@fsfeurope.org system-hackers@fsfeurope.org

fi

# Redirect output
#exec 1> ${STATUS}/status.txt 2>&1

# If some build script is already running, don't run it.
if ps -C "build-df.sh,build-test.sh,build.sh" -o pid= | grep -q -v "$$"; then
  echo "Another build script is currently running. Build postponed."
  exit
fi

cd ${SOURCE}

# -----------------------------------------------------------------------------
echo "$(date)  Cleaning old build directories."
# -----------------------------------------------------------------------------

rm -rf ${TMP%.*}.*

# -----------------------------------------------------------------------------
echo "$(date)  Updating source files from SVN."
# -----------------------------------------------------------------------------

# Update the svn working copy and check if any files were updated.
# Since the "svn update" exit status cannot be trusted, and "svn update -q" is
# always quiet, we have to test the output of "svn update" (ignoring the final
# "At revision" line) and check for any output lines
svn --non-interactive update 2>${SVNUPERRFILE} | grep -v 'At revision' >${SVNUPOUTFILE}
cat ${SVNUPOUTFILE}

# If "svn update" wrote anything to standard error, exit
if test -s ${SVNUPERRFILE} ; then
  echo "$(date)  svn update produced the following error message. Build aborted"
  cat ${SVNUPERRFILE}
  cat ${STATUS}/status.txt >> ${STATUS}/status-log.txt
  exit
fi

# If there are conflicts in the working copy, exit
if test -n "$(grep '^C' ${SVNUPOUTFILE})" ; then
  echo "$(date)  There are conflicts in the local svn working copy. Build aborted"
  cat ${STATUS}/status.txt >> ${STATUS}/status-log.txt
  exit
fi

# Rebuild only if changes were made to the SVN or it hasn't run yet today
# (unless "-f" option is used)
#
# We must run it once every day at least to move events from future to current
# and from current to past.
if test ! -s ${SVNUPOUTFILE} \
    -a "$(date -r ${STATUS}/last-run +%F)" == "$(date +%F)" \
    -a "$1" != "-f" ; then
  echo "$(date)  No changes to SVN."
  echo "$(date)  $(svn info 2>/dev/null | grep '^Revision')"
  # In this case we only append to the cumulative status-log.txt file, we don't touch status-finished.txt
  cat ${STATUS}/status.txt >> ${STATUS}/status-log.txt
  exit
fi

# -----------------------------------------------------------------------------
echo "$(date)  Checking Perl modules."
# -----------------------------------------------------------------------------

perl ${SOURCE}/build/checkdepends.pl

# Make sure build.sh and build2.pl are executable
# TODO: this can be removed once we set the "executable" svn property
# to these files
chmod +x tools/build.sh tools/build2.pl
chmod +x cgi-bin/weborder.pl cgi-bin/stacs-register-capacity.pl
chmod +x cgi-bin/stacs-register-workshop.pl

if test "$1" == "-f" ; then
  echo "Forced rebuild"
fi

# -----------------------------------------------------------------------------
echo "$(date)  Running Makefiles."
# -----------------------------------------------------------------------------

make --silent

# -----------------------------------------------------------------------------
echo "$(date)  Building HTML pages."
# -----------------------------------------------------------------------------

touch ${STATUS}/last-run

if test "x`hostname`" = "xekeberg"; then
  tools/build2.pl -t 4 -q -o ${TMP} -i .
else
  tools/build2.pl -q -o ${TMP} -i .
fi

if test $? -ne 0; then
   echo "$(date)  Build not complete. Aborting."
   cp ${STATUS}/status.txt ${STATUS}/status-finished.txt
   cat ${STATUS}/status-finished.txt >> ${STATUS}/status-log.txt
   exit 1
fi

# -----------------------------------------------------------------------------
echo "$(date)  Linking source files."
# -----------------------------------------------------------------------------

for target in ${TMP}/*; do
  test -d ${target} && ln -s ${SOURCE} ${target}/source
done

cd ${SOURCE}

# -----------------------------------------------------------------------------
echo "$(date)  Obfuscating email addresses."
# -----------------------------------------------------------------------------

# This replaces all '@' in all html files with '&#64;'. We use '-type f'
# because we want to exclude symlinks (TODO: is -type f still useful now that
# we don't have .symlinks anymore?). Because 'sed -i' is a very expensive
# operation, even if there is no replacement done anyway, we first limit the
# files to operate on to those files that actually contain an '@'.
find ${TMP} -type f -name "*.html" | xargs grep -l '@' | xargs sed -i 's/@/\&#64;/g'

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
cat ${STATUS}/status-finished.txt >> ${STATUS}/status-log.txt
cp tools/status.php ${STATUS}/index.php
