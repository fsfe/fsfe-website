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

testroot="http://test.fsfe.org"
srcroot="http://test.fsfe.org/source"
cvsroot="https://trac.fsfe.org/fsfe-web/log/branches/test"


# -----------------------------------------------------------------------------
# Parameters
# -----------------------------------------------------------------------------

infile=$1
outdir=$2


# -----------------------------------------------------------------------------
# Create a separate file per language
# -----------------------------------------------------------------------------

# Remove all "./" at the beginning of filenames, and create a separate file per
# language. For missing translations, remove all files mentioned in
# translation-ignore.txt.

# Performance seems to be much better if we do it in 2 separate runs.
# Otherwise, we would have to run the grep for each line of the file.

# Addition by Paul, 2014-06-23 - The egrep filters out some malformed input
# lines produced by build pl. Those faulty lines should not be there in the
# first place, so this is a lousy workaround.

# First run: missing translations
sort "${infile}" \
  | uniq \
  | sed --expression='s/\.\///g' \
  | grep --invert-match --file="tools/translation-ignore.txt" \
  | egrep '?? .+ .+' translations.log \
  | while read language wantfile havefile; do
  if [ ! -f "${wantfile}" ]; then
    if test -z "${havefile}" ; then
      echo "$(date)  Missing havefile for want <${wantfile}>"
    else
      date="$(date --iso-8601 --reference=${havefile})"
      echo "missing ${date} ${wantfile} NONE ${havefile}" >> "${infile}.${language}"
    fi
  fi
done

# Second run: outdated translations
sort "${infile}" \
  | uniq \
  | sed --expression='s/\.\///g' \
  | while read language wantfile havefile comment; do
  if [ -f "${wantfile}" ]; then
    date1="$(date --iso-8601 --reference=${wantfile})"
    date2="$(date --iso-8601 --reference=${havefile})"
    echo "outdated ${date2} ${wantfile} ${date1} ${havefile} ${comment}" >> "${infile}.${language}"
  fi
done


# -----------------------------------------------------------------------------
# Convert the ASCII files to HTML files
# -----------------------------------------------------------------------------

for file in ${infile}.*; do
  language=${file##*.}
  (
    echo "<!doctype html>"
    echo "<html>"
    echo "  <head>"
    echo "    <meta charset=\"utf-8\" />"
    echo "    <title>Translation status for ${language} (test instance)</title>"
    echo "  </head>"
    echo "  <body>"
    echo "    <h1>Translation status for ${language} (test instance)</h1>"
    echo "    <p>"
    echo "      <a href=\"translations.html\">« Back to <em>Translation status overview</em></a>"
    echo "    </p>"
    lastgroup=""
    sort --reverse ${file} | while read group date2 wantfile date1 havefile comment; do
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
          echo "        <th colspan=\"3\">translated file</th>"
          echo "        <th colspan=\"3\">original file</th>"
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
          echo "        <th>translated file</th>"
          echo "        <th>original file</th>"
          echo "        <th align=\"center\">last change of original</th>"
          echo "      </tr>"
        fi
        lastgroup="${group}"
      fi

      echo "      <tr>"
      if [ "${group}" = "outdated" ]; then
        echo "        <td>"
        echo "          <a href=\"${srcroot}/${wantfile}\">${wantfile}</a> (${comment} - <a href=\"${testroot}/${wantfile:0:${#wantfile}-5}html\">test</a>)"
        echo "        </td>"
        echo "        <td align=\"center\">${date1}</td>"
        echo "        <td>"
        echo "          <a href=\"${cvsroot}/${wantfile}\">[changelog]</a>"
        echo "        </td>"
        echo "        <td>"
        echo "          <a href=\"${srcroot}/${havefile}\">${havefile}</a>"
        echo "        </td>"
        echo "        <td align=\"center\">${date2}</td>"
        echo "        <td>"
        echo "          <a href=\"${cvsroot}/${havefile}\">[changelog]</a>"
        echo "        </td>"
      else
        echo "        <td>"
        echo "          ${wantfile}"
        echo "        </td>"
        echo "        <td>"
        echo "          <a href=\"${srcroot}/${havefile}\">${havefile}</a>"
        echo "        </td>"
        echo "        <td align=\"center\">${date2}</td>"
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
    echo "<!doctype html>"
    echo "<html>"
    echo "  <head>"
    echo "    <meta charset=\"utf-8\" />"
    echo "    <title>Hit parade of outdated translations (test instance)</title>"
    echo "    <style>"
    echo "      table,"
    echo "      th,"
    echo "      td {"
    echo "        border: 1px outset gray;"
    echo "      }"
    echo "      th,"
    echo "      td {"
    echo "        padding: 3px;"
    echo "      }"
    echo "    </style>"
    echo "  </head>"
    echo "  <body>"
    echo "    <h1>Hit parade of outdated translations (test instance)</h1>"
    echo "    <p>"
    echo "      <a href=\"translations.html\">« Back to <em>Translation status overview</em></a>"
    echo "    </p>"
    echo "    <table>"
    echo "      <tr>"
    echo "        <th colspan=\"3\">translated file</th>"
    echo "        <th colspan=\"3\">original file</th>"
    echo "      </tr>"
    while read group date2 wantfile date1 havefile comment; do
      echo "      <tr>"
      echo "        <td>"
      echo "          <a href=\"${srcroot}/${wantfile}\">${wantfile}</a> (${comment})"
      echo "        </td>"
      echo "        <td align=\"center\">${date1}</td>"
      echo "        <td>"
      echo "          <a href=\"${cvsroot}/${wantfile}\">[changelog]</a>"
      echo "        </td>"
      echo "        <td>"
      echo "          <a href=\"${srcroot}/${havefile}\">${havefile}</a>"
      echo "        </td>"
      echo "        <td align=\"center\">${date2}</td>"
      echo "        <td>"
      echo "          <a href=\"${cvsroot}/${havefile}\">[changelog]</a>"
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
  echo "<!doctype html>"
  echo "<html>"
  echo "  <head>"
  echo "    <meta charset=\"utf-8\" />"
  echo "    <title>Translation status overview (test instance)</title>"
  echo "    <style>"
  echo "      table,"
  echo "      th,"
  echo "      td {"
  echo "        border: 1px outset gray;"
  echo "      }"
  echo "      th,"
  echo "      td {"
  echo "        padding: 3px;"
  echo "        text-align: center;"
  echo "      }"
  echo "    </style>" 
  echo "  </head>"
  echo "  <body>"
  echo "    <h1>Translation status overview (test instance)</h1>"
  echo "    <p>"
  echo "      <a href=\"http://status.fsfe.org/\">« Back to <em>Web server status</em></a>"
  echo "    </p>"
  echo "    <table>"
  echo "      <tr>"
  echo "        <th>language</td>"
  echo "        <th>outdated translations</td>"
  echo "        <th>missing translations</td>"
  echo "      </tr>"
  for file in ${infile}.*; do
    language=${file##*.}
    outdated=$(grep "^outdated" ${file} | wc --lines)
    missing=$(grep "^missing" ${file} | wc --lines)
    echo "      <tr>"
    echo "        <td><a href=\"${language}.html\">${language}</a></td>"
    echo "        <td>${outdated}</td>"
    echo "        <td>${missing}</td>"
    echo "      </tr>"
  done
  echo "    </table>"
  echo "    <p>"
  echo "      A <a href=\"outdated.html\">hit parade of outdated translations</a>"
  echo "      for all languages is also available."
  echo "    </p>"
  echo "  </body>"
  echo "</html>"
) > $outdir/translations.html

