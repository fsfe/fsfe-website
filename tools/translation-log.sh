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
    lastgroup=""
    sort -r ${file} | while read group date wantfile havefile; do
      htmlfile="${wantfile%.xhtml}.html"

      if [ "${group}" != "${lastgroup}" ]; then
        if [ "${group}" == "outdated" ]; then
          echo "    <h2>Outdated translations</h2>"
          echo "    The following pages are already translated. However, the"
          echo "    original version has been changed since the translation"
          echo "    was done, and the translation has not been updated so far"
          echo "    to reflect these changes.<br /><br />"
          echo "    Updating these translations is generally considered more"
          echo "    urgent than translating new pages.<br /><br />"
        elif [ "${group}" == "missing" ]; then
          echo "    <h2>Missing translations</h2>"
          echo "    The following pages have not yet been translated."
          echo "    <br /><br />"
          echo "    This list is ordered by the date of the original version,"
          echo "    newest first. Generally, it's a good idea to translate"
          echo "    newer texts before older ones, as people will probably be"
          echo "    more interested in current information.<br /><br />"
        fi
        lastgroup="${group}"
      fi

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

# Finally, create the overview page
(
  echo "<html>"
  echo "  <head>"
  echo "    <title>Translation status overview</title>"
  echo "  </head>"
  echo "  <body>"
  echo "    <h1>Translation status overview</h1>"
  for file in ${infile}.*; do
    language=${file##*.}
    outdated=$(grep "^outdated" ${file} | wc --lines)
    missing=$(grep "^missing" ${file} | wc --lines)
    echo "    <a href=\"${language}.html\">${language}</a>:"
    echo "    ${outdated} outdated, ${missing} missing"
    echo "    <br />"
  done
  echo "  </body>"
  echo "</html>"
) > $outdir/translations.html
