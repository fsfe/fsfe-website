#!/bin/bash

# This script is called by build.sh to create the translation log html
# files from the translations.log file created by build.pl.
#
# Copyright (C) 2005 Free Software Foundation Europe
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
# 02111-1307, USA.

# -----------------------------------------------------------------------------
# Constants
# -----------------------------------------------------------------------------

srcroot="http://www.fsfeurope.org/source"
cvsroot="http://savannah.gnu.org/cgi-bin/viewcvs/fsfe/fsfe"


# -----------------------------------------------------------------------------
# Parameters
# -----------------------------------------------------------------------------

infile=$1
outdir=$2


# -----------------------------------------------------------------------------
# Create a separate file per language
# -----------------------------------------------------------------------------

# Remove all "./" at the beginning of filenames, remove all filenames mentioned
# in notranslations.txt, and create a separate file per language
sort ${infile} \
  | uniq \
  | sed --expression='s/\.\///g' \
  | grep --invert-match --file=tools/translation-ignore.txt \
  | while read language wantfile havefile; do
  if [ -f ${wantfile} ]; then
    group="outdated"
  else
    group="missing"
  fi
  date="$(date --iso-8601 --reference=${havefile})"
  echo "${group} ${date} ${wantfile} ${havefile}" >> ${infile}.$language
done


# -----------------------------------------------------------------------------
# Convert the ASCII files to HTML files
# -----------------------------------------------------------------------------

for file in ${infile}.*; do
  language=${file##*.}
  (
    echo "<html>"
    echo "  <head>"
    echo "    <title>Translation status for ${language}</title>"
    echo "  </head>"
    echo "  <body>"
    echo "    <h1>Translation status for ${language}</h1>"
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
          echo "        <th colspan=\"2\">translated file</th>"
          echo "        <th colspan=\"2\">original file</th>"
          echo "      </tr>"
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
          echo "        <th>translated file</th>"
          echo "        <th>original file</th>"
          echo "      </tr>"
        fi
        lastgroup="${group}"
      fi

      echo "      <tr>"
      echo "        <td align=\"center\">${date}</td>"
      if [ "${group}" = "outdated" ]; then
        echo "        <td>"
        echo "          <a href=\"${srcroot}/${wantfile}\">${wantfile}</a>"
        echo "        </td>"
        echo "        <td>"
        echo "          <a href=\"${cvsroot}/${wantfile}?cvsroot=Web\">[changelog]</a>"
        echo "        </td>"
        echo "        <td>"
        echo "          <a href=\"${srcroot}/${havefile}\">${havefile}</a>"
        echo "        </td>"
        echo "        <td>"
        echo "          <a href=\"${cvsroot}/${havefile}?cvsroot=Web\">[changelog]</a>"
        echo "        </td>"
      else
        echo "        <td>"
        echo "          ${wantfile}"
        echo "        </td>"
        echo "        <td>"
        echo "          <a href=\"${srcroot}/${havefile}\">${havefile}</a>"
        echo "        </td>"
      fi
      echo "      </tr>"
    done
    if [ "${lastgroup}" != "" ]; then
      echo "    </table>"
    fi
    echo "  </body>"
    echo "</html>"
  ) > $outdir/$language.html
done


# -----------------------------------------------------------------------------
# Create hit parade of outdated translations
# -----------------------------------------------------------------------------

grep --no-filename "^outdated" ${infile}.* \
  | sort --key=2 \
  | (
    echo "<html>"
    echo "  <head>"
    echo "    <title>Hit parade of outdated translations</title>"
    echo "  </head>"
    echo "  <body>"
    echo "    <h1>Hit parade of outdated translations</h1>"
    echo "    <table border=\"1\" cellspacing=\"0\" cellpadding=\"3\">"
    echo "      <tr>"
    echo "        <th>outdated since</th>"
    echo "        <th colspan=\"2\">translated file</th>"
    echo "        <th colspan=\"2\">original file</th>"
    echo "      </tr>"
    while read group date wantfile havefile; do
      echo "      <tr>"
      echo "        <td align=\"center\">${date}</td>"
      echo "        <td>"
      echo "          <a href=\"${srcroot}/${wantfile}\">${wantfile}</a>"
      echo "        </td>"
      echo "        <td>"
      echo "          <a href=\"${cvsroot}/${wantfile}?cvsroot=Web\">[changelog]</a>"
      echo "        </td>"
      echo "        <td>"
      echo "          <a href=\"${srcroot}/${havefile}\">${havefile}</a>"
      echo "        </td>"
      echo "        <td>"
      echo "          <a href=\"${cvsroot}/${havefile}?cvsroot=Web\">[changelog]</a>"
      echo "        </td>"
    done
    echo "      </tr>"
    echo "    </table>"
    echo "  </body>"
    echo "</html>"
  ) > $outdir/outdated.html


# -----------------------------------------------------------------------------
# Create the overview page
# -----------------------------------------------------------------------------

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
  echo "    </table>"
  echo "  </body>"
  echo "</html>"
) > $outdir/translations.html
