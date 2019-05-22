#!/bin/bash

print_usage() {
  echo "Check the translation status of a file"
  echo ""
  echo "Usage: ./check-translation-status.sh [-a] [-q] -f file.en.xml"
  echo ""
  echo " -f FILENAME"
  echo " (Relative or absolute path to file that shall be checked)"
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
}

ALL="0"
QUIET="0"
while getopts f:aq OPT; do
  case $OPT in
        f)  FILE=$OPTARG;;
        a)  ALL="1";;
        q)  QUIET="1";;
        h)  print_help;;
  esac
done

# show usage if no parameter given
if [ "$1" = "" ]; then
  print_usage
  exit 0
fi

function out {
  if [ "$QUIET" != "1" ]; then
    echo "$@"
  fi
}

# Get file extension
EXT="${FILE##*.}"
if ! [[ "$EXT" =~ ^(xhtml|xml)$ ]]; then
  out "Only works for files ending with .xhtml or .xml"
  exit 2
fi

# remove "en.$EXT"
A=$(echo "$FILE" | sed -E "s/\.[a-z][a-z]\.$EXT//")
# get change date of English file
EN=$A.en.$EXT
if [ ! -e "$EN" ]; then
  out "English file does not exist. Aborting. ($EN)"
  exit 2
fi
endate=$(git log --pretty="%cd" --date=raw -1 "$EN"|cut -d' ' -f1)
# Convert to YYYY-MM-DD
ymd=$(date +"%Y-%m-%d" --date="@$endate")
out "Basefile: $EN ( $ymd )"
out "  STATUS      LANG    DATE"
out "  --------    ----   ----------"

if [ "$ALL" == "1" ]; then
  # Loop over all translations of this file
  for i in "$A".[a-z][a-z].$EXT; do
    if [[ $i != *".en."* ]]; then
      # get language code
      lang=$(echo "$i"|sed "s/.*\.\([a-z][a-z]\)\.$EXT/\1/")
      # get change date of translation
      trdate=$(git log --pretty="%cd" --date=raw -1 "$i"|cut -d' ' -f1)
      # Convert to YYYY-MM-DD
      ymd=$(date +"%Y-%m-%d" --date="@$trdate")
      # get time difference in seconds
      diff=$((trdate-endate))
      # mark as outdated if difference larger than 1 hour
      if [[ $diff -lt -3600 ]]; then
        out "  OUTDATED     $lang    $ymd"
      else
        out "  Up-to-date   $lang    $ymd"
      fi 
    fi
  done | sort
  exit 0
else
  i="$FILE"
  if [[ $i != *".en."* ]]; then
    # get language code
    lang=$(echo "$i"|sed "s/.*\.\([a-z][a-z]\)\.$EXT/\1/")
    # get change date of translation
    trdate=$(git log --pretty="%cd" --date=raw -1 "$i"|cut -d' ' -f1)
    # Convert to YYYY-MM-DD
    ymd=$(date +"%Y-%m-%d" --date="@$trdate")
    # get time difference in seconds
    diff=$((trdate-endate))
    # mark as outdated if difference larger than 1 hour
    if [[ $diff -lt -3600 ]]; then
      out "  OUTDATED     $lang    $ymd"
      exit 1
    else
      out "  Up-to-date   $lang    $ymd"
      exit 0
    fi 
  fi
fi
