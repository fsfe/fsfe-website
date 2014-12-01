#!/bin/sh


include_xml(){
  # include second level elements of a given XML file
  # this emulates the behaviour of the original
  # build script which wasn't able to load top
  # level elements from any file
  file="$1"

  if [ -r "$file" ]; then
    # guess encoding xml header
    # we will convert everything to utf-8 prior to processing
    enc="$(sed -nr 's:^.*<\?.*encoding="([^"]+)".*$:\1:p' "$file")"
    [ -z "$enc" ] && enc="UTF-8"

    iconv -f "$enc" -t "UTF-8" "$file" \
    | tr '\n\t\r' '   ' \
    | sed -r 's:<\?[xX][mM][lL][^>]+>::g
              s:<[^>]*>::;
              s:</[^>]*>[^<]*(<[^>]+/>|<[?!][^>]+>)*[^<]*$:\1:;'
  fi
}

list_sources(){
  # read a .sources file and generate a list
  # of all referenced xml files with preference
  # for a given language
  sourcesfile="$1"
  lang="$2"

  [ -r "$sourcesfile" ] \
  && sed -rn 's;:global$;*.[a-z][a-z].xml;gp' "$sourcesfile" \
  | while read glob; do ls $glob; done \
  | sed -r 's:\.[a-z]{2}\.xml$::' \
  | sort -u \
  | while read base; do
    if [ -r "${base}.${lang}.xml" ]; then
      echo "${base}.${lang}.xml"
    elif [ -r "${base}.en.xml" ]; then
      echo "${base}.en.xml"
    else
      ls ${base}.[a-z][a-z].xml |head -n1
    fi
  done 
}

auto_sources(){
  # import elements from source files, add file name
  # attribute to first element included from each file
  sourcesfile="$1"
  lang="$2"

  list_sources "$sourcesfile" "$lang" \
  | while read source; do
    echo -n "$source\t"
    include_xml "$source" 
    echo
  done \
  | sed -r 's:^([^\t]+)\t[^<]*(< *[^ >]+)([^>]*>):\2 filename="\1" \3:'
}

list_langs(){
  # list all languages a file exists in by globbing up
  # the shortname (i.e. file path with file ending omitted)
  # output is readily formated for inclusion
  # in xml stream
  shortname="$1"

  ls "$shortname".[a-z][a-z].xhtml \
  | sed -r 's:^.+\.([a-z]{2})\.xhtml$:\1:g' \
  | while read lang; do case "$lang" in
    'ar') echo "$lang" '&#1575;&#1604;&#1593;&#1585;&#1576;&#1610;&#1617;&#1577;';;
    'bg') echo "$lang" 'Български';;
    'bs') echo "$lang" 'Bosanski';;
    'ca') echo "$lang" 'Català';;
    'cs') echo "$lang" 'Česky';;
    'da') echo "$lang" 'Dansk';;
    'de') echo "$lang" 'Deutsch';;
    'el') echo "$lang" 'Ελληνικά';;
    'en') echo "$lang" 'English';;
    'es') echo "$lang" 'Español';;
    'et') echo "$lang" 'Eesti';;
    'fi') echo "$lang" 'Suomi';;
    'fr') echo "$lang" 'Français';;
    'hr') echo "$lang" 'Hrvatski';;
    'hu') echo "$lang" 'Magyar';;
    'it') echo "$lang" 'Italiano';;
    'ku') echo "$lang" 'Kurdî';;
    'mk') echo "$lang" 'Mакедонски';;
    'nb') echo "$lang" 'Norsk (bokmål)';;
    'nl') echo "$lang" 'Nederlands';;
    'nn') echo "$lang" 'Norsk (nynorsk)';;
    'pl') echo "$lang" 'Polski';;
    'pt') echo "$lang" 'Português';;
    'ro') echo "$lang" 'Română';;
    'ru') echo "$lang" 'Русский';;
    'sk') echo "$lang" 'Slovenčina';;
    'sl') echo "$lang" 'Slovenščina';;
    'sq') echo "$lang" 'Shqip';;
    'sr') echo "$lang" 'Српски';;
    'sv') echo "$lang" 'Svenska';;
    'tr') echo "$lang" 'Türkçe';;
    'uk') echo "$lang" 'Українська';;
  esac; done \
  | sed -r 's:^([a-z]{2}) (.+)$:<tr id="\1">\2</tr>:g'
}

get_language(){ echo "$(echo "$1" |sed -r 's:^.*\.([a-z]{2})\.xhtml$:\1:')"; }
get_shortname(){ echo "$(echo "$1" | sed -r 's:\.[a-z]{2}.xhtml$::')"; }
get_textsfile(){
  if [ -r "tools/texts-${1}.xml" ]; then
    echo "tools/texts-${1}.xml"
  else
    echo "tools/texts-en.xml"
  fi
}
get_fundraisingfile(){
  if [ -r "fundraising-${1}.xml" ]; then
    echo "fundraising-${1}.xml"
  elif [ -r "fundraising-en.xml" ]; then
    echo "fundraising-en.xml"
  fi
}

get_processor(){
  filename="$(basename "$1").xsl"
  location="$(dirname "$1")"

  until [ -r "$location/$filename" -o -r "$location/default.xsl" -o "$location" = / ]; do
    location="$(dirname "$location")"
  done
  if [ -r "$location/$filename" ]; then
    echo "$location/$filename"
  elif [ -r "$location/default.xsl" ]; then
    echo "$location/default.xsl"
  fi
}

build_xmlstream(){
  shortname="$1"
  lang="$2"
  infile="${shortname}.${lang}.xhtml"
  texts_xml=$(get_textsfile $lang)
  fundraising_xml=$(get_fundraisingfile $lang)
  
  date="$(date +%Y-%m-%d)"
  time="$(date +%H:%M:%S)"
  dirname="$(dirname "$infile")"
  outdated=no
  
  cat <<__EOF
  <buildinfo
    date="$date"
    original="en"
    filename="$shortname"
    dirname="$dirname"
    language="$lang"
    outdated="$outdated"
  >
  
  <trlist>
    $(list_langs "$shortname")
  </trlist>
  
  <menuset>$(include_xml tools/menu-global.xml)</menuset>
  <textsetbackup>$(include_xml tools/texts-en.xml)</textsetbackup>
  <textset>$(include_xml "$texts_xml")</textset>
  <fundraising>$(include_xml "$fundraising_xml")</fundraising>
  
  <document
    language="$lang"
    type=""
    external=""
    newsdate=""
  >
    <timestamp>
      \$Date:$date $time \$
      \$Author: automatic \$
    </timestamp>
    <set>
      $(auto_sources "${shortname}.sources" "$lang")
    </set>
  
    $(include_xml "$infile")
  </document>
  
  </buildinfo>
__EOF
}

process_file(){
  infile="$1"
  shortname=$(get_shortname "$infile")
  lang=$(get_language "$infile")

  processor="$(get_processor "$shortname")"

  build_xmlstream "$shortname" "$lang" |xsltproc "$processor" -
}
