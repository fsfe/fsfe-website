#!/usr/bin/env bash

inc_scaffold=true

get_version(){
  version=$(xsltproc $basedir/build/xslt/get_version.xsl $1)
  echo ${version:-0}
}

include_xml(){
  # include second level elements of a given XML file
  # this emulates the behaviour of the original
  # build script which wasn't able to load top
  # level elements from any file
  if [ -f "$1" ]; then
    # Remove <version> because the filename attribute would otherwise be added
    # to this element instead of the actual content element.
    sed 's;<version>.*</version>;;' "$1" | \
    sed -r ':X; $bY; N; bX; :Y;
            s:<(\?[xX][mM][lL]|!DOCTYPE)[[:space:]]+[^>]+>::g
            s:<[^!][^>]*>::;
            s:</[^>]*>([^<]*((<[^>]+/>|<!([^>]|<[^>]*>)*>|<\?[^>]+>)[^<]*)*)?$:\1:;'
  fi
}

get_attributes(){
  # get attributes of top level element in a given
  # XHTML file
  sed -rn ':X; N; $!bX;
           s;^.*<[\n\t\r ]*([xX]|[xX]?[hH][tT])[mM][lL][\n\t\r ]+([^>]*)>.*$;\2;p' "$1"
}

list_langs(){
  # list all languages a file exists in by globbing up
  # the shortname (i.e. file path with file ending omitted)
  # output is readily formatted for inclusion
  # in xml stream
  for file in "${1}".[a-z][a-z].xhtml; do
    language="${file: -8:2}"
    text="$(echo -n $(cat "${basedir}/global/languages/${language}"))"
    echo "<tr id=\"${language}\">${text}</tr>"
  done
}

auto_sources(){
  # import elements from source files, add file name
  # attribute to first element included from each file
  shortname="$1"
  lang="$2"

  list_file="$(dirname ${shortname})/.$(basename ${shortname}).xmllist"

  cat "${list_file}" | while read base; do
    if [ -f "${basedir}/${base}.${lang}.xml" ]; then
      printf '\n### filename="%s" ###\n%s' "$(basename ${base})" "$(include_xml "${basedir}/${base}.${lang}.xml")"
    elif [ -f "${basedir}/${base}.en.xml" ]; then
      printf '\n### filename="%s" ###\n%s' "$(basename ${base})" "$(include_xml "${basedir}/${base}.en.xml")"
    fi
  done \
  | sed -r ':X; N; $!bX;
            s;\n### (filename="[^\n"]+") ###\n[^<]*(<![^>]+>[^<]*)*(<([^/>]+/)*([^/>]+))(/?>);\2\3 \1\6;g;'
}

build_xmlstream(){
  # assemble the xml stream for feeding into xsltproc
  # the expected shortname and language flag indicate 
  # a single xhtml page to be built
  shortname="$1"
  lang="$2"

  olang="$(echo "${shortname}".[a-z][a-z].xhtml "${shortname}".[e]n.xhtml |sed -rn 's;^.*\.([a-z]{2})\.xhtml.*$;\1;p')"
  dirname="${shortname%/*}/"
  texts_xml="$basedir/tools/.texts-${lang}.xml"
  fundraising_xml="$basedir/.fundraising.${lang}.xml"
  date="$(date +%Y-%m-%d)"
  time="$(date +%H:%M:%S)"
  outdated=no

  if [ -f "${shortname}.${lang}.xhtml" ]; then
    act_lang="$lang"
    [ $(get_version "${shortname}.${olang}.xhtml") -gt $(get_version "${shortname}.${lang}.xhtml") ] && outdated=yes
  else
    act_lang="$olang"
  fi

  infile="${shortname}.${act_lang}.xhtml"

  cat <<-EOF
	<buildinfo
	  date="$date"
	  original="$olang"
	  filename="/${shortname#$basedir/}"
	  dirname="/${dirname#$basedir/}"
	  language="$lang"
	  outdated="$outdated"
	>
	
	<trlist>
	  $(list_langs "$shortname")
	</trlist>
	
	<menuset>$(include_xml "$basedir/tools/menu-global.xml")</menuset>
	<textsetbackup>$(include_xml "$basedir/tools/texts-en.xml")</textsetbackup>
	<textset>$(include_xml "$texts_xml")</textset>
	<fundraising>$(include_xml "$fundraising_xml")</fundraising>
	
	<document
	  language="$act_lang"
	  $(get_attributes "$infile")
	>
	  <timestamp>
	    \$Date: $date $time \$
	    \$Author: automatic \$
	  </timestamp>
	  <set>
	    $(auto_sources "${shortname}" "$lang")
	  </set>
	
	  $(include_xml "$infile")
	</document>
	
	</buildinfo>
	EOF
}
