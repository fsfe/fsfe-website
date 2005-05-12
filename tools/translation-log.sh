#!/bin/bash

# This file is called by build.sh to create the translation log html files from
# the translations.log file created by build.pl.

infile=$1
outdir=$2

# First, create a separate file per language
sort ${infile} | uniq | while read language wantfile havefile; do
  if [ -f ${wantfile} ]; then
    group="outdated"
  else
    group="missing"
  fi
  date="$(date --iso-8601 --reference=${havefile})"
  echo "${group} ${date} ${wantfile#./} ${havefile#./}" >> ${infile}.$language
done

# Now, convert the ASCII file to HTML
for file in ${infile}.*; do
  language=${file##*.}
  (
    echo "<html>"
    echo "  <head>"
    echo "    <title>Translation status for ${language}</title>"
    echo "  </head>"
    echo "  <body>"
    echo "    <h1>Translation status for ${language}</h1>"
    echo "    The following translations are missing or are not up to date"
    echo "    with the original any more."
    echo "    <br /><br />"
    echo "    Please translate the XHTML files!"
    echo "    <br /><br />"
    sort -r ${file} | while read group date wantfile havefile; do
      htmlfile="${wantfile%.xhtml}.html"
      if [ "${group}" = "outdated" ]; then
        echo "    Outdated since ${date}:"
      else
        echo "    Missing since ${date}:"
      fi
      echo "    <a href=\"http://www.fsfeurope.org/${htmlfile}\">${htmlfile}</a>"
      if [ "${group}" = "outdated" ]; then
        echo "    - <a href=\"http://www.fsfeurope.org/source/${wantfile}\">[translated XHTML]</a>"
      fi
      echo "    - <a href=\"http://www.fsfeurope.org/source/${havefile}\">[original XHTML]</a>"
      echo "    <br />"
    done
    echo "  </body>"
    echo "</html>"
  ) > $outdir/$language.html
done
