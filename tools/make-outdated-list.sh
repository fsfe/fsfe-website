#!/usr/bin/env bash
OUT=/srv/www/status.fsfe.org/translations.html
cd /srv/www/fsfe.org_git

nowlang=''
yearago=`date +%s --date='1 year ago'`

cat  > ${OUT} << _END_
<html>
 <body>
  <p><span style="color: red">Red entries</span> are pages where the original is newer than one year, and the translation is more than 3 months old. <span style="color: orange">Orange entries</span> are pages where the translation is older, but the original is older than one year.</p>
  <p>Click on the links below to jump to a particular language</p>

_END_

find . -type f -iname "*\.en\.xhtml" | grep -v '^./[a-z][a-z]/\|^./news'|sed 's/\.[a-z][a-z]\.xhtml//'|sort|while read A; do
   originaldate=`git log --pretty="%cd" --date=raw -1 $A.en.xhtml|cut -d' ' -f1`
   for i in $A.[a-z][a-z].xhtml; do
         lang_uniq=`echo $i|sed 's/.*\.\([a-z][a-z]\)\.xhtml/\1/'`
         echo $lang_uniq
     done
 done|sort|uniq|while read lang_uniq; do
   echo "<a href=#$lang_uniq>$lang_uniq</a>" >> ${OUT}
done

find . -type f -iname "*\.en\.xhtml" | grep -v '^./[a-z][a-z]/\|^./news'|sed 's/\.[a-z][a-z]\.xhtml//'|sort|while read A; do
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
done|sort -t' ' -k 1,1 -k 3nr,3 -k 5nr,5|\
while read lang page originaldate trdate diff; do
  if [[ $nowlang != $lang ]]; then
    if [[ $nowlang != "" ]]; then
     echo "</table>" >> ${OUT}
    fi
    echo "<h1 id=\"$lang\">Language: $lang</h1>" >> ${OUT}
    echo "<table>" >> ${OUT}
    echo "<tr><th>Page</th><th>Original date</th><th>Translation date</th><th>Age (in days)</th></tr>" >> ${OUT}
    nowlang=$lang
  fi
  orig=`date +"%Y-%m-%d" --date="@$originaldate"`
  tr=`date +"%Y-%m-%d" --date="@$trdate"`
  diffdays=$((diff/60/60/24))

  if [[ $diffdays -gt 180 && $originaldate -gt $yearago ]]; then
    color=' style="color: red;"'
  elif [[ $diffdays -gt 180 ]]; then
    color=' style="color: orange;"'
  else
    color=''
  fi
  echo "<tr><td$color>$page</td><td>$orig</td><td>$tr</td><td$color>$diffdays</td></tr>" >> ${OUT}

done

echo "</table>" >> ${OUT}
echo "</body>" >> ${OUT}
echo "</html>" >> ${OUT}
