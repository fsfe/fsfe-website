#!/usr/bin/env bash

A=$(echo $1 | sed 's/\.[a-z][a-z]\.xhtml//')
originaldate=`git log --pretty="%cd" --date=raw -1 $A.en.xhtml|cut -d' ' -f1`

EN=$A.en.xhtml
trdate=`git log --pretty="%cd" --date=raw -1 $EN|cut -d' ' -f1`
ymd=`date +"%Y-%m-%d" --date="@$trdate"`
echo "Basefile: $EN ( $ymd )"
echo "  STATUS      LANG    DATE"
echo "  --------    ----   ----------"

for i in $A.[a-z][a-z].xhtml; do
  if [[ $i != *".en."* ]]; then
    trdate=`git log --pretty="%cd" --date=raw -1 $i|cut -d' ' -f1`
    ymd=`date +"%Y-%m-%d" --date="@$trdate"`
    diff=$((trdate-originaldate))
    lang=`echo $i|sed 's/.*\.\([a-z][a-z]\)\.xhtml/\1/'`
    if [[ $diff -lt -3600 ]]; then
      echo "  OUTDATED     $lang    $ymd"
    else
      echo "  Up-to-date   $lang    $ymd"
    fi 
  fi
done | sort
