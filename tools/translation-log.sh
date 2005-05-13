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
    echo "    <p>"
    echo "      The following translations are missing or are not up to date"
    echo "      with the original any more."
    echo "    </p>"
    echo "    <p>"
    echo "      Please translate the XHTML files!"
    echo "    </p>"
    lastgroup=""
    sort -r ${file} | while read group date wantfile havefile; do
      if [ "${group}" != "${lastgroup}" ]; then
        if [ "${group}" == "outdated" ]; then
          echo "    <h2>Outdated translations</h2>"
          echo "    <p>"
          echo "      The following pages are already translated. However, the"
          echo "      original version has been changed since the translation"
          echo "      was done, and the translation has not been updated so far"
          echo "      to reflect these changes."
          echo "    </p>"
          echo "    <p>"
          echo "      Updating these translations is generally considered more"
          echo "      urgent than translating new pages."
          echo "    </p>"
          echo "    <table border=\"1\" cellspacing=\"0\" cellpadding=\"3\">"
          echo "      <tr>"
          echo "        <th>outdated since</th>"
        elif [ "${group}" == "missing" ]; then
          if [ "${lastgroup}" == "outdated" ]; then
            echo "    </table>"
          fi
          echo "    <h2>Missing translations</h2>"
          echo "    <p>"
          echo "      The following pages have not yet been translated."
          echo "    </p>"
          echo "    <p>"
          echo "      This list is ordered by the date of the original version,"
          echo "      newest first. Generally, it's a good idea to translate"
          echo "      newer texts before older ones, as people will probably be"
          echo "      more interested in current information."
          echo "    </p>"
          echo "    <table border=\"1\" cellspacing=\"0\" cellpadding=\"3\">"
          echo "      <tr>"
          echo "        <th align=\"center\">missing since</th>"
        fi
        lastgroup="${group}"
        echo "        <th>translated file</th>"
        echo "        <th>original file</th>"
        echo "      </tr>"
      fi

      echo "      <tr>"
      echo "        <td align=\"center\">${date}</td>"
      if [ "${group}" = "outdated" ]; then
        echo "        <td><a href=\"http://www.fsfeurope.org/source/${wantfile}\">${wantfile}</a></td>"
      else
        echo "        <td>${wantfile}</td>"
      fi
      echo "        <td><a href=\"http://www.fsfeurope.org/source/${havefile}\">${havefile}</a></td>"
      echo "      </tr>"
    done
    if [ "${lastgroup}" != "" ]; then
      echo "    </table>"
    fi
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
  echo "    <table border=\"1\" cellspacing=\"0\" cellpadding=\"3\">"
  echo "      <tr>"
  echo "        <th align=\"center\">language</td>"
  echo "        <th align=\"center\">outdated translations</td>"
  echo "        <th align=\"center\">missing translations</td>"
  echo "      </tr>"
  for file in ${infile}.*; do
    language=${file##*.}
    outdated=$(grep "^outdated" ${file} | wc --lines)
    missing=$(grep "^missing" ${file} | wc --lines)
    echo "      <tr>"
    echo "        <td align=\"center\"><a href=\"${language}.html\">${language}</a></td>"
    echo "        <td align=\"center\">${outdated}</td>"
    echo "        <td align=\"center\">${missing}</td>"
    echo "      </tr>"
  done
  echo "    </table border=\"0\">"
  echo "  </body>"
  echo "</html>"
) > $outdir/translations.html
