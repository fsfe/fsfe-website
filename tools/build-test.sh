#!/bin/bash
# -----------------------------------------------------------------------------
# Web page build script
# -----------------------------------------------------------------------------
# This script is called every 5 minutes on test.fsfe.org to rebuild the
# HTML pages from the .xhtml, .xml and .xsl source files. Most of the work,
# however, is done by the Perl script build-test.pl.
# -----------------------------------------------------------------------------

SOURCE=/home/www/fsfe-test
DEST=/home/www/html-test
TMP=/home/www/tmp-test.$$
STATUS=/var/www/web-test
MAKEFILE_PL=${SOURCE}/Makefile.PL
SVNUPOUTFILE=/tmp/fsfe-test-svnup-out
SVNUPERRFILE=/tmp/fsfe-test-svnup-err

# Since we must grep for svn output messages,
# let's ensure we get English messages
export LANG="en_US.UTF-8"

# Redirect output
exec 1>> ${STATUS}/status.txt 2>&1

# If there is a build-test.pl script started more than 10 minutes ago, kill it and mail alarm
BUILD_STARTED=$(ps --no-headers -C build-test.pl -o etime | cut -c 7-8 | sort -r | head -n 1)
if [[ -n "$BUILD_STARTED" && "10#${BUILD_STARTED}" -gt 10 ]] ; then
  echo -e "
  A build-test.pl script has been running for more than 10 minutes,
  and was automatically killed.
  
  Please check the build script log at http://status.fsfe.org/web-test/
  and fix the cause of the problem.

  In case of doubt, please write to system-hackers@fsfeurope.org 

  " | mail -s "test.fsfe.org: build-test.pl warning" web@fsfeurope.org system-hackers@fsfeurope.org
  killall build-test.pl
  echo "$(date) A build-test.pl script has been running for more than 10 minutes, and was automatically killed."
  exit
fi

# If some build script is already running, don't run it.
if ps -C "build-df.sh,build-df-test.sh,build-test.sh,build.sh" -o pid= | grep -q -v "$$"; then
  echo "$(date) Another build script is currently running. Build postponed."
  exit
fi

cd ${SOURCE}

# -----------------------------------------------------------------------------
echo "$(date)  Cleaning old build directories."
# -----------------------------------------------------------------------------

rm -rf ${TMP%.*}.*

# -----------------------------------------------------------------------------
echo "$(date)  Updating source files from SVN test branch."
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
  mv  ${STATUS}/status.txt ${STATUS}/status-attempted.txt
  echo -e "
  svn update produced the following error message. Build aborted

  `cat ${SVNUPERRFILE}`

  Please check the build script log at http://status.fsfe.org/web-test/
  and fix the cause of the problem.
 
  In case of doubt, please write to system-hackers@fsfeurope.org 

  " | mail -s "www.fsfe.org: svn error" web@fsfeurope.org system-hackers@fsfeurope.org
  exit
fi

# If there are conflicts in the working copy, exit
if test -n "$(grep '^C' ${SVNUPOUTFILE})" ; then
  echo "$(date)  There are conflicts in the local svn working copy. Build aborted"
  cat ${STATUS}/status.txt >> ${STATUS}/status-log.txt
  mv  ${STATUS}/status.txt ${STATUS}/status-attempted.txt
  echo -e "
  There are conflicts in the local svn working copy. Build aborted

  `cat ${SVNUPOUTFILE}`

  Please check the build script log at http://status.fsfe.org/web-test/
  and fix the cause of the problem.
 
  In case of doubt, please write to system-hackers@fsfeurope.org 

  " | mail -s "www.fsfe.org: svn conflict" web@fsfeurope.org system-hackers@fsfeurope.org
  exit
fi

# Don't rebuild the site if no changes were made to the SVN
# (unless it hasn't run yet today, or unless the "-f" option is used)
#
# We must run it once every day at least to move events from future to current
# and from current to past.
if test ! -s ${SVNUPOUTFILE} \
    -a "$(date -r ${STATUS}/last-run +%F)" == "$(date +%F)" \
    -a "$1" != "-f" ; then
  echo "$(date)  No changes to SVN test branch."
  echo "$(date)  $(svn info 2>/dev/null | grep '^Revision')"
  cat ${STATUS}/status.txt >> ${STATUS}/status-log.txt
  mv  ${STATUS}/status.txt ${STATUS}/status-attempted.txt
  exit
fi

# -----------------------------------------------------------------------------
echo "$(date)  Checking Perl modules."
# -----------------------------------------------------------------------------

perl ${MAKEFILE_PL}

# Make sure build-test.sh and build-test.pl are executable
# TODO: this can be removed once we set the "executable" svn property
# to these files
chmod +x tools/build-test.sh tools/build-test.pl
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
  tools/build-test.pl -t 4 -q -o ${TMP} -i .
else
  tools/build-test.pl -q -o ${TMP} -i .
fi

if test $? -ne 0; then
   echo "$(date)  Build not complete. Aborting."
   cat ${STATUS}/status.txt >> ${STATUS}/status-log.txt
   mv  ${STATUS}/status.txt ${STATUS}/status-attempted.txt
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
echo "$(date)  Generating robots.txt."
# -----------------------------------------------------------------------------

echo -e "User-agent: *\nDisallow: /" > ${TMP}/global/robots.txt

# -----------------------------------------------------------------------------
echo "$(date)  Activating new output."
# -----------------------------------------------------------------------------

mv ${DEST} ${DEST}.old
mv ${TMP} ${DEST}
rm -rf ${DEST}.old

# -----------------------------------------------------------------------------
echo "$(date)  Generating translation logs."
# -----------------------------------------------------------------------------

tools/translation-log-test.sh ${DEST}/translations.log ${STATUS}

# -----------------------------------------------------------------------------
echo "$(date)  Generating Fellowship header/footer templates."
# -----------------------------------------------------------------------------

tools/make_fellowship_templates.sh $DEST

# -----------------------------------------------------------------------------
echo "$(date)  Build complete."
# -----------------------------------------------------------------------------

cat ${STATUS}/status.txt >> ${STATUS}/status-log.txt
mv ${STATUS}/status.txt ${STATUS}/status-finished.txt
rm -f ${STATUS}/status-attempted.txt
cp tools/status-test.php ${STATUS}/index.php
