#!/usr/bin/env bash
OUT=/srv/www/status.fsfe.org/translations.html
cd /srv/www/fsfe.org_git

nowlang=''
yearago=`date +%s --date='1 year ago'`

cat  > ${OUT} << _END_
<html>
 <body>
  <p><span style="color: red">Red entries</span> are pages where the original is newer than one year.</p>
  <p>Click on the links below to jump to a particular language</p>

_END_

find . -type f -iname "*\.en\.xhtml" | grep -v '^./[a-z][a-z]/\|^./news'|sed 's/\.[a-z][a-z]\.xhtml//'|sort|while read A; do
   for i in $A.[a-z][a-z].xhtml; do
         lang_uniq=`echo $i|sed 's/.*\.\([a-z][a-z]\)\.xhtml/\1/'`
         echo $lang_uniq
     done
 done|sort|uniq|while read lang_uniq; do
   echo "<a href=#$lang_uniq>$lang_uniq</a>" >> ${OUT}
done

find . -type f -iname "*\.en\.xhtml" | grep -v '^./[a-z][a-z]/\|^./news'|sed 's/\.[a-z][a-z]\.xhtml//'|sort|while read A; do
   originaldate=`git log --pretty="%cd" --date=raw -1 $A.en.xhtml|cut -d' ' -f1`
   original_version=$(xsltproc build/xslt/get_version.xsl $A.en.xhtml)
   for i in $A.[a-z][a-z].xhtml; do
     if [[ $i != *".en."* ]]; then
       translation_version=$(xsltproc build/xslt/get_version.xsl $i)
       if [ ${translation_version:-0} -lt ${original_version:-0} ]; then
         lang=`echo $i|sed 's/.*\.\([a-z][a-z]\)\.xhtml/\1/'`
         echo "$lang $A $originaldate $original_version $translation_version"
       fi
     fi
  done
done|sort -t' ' -k 1,1 -k 3nr,3 -k 5nr,5|\
while read lang page originaldate original_version translation_version; do
  if [[ $nowlang != $lang ]]; then
    if [[ $nowlang != "" ]]; then
     echo "</table>" >> ${OUT}
    fi
    echo "<h1 id=\"$lang\">Language: $lang</h1>" >> ${OUT}
    echo "<table>" >> ${OUT}
    echo "<tr><th>Page</th><th>Original date</th><th>Original version</th><th>Translation version</th></tr>" >> ${OUT}
    nowlang=$lang
  fi
  orig=`date +"%Y-%m-%d" --date="@$originaldate"`

  if [[ $originaldate -gt $yearago ]]; then
    color=' style="color: red;"'
  else
    color=''
  fi
  echo "<tr><td$color>$page</td><td>$orig</td><td>$original_version</td><td>$translation_version</td></tr>" >> ${OUT}

done

echo "</table>" >> ${OUT}
echo "</body>" >> ${OUT}
echo "</html>" >> ${OUT}
