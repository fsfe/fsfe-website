#!/usr/bin/env bash

print_usage () { echo "make-outdated-list.sh -o outfile -r repo_path"; }

while getopts o:r:h OPT; do
  case $OPT in
    o)  OUT=$OPTARG;;
    r)  REPO=$OPTARG;;
    h)  print_usage; exit 0;;
    *)  echo "Unknown option: -$OPTARG"; print_usage; exit 1;;
  esac
done

if [[ -z $OUT || -z $REPO ]]; then
  echo "Mandatory option missing:"
  print_usage
  exit 1
fi

cd "$REPO"

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

find . -type f \( -iname "*\.en\.xhtml" -o -iname "*\.en\.xml" \) -not -path "*/\.*" | grep -v '^./[a-z][a-z]/\|^./news\|^./events' |sort|while read fullname; do
   ext="${fullname##*.}"
   base="$(echo $fullname | sed "s/\.[a-z][a-z]\.$ext//")"
   original_version=$(xsltproc build/xslt/get_version.xsl $base.en.$ext)
   for i in $base.[a-z][a-z].$ext; do
     if [[ $i != *".en."* ]]; then
       translation_version=$(xsltproc build/xslt/get_version.xsl $i)
       if [ ${translation_version:-0} -lt ${original_version:-0} ]; then
         originaldate=`git log --pretty="%cd" --date=raw -1 $base.en.$ext|cut -d' ' -f1`
         lang=$(echo $i|sed "s/.*\.\([a-z][a-z]\)\.$ext/\1/")
         echo "$lang $base $originaldate $original_version $translation_version"
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
