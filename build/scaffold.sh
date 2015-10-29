#!/bin/sh

inc_scaffold=true
[ -z "$inc_xmlfiles" ] && . "$basedir/build/xmlfiles.sh"
[ -z "$inc_translations" ] && . "$basedir/build/translations.sh"
[ -z "$inc_filenames" ] && . "$basedir/build/filenames.sh"
[ -z "$inc_fundraising" ] && . "$basedir/build/fundraising.sh"
[ -z "$inc_sources" ] && . "$basedir/build/sources.sh"

build_xmlstream(){
  # assemble the xml stream for feeding into xsltproc
  # the expected shortname and language flag indicate 
  # a single xhtml page to be built
  shortname="$1"
  lang="$2"
  olang="$3"

  dirname="${shortname%/*}/"
  texts_xml=$(get_textsfile $lang)
  fundraising_xml=$(get_fundraisingfile $lang)
  date="$(date +%Y-%m-%d)"
  time="$(date +%H:%M:%S)"
  outdated=no

  if [ -f "${shortname}.${lang}.xhtml" ]; then
    act_lang="$lang"
    [ "${shortname}.${olang}.xhtml" -nt "${shortname}.${lang}.xhtml" ] && outdated=yes
  else
    act_lang="$olang"
  fi

  infile="${shortname}.${act_lang}.xhtml"

  cat <<-EOF
	<buildinfo
	  date="$date"
	  original="$olang"
	  filename="${shortname#$basedir}"
	  dirname="${dirname#$basedir}"
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
	    $(auto_sources "${shortname}.sources" "$lang")
	  </set>
	
	  $(include_xml "$infile")
	</document>
	
	</buildinfo>
	EOF
}

