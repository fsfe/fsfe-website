#! /bin/bash
cd /srv/www/fsfe.org_git

nowlang=''
yearago=`date +%s --date='1 year ago'`

cat << _END_
<html>
 <body>
  <span style="color: red">Red entries</span> are pages where the original is newer than one year, and the translation is more than 3 months old. <span style="color: orange">Orange entries</span> are pages where the translation is older, but the original is older than one year.

_END_

find . -iname "*\.[a-z][a-z]\.xhtml"|grep -v '^./[a-z][a-z]/.*'|grep -v '^./news'|sed 's/\.[a-z][a-z]\.xhtml//'|sort|uniq|while read A; do
  if test -f "$A.en.xhtml"; then
   originaldate=`git log --pretty="%cd" --date=raw -1 $A.en.xhtml|cut -d' ' -f1`
   for i in $A.[a-z][a-z].xhtml; do
     if [[ $i != *".en."* ]]; then
       trdate=`git log --pretty="%cd" --date=raw -1 $i|cut -d' ' -f1`
       diff=$((trdate-originaldate))
       if [[ $diff -lt -3600 ]]; then
         lang=`echo $i|sed 's/.*\.\([a-z][a-z]\)\.xhtml/\1/'`
         echo "$lang $A $originaldate $trdate $((originaldate-trdate))"
       fi
     fi
  done
 fi
done|sort -t' ' -k 1,1 -k 3nr,3 -k 5nr,5|\
while read lang page originaldate trdate diff; do
  if [[ $nowlang != $lang ]]; then
    if [[ $nowlang != "" ]]; then
     echo "</table>"
    fi
    echo "<h1>Language: $lang</h1>"
    echo "<table>"
    echo "<tr><th>Page</th><th>Original date</th><th>Translation date</th><th>Age (in days)</th></tr>"
    nowlang=$lang
  fi
  orig=`date +"%Y-%m-%d" --date="@$originaldate"`
  tr=`date +"%Y-%m-%d" --date="@$trdate"`
  diffdays=$((diff/60/60/24))

  if [[ $diffdays -gt 180 && $originaldate -gt $yearago ]]; then
    red=' style="color: red;"'
  elif [[ $diffdays -gt 180 ]]; then
    red=' style="color: orange;"'
  else
    red=''
  fi
  echo "<tr><td$red>$page</td><td>$orig</td><td>$tr</td><td$red>$diffdays</td></tr>"

done

echo "</table>"
echo "</body>"
echo "</html>"
