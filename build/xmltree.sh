#!/bin/sh

basedir="$(dirname $0)/.."

include_xml(){
  # include second level elements of a given XML file
  # this emulates the behaviour of the original
  # build script which wasn't able to load top
  # level elements from any file
  file="$1"

  if [ -r "$file" ]; then
    # guess encoding from xml header
    # we will convert everything to utf-8 prior to processing
    enc="$(sed -nr 's:^.*<\?.*encoding="([^"]+)".*$:\1:p' "$file")"
    [ -z "$enc" ] && enc="UTF-8"

    iconv -f "$enc" -t "UTF-8" "$file" \
    | tr '\n\t\r' '   ' \
    | sed -r 's:<(\?[xX][mM][lL]|!DOCTYPE) [^>]+>::g
              s:<[^!][^>]*>::;
              s:</[^>]*>([^<]*((<[^>]+/>|<![^>]+>|<\?[^>]+>)[^<]*)*)?$:\1:;'
  fi
}

list_sources(){
  # read a .sources file and generate a list
  # of all referenced xml files with preference
  # for a given language
  sourcesfile="$1"
  lang="$2"

  if [ -r "$sourcesfile" ]; then
    sed -rn 's;:global$;*.[a-z][a-z].xml;gp' "$sourcesfile" \
    | while read glob; do ls "$basedir/"$glob 2>/dev/null; done \
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
  fi
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

get_language(){
  # extract language indicator from a given file name
  echo "$(echo "$1" |sed -r 's:^.*\.([a-z]{2})\.xhtml$:\1:')";
}
get_shortname(){
  # get shortened version of a given file name
  # required for internal processing
  echo "$(echo "$1" | sed -r 's:\.[a-z]{2}.xhtml$::')";
}
get_textsfile(){
  # get the texts file for a given language
  # fall back to english if necessary

  if [ -r "$basedir/tools/texts-${1}.xml" ]; then
    echo "$basedir/tools/texts-${1}.xml"
  else
    echo "$basedir/tools/texts-en.xml"
  fi
}
get_fundraisingfile(){
  # get the fundraising file for a given language
  # TODO: integrate with regular texts function

  if [ -r "$basedir/fundraising-${1}.xml" ]; then
    echo "$basedir/fundraising-${1}.xml"
  elif [ -r "$basedir/fundraising-en.xml" ]; then
    echo "$basedir/fundraising-en.xml"
  fi
}

get_processor(){
  # find the xslt script which is responsible for processing
  # a given xhtml file.
  # expects the shortname of the file as input (i.e. the
  # the file path without language and file endings)

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
  # assemble the xml stream for feeding into xsltproc
  # the expected shortname and language flag indicate 
  # a single xhtml page to be built
  shortname="$1"
  lang="$2"

  metaname="$(echo "$shortname" |sed -r 's;.*/\.\.(/.+)$;\1;')"
  infile="${shortname}.${lang}.xhtml"
  texts_xml=$(get_textsfile $lang)
  fundraising_xml=$(get_fundraisingfile $lang)

  
  date="$(date +%Y-%m-%d)"
  time="$(date +%H:%M:%S)"
  dirname="$(dirname "$infile")"
  outdated=no
  
  cat <<-EOF
	<buildinfo
	  date="$date"
	  original="en"
	  filename="$metaname"
	  dirname="$dirname"
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
	EOF
}

mes(){
  # make escape... escape a filename for ridiculous make syntax
  # probably not complete
  while [ -n "$1" ]; do
    echo "$1"
    shift 1
  done \
  | sed -r 's;([ #]);\\\1;g' \
  | tr '\n' ' '
}

xhtml_maker(){
  infile="$1"
  outpath="$2"

  shortname=$(get_shortname "$infile")
  lang=$(get_language "$infile")

  outbase="$(basename "$shortname").${lang}.html"
  outfile="${outpath}/${outbase}"
  outlink="${outpath}/$(basename "$shortname").html.$lang"

  processor="$(get_processor "$shortname")"
  textsfile="$(get_textsfile "$lang")"
  textsen="$(get_textsfile "en")"
  menufile="$basedir/tools/menu-global.xml"
  fundraisingfile="$(get_fundraisingfile "$lang")"
  sources="$(list_sources "${shortname}.sources" "$lang" |while read src; do mes "$src"; done)"

  cat <<MakeEND
all: $(mes "$outfile" "$outlink")
$(mes "$outfile"): $(mes "$infile" "$processor" "$textsen" "$textsfile" "$fundraisingfile" "$menufile" "$outpath") $sources
	$0 build_xmlstream "${shortname}.${lang}.xhtml" |xsltproc -o "${outfile}" "${processor}" -

$(mes "$outlink"): $(mes "$outfile" "$outpath")
	ln -sf "${outbase}" "${outlink}"
MakeEND

  if [ ! -f "$(dirname "$infile")/index.${lang}.xhtml" ] && \
     [ "$(basename "$shortname")" = "$(basename $(dirname "$infile"))" ]; then
    cat <<MakeEND
all: $(mes "$outpath/index.${lang}.html" "$outpath/index.html.$lang")
$(mes "$outpath/index.${lang}.html"): $(mes "$outfile" "$outpath")
	ln -sf "$outbase" "$outpath/index.${lang}.html"
$(mes "$outpath/index.html.$lang"): $(mes "$outfile" "$outpath")
	ln -sf "$outbase" "$outpath/index.html.$lang"
MakeEND
  fi
}

copy_maker(){
  infile="$1"
  outfile="$2/$(basename "$infile")"
  cat <<MakeEND
all: $(mes "$outfile")
$(mes "$outfile"): $(mes "$infile")
	cp "$infile" "$outfile"
MakeEND
}

xslt_dependencies(){
  file="$1"

  cat "$file" \
  | tr '\n' ' ' \
  | sed -r 's;(<xsl:(include|import)[^>]*>);\n\1\n;g' \
  | sed -nr '/<xsl:(include|import)[^>]*>/s;^.*href="([^"]*)".*$;\1;gp'
}

xslt_maker(){
  file="$1"
  dir="$(dirname "$file")"

  deps="$(xslt_dependencies "$file" |while read dep; do mes "$dir/$dep"; done)"
  cat <<MakeEND
$(mes "$file"): $deps
	touch "$file"
MakeEND
}

dir_maker(){
  dir="$1"
  cat <<MakeEND
all: $(mes "$dir")
$(mes "$dir"):
	mkdir -p "$dir"
MakeEND
}

tree_maker(){
  input="$(echo "$1" |sed -r 's:/$::')"
  output="$(echo "$2" |sed -r 's:/$::')"

  echo ".PHONY: all"
  #echo ".RECIPEPREFIX := ~"
  find "$input" \
  | sed -r "/(^|\/)\.svn($|\/)|^\.\.$/d;s;^$input/*;;" \
  | while read filepath; do
    inpfile="${input}/$filepath"
    if [ -d "$inpfile" ]; then
      dir_maker "$output/$filepath"
    else case "$filepath" in
      *.xsl) xslt_maker "$inpfile";;
      *.xml) true;;
      *.sources) true;;
      *.[a-z][a-z].xhtml) xhtml_maker "$inpfile" "$output/$(dirname "$filepath")";;
      *) copy_maker "$inpfile" "$output/$(dirname "$filepath")";;
    esac; fi
  done
}

build_into(){
  target="$1"

  tree_maker "$basedir" "$target" |make -f -
}

command="$1"
[ -n "$1" ] && shift 1
case "$command" in
  build_xmlstream)
    build_xmlstream "$(get_shortname "$1")" "$(get_language "$1")"
    ;;
  tree_maker)
    tree_maker "$1" "$2"
    ;;
  build_into)
    build_into "$1"
    ;;
  * ) cat <<-EOHELP

	Usage:
	------------------------------------------------------------------------------
	
	$0 build_xmlstream "file.xhtml"
	  Compile an xml stream from the specified file, additional sources will be
	  determined and included automatically. The stream is suitable for being
	  passed into xsltproc.
	
	$0 tree_maker "input_dir" "output_dir"
	  Generate a set of make rules to build the website contained in input_dir.
	  output_dir should be the www root of a web server.
	
	$0 build_into "target_dir"
	  Perform the page build. Write output to target_dir. The input directory
	  is determined from the build scripts own location.
	
	EOHELP
    ;;
esac
