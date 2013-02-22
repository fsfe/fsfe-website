#!/bin/bash
#
# Create header and footer template files for the Fellowship 
# Account Management System, using the /fellowship/index.xx.html
# files as a reference

# Directory where the /fellowship html files are written by the build process
#
# We assume that the script is called by build.sh passing $1 as the $DEST
# directory defined in build.sh (so that we can reuse this script in both production
# and test instances)
if [ -z "$1" ] ; then
  echo "You must supply a DEST directory"
  exit 1
else
  FELLDIR=$1/global/fellowship
fi

# Directory where the template files are expected by the AMS
TPLDIR=$FELLDIR/tpl
mkdir -p $TPLDIR

# Working directory for this script
WRKDIR=`mktemp -d`

cp $FELLDIR/index.*.html $WRKDIR

cd $WRKDIR

for i in `ls index.*.html` ; do
  # Extract language code from file name
  LANGUAGE=`echo $i | cut -d '.' -f 2`

  # Split after the '<body>' => h100
  # TODO: use custom marker
  csplit -f h1 -s $i '%<body>%1'
  # Discard from h100 after '<div id="fellowship">' => h200 is our header template
  # TODO: use custom marker
  csplit -f h2 -s h100 '/<div id="fellowship">/1'
  mv h200 $TPLDIR/tpl_header.$LANGUAGE.html
  
  # Split after the '<div id="footer">' => f100 is our footer template
  # TODO: use custom marker
  csplit -f f1 -s $i '%<div id="footer">%-4'
  mv f100 $TPLDIR/tpl_footer.$LANGUAGE.html
done

rm -rf $WRKDIR
