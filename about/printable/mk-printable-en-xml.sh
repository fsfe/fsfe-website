#!/bin/bash
# -----------------------------------------------------------------------------
# Script to rebuild printable.en.xml
# -----------------------------------------------------------------------------

lang_bg="Български"
lang_ca="Català"
lang_cs="Česky"
lang_da="Dansk"
lang_de="Deutsch"
lang_el="Ελληνικά"
lang_en="English"
lang_es="Español"       
lang_fi="Suomi"
lang_fr="Français"
lang_hu="Magyar"
lang_it="Italiano"
lang_ku="Kurdî"
lang_mk="Mакедонски"
lang_nl="Nederlands"
lang_no="Norsk"
lang_pl="Polski"
lang_pt="Português"
lang_ro="Română"
lang_ru="Русский"
lang_sl="Slovenščina"
lang_sq="Shqip"
lang_sr="Srpski"
lang_sv="Svenska"
lang_tr="Türkçe"

rm --force printable.en.xml

echo "<printableset>" >> printable.en.xml
lastfile=""
for i in $*; do
  dir=$(dirname $i)
  base=$(basename $i)
  file=$(echo -n $base | cut --delimiter="." --fields="1")
  lang=$(echo -n $base | cut --delimiter="." --fields="2")
  thetype=$(echo -n ${file} | cut --delimiter="-" --fields="1")
  langvar="lang_${lang}"
  moreinfo=$(xsltproc get_moreinfo.xsl $i)
  if [ "${file}" != "${lastfile}" ]; then
    if [ -n "${lastfile}" ]; then
      echo "  </printable>" >> printable.en.xml
    fi
    echo -n "  <printable" >> printable.en.xml
    echo -n " type=\"${thetype}\"" >> printable.en.xml
    echo -n " id=\"${dir}/${file}\"" >> printable.en.xml
    if [ -n "${moreinfo}" ]; then
      echo -n " moreinfo=\"${moreinfo}\"" >> printable.en.xml
    fi
    echo ">" >> printable.en.xml
  fi
  echo -n "    <translation" >> printable.en.xml
  echo -n " lang=\"${lang}\"" >> printable.en.xml
  echo -n " langname=\"${!langvar}\">" >> printable.en.xml
  xsltproc get_h1.xsl $i >> printable.en.xml
  echo "</translation>" >> printable.en.xml
  lastfile=${file}
done
echo "  </printable>" >> printable.en.xml
echo "</printableset>" >> printable.en.xml
