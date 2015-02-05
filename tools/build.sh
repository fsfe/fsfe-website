#!/bin/bash
# -----------------------------------------------------------------------------
# Web page build script
# -----------------------------------------------------------------------------
# This script is called every 5 minutes on www.fsfe.org to rebuild the
# HTML pages from the .xhtml, .xml and .xsl source files. Most of the work,
# however, is done by the Perl script build.pl.
# -----------------------------------------------------------------------------

# Since we must grep for svn output messages,
# let's ensure we get English messages
export LANG="en_US.UTF-8"

# SOURCE=$HOME/fsfe
SOURCE="$(dirname "$0"/..)"
DEST=$HOME/html
TMP=$HOME/tmp.$$
STATUS_URI="http://status.fsfe.org/web/"
STATUS=/var/www/web
DOMAIN=www.fsfe.org
ROBOTS="Disallow: /source/"

TRANS_SCRIPT=translation-log.sh
STATUS_SCRIPT=status.php
SVNUPOUTFILE=/tmp/fsfe-svnup-out
SVNUPERRFILE=/tmp/fsfe-svnup-err

while [ -n "$1" ]; do
  case "$1" in
    test)
      # SOURCE=$HOME/fsfe-test
      DEST=$HOME/html-test
      TMP=$HOME/tmp-test.$$
      STATUS_URI="http://status.fsfe.org/web-test/"
      STATUS=/var/www/web-test
      DOMAIN=test.fsfe.org
      ROBOTS="Disallow: /"

      TRANS_SCRIPT=translation-log-test.sh
      STATUS_SCRIPT=status-test.php
      SVNUPOUTFILE=/tmp/fsfe-test-svnup-out
      SVNUPERRFILE=/tmp/fsfe-test-svnup-err
      ;;
    -d|--dest|--destination) # build destination directory
      shift 1
      DEST="$1"
      ;;
    --domain) # domain name of web site
      shift 1
      DOMAIN="$1"
      ;;
    --tmp|--temp) # temporary build directory, will be moved to dest when finished
      shift 1
      TMP="$1"
      ;;
    --statusdir|--status-dir) # Where to write status
      shift 1
      STATUS="$1"
      ;;
    --statusuri|--status-uri|--statusurl|--status-url) # shoud be HTTP URL to statusdir, only for email message
      shift 1
      STATUS_URI="$1"
      ;;
    --robots) # Content of robots.txt file
      shift 1
      ROBOTS="$1"
      ;;
  esac
  shift 1
done

repourl="$(svn info "$SOURCE" |sed -nr "s;^URL: (.*)$;\1;p")"
case "$repourl" in
  https://svn.fsfe.org/fsfe-web/trunk)
    REPODESIGNATION="SVN trunk"
    ;;
  https://svn.fsfe.org/fsfe-web/branches/test)
    REPODESIGNATION="SVN test branch"
    ;;
  *)
    REPODESIGNATION="$repourl"
    ;;
esac

# Redirect output
exec 1>> ${STATUS}/status.txt 2>&1

# If there is a build.pl script started more than 15 minutes ago, kill it and mail alarm
BUILD_STARTED=$(ps --no-headers -C build.pl -o etime | cut -c 7-8 | sort -r | head -n 1)
if [[ -n "$BUILD_STARTED" && "10#${BUILD_STARTED}" -gt 15 ]] ; then
  echo -e "
  A build.pl script has been running for more than 15 minutes,
  and was automatically killed.

  To debug the problem, please see:
  - Build script log: $STATUS_URI
  - Latest changes in the repository: https://trac.fsfe.org/fsfe-web/timeline
 
  In case of doubt, please write to system-hackers@fsfeurope.org 

  " | mail -s "${DOMAIN}: build.pl warning" web@fsfeurope.org system-hackers@fsfeurope.org
  killall build.pl
  echo "$(date) A build.pl script has been running for more than 15 minutes, and was automatically killed."
  exit
fi

# If some build script is already running, don't run it.
if ps -C "build-df.sh,build-df-test.sh,build.sh" -o pid= | grep -q -v "$$"; then
  echo "$(date) Another build script is currently running. Build postponed."
  exit
fi

cd ${SOURCE}

# -----------------------------------------------------------------------------
echo "$(date)  Cleaning old build directories."
# -----------------------------------------------------------------------------

rm -rf ${TMP%.*}.*

# -----------------------------------------------------------------------------
echo "$(date)  Updating source files from ${REPODESIGNATION}."
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

  Please check the build script log at $STATUS_URI
  and fix the cause of the problem.
 
  In case of doubt, please write to system-hackers@fsfeurope.org 

  " | mail -s "${DOMAIN}: svn error" web@fsfeurope.org system-hackers@fsfeurope.org
  exit
fi

# If there are conflicts in the working copy, exit
if grep -q '^C' "${SVNUPOUTFILE}"; then
  echo "$(date)  There are conflicts in the local svn working copy. Build aborted"
  cat ${STATUS}/status.txt >> ${STATUS}/status-log.txt
  mv  ${STATUS}/status.txt ${STATUS}/status-attempted.txt
  echo -e "
  There are conflicts in the local svn working copy. Build aborted

  `cat ${SVNUPOUTFILE}`

  Please check the build script log at $STATUS_URI
  and fix the cause of the problem.
 
  In case of doubt, please write to system-hackers@fsfeurope.org 

  " | mail -s "${DOMAIN}: svn conflict" web@fsfeurope.org system-hackers@fsfeurope.org
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
  echo "$(date)  No changes to ${REPODESIGNATION}."
  echo "$(date)  $(svn info 2>/dev/null | grep '^Revision')"
  cat ${STATUS}/status.txt >> ${STATUS}/status-log.txt
  mv  ${STATUS}/status.txt ${STATUS}/status-attempted.txt
  exit
fi

# -----------------------------------------------------------------------------
echo "$(date)  Checking Perl modules."
# -----------------------------------------------------------------------------

perl ${SOURCE}/build/checkdepends.pl

# Make sure build.sh and build.pl are executable
# TODO: this can be removed once we set the "executable" svn property
# to these files
chmod +x tools/build.sh tools/build.pl
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

cpu_cores="$(cat /proc/cpuinfo |grep ^processor |wc -l)"
[ "$cpu_cores" -eq 0 ] && cpu_cores=1

tools/build.pl -t "$cpu_cores" -q -o ${TMP} -i .

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

echo -e "User-agent: *\n${ROBOTS}" > ${TMP}/global/robots.txt

# -----------------------------------------------------------------------------
echo "$(date)  Activating new output."
# -----------------------------------------------------------------------------

mv ${DEST} ${DEST}.old
mv ${TMP} ${DEST}
rm -rf ${DEST}.old

# -----------------------------------------------------------------------------
echo "$(date)  Generating translation logs."
# -----------------------------------------------------------------------------

tools/${TRANS_SCRIPT} ${DEST}/translations.log ${STATUS}

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
cp tools/${STATUS_SCRIPT} ${STATUS}/index.php
