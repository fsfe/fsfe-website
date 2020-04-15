#!/usr/bin/env bash

print_usage() {
  echo "Check the translation status of a file"
  echo ""
  echo "Usage: ./check-translation-status.sh [-a] [-q] -f file.en.xml"
  echo ""
  echo " -f <FILENAME>"
  echo " (Relative or absolute path to file that shall be checked)"
  echo ""
  echo " -o up|out"
  echo " (Only print language code whose translations are up-to-date or outdated)"
  echo ""
  echo " -a (If given, checks all available translations of the file)"
  echo ""
  echo " -q (If given, do not write anything to STDOUT)"
  echo ""
  echo " -h (HELP)"
  echo ""
  echo "Exit codes:"
  echo " 0 = file is up-to-date"
  echo " 1 = file is outdated"
  echo " 2 = file is not supported"
  exit 0
}

basedir=$(dirname $(dirname $(realpath $0)))

ALL="0"
QUIET="0"
while getopts f:o:aqh OPT; do
  case $OPT in
    f)  FILE=$OPTARG;;  # file name
    a)  ALL="1";;
    q)  QUIET="1";;
    o)  ONLY=$OPTARG;;  # print only languages which are up/outdated
    h)  print_usage;;
    *)  print_usage;;
  esac
done

# show usage if no required parameter given
if [ "$1" = "" ] || [ -z "${FILE}" ]; then
  print_usage
  exit 0
fi

# -o suppresses all other output (-q), and implicates -a
if [ -n "${ONLY}" ]; then
  QUIET="1"
  ALL="1"
fi

function out {
  if [ "${QUIET}" != "1" ]; then
    echo "$@"
  fi
}

# Get file extension
EXT="${FILE##*.}"
if ! [[ "${EXT}" =~ ^(xhtml|xml)$ ]]; then
  out "Only works for files ending with .xhtml or .xml"
  exit 2
fi

# remove "en.$EXT"
BASE=$(echo "${FILE}" | sed -E "s/\.[a-z][a-z]\.${EXT}//")
# get change date of English file
EN="${BASE}".en."${EXT}"
if [ ! -e "${EN}" ]; then
  out "English file does not exist. Aborting. (${EN})"
  exit 0
fi
envers=$(xsltproc ${basedir}/build/xslt/get_version.xsl "${EN}")

out "Basefile: ${EN} (Version ${envers:-not set})"
out "  STATUS      LANG   VERSION"
out "  --------    ----   -------"

if [ "${ALL}" == "1" ]; then
  # Loop over all translations of this file
  for i in "${BASE}".[a-z][a-z]."${EXT}"; do
    if [[ $i != *".en."* ]]; then
      # get language code
      lang=$(echo "${i}"|sed "s/.*\.\([a-z][a-z]\)\.${EXT}/\1/")
      # get version of translation
      trvers=$(xsltproc ${basedir}/build/xslt/get_version.xsl "${i}")
      # mark as outdated if version differs
      if [ ${trvers:-0} -lt ${envers:-0} ]; then
        out "  OUTDATED     ${lang}       ${trvers:-not set}"
        # print outdated language code
        if [ "${ONLY}" == "out" ]; then
          echo "${lang}"
        fi
      else
        out "  Up-to-date   ${lang}       ${trvers:-not set}"
        # print up-to-date language code
        if [ "${ONLY}" == "up" ]; then
          echo "${lang}"
        fi
      fi
    fi
  done | sort
  exit 0
else
  i="${FILE}"
  if [[ $i != *".en."* ]]; then
    # get language code
    lang=$(echo "${i}"|sed "s/.*\.\([a-z][a-z]\)\.${EXT}/\1/")
    # get change date of translation
    trvers=$(xsltproc ${basedir}/build/xslt/get_version.xsl "${i}")
    # mark as outdated if version differs
    if [ ${trvers:-0} -lt ${envers:-0} ]; then
      out "  OUTDATED     ${lang}       ${trvers:-not set}"
      exit 1
    else
      out "  Up-to-date   ${lang}       ${trvers:-not set}"
      exit 0
    fi 
  else
    out "  (Comparing status of English file does not make sense)"
  fi
fi
