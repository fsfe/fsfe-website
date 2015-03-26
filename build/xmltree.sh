#!/bin/sh


print_help(){
  cat <<-EOHELP

	Usage:
	------------------------------------------------------------------------------
	
	$0 [options] build_xmlstream "file.xhtml"
	  Compile an xml stream from the specified file, additional sources will be
	  determined and included automatically. The stream is suitable for being
	  passed into xsltproc.
	
	$0 [options] tree_maker [input_dir] "destination_dir"
	  Generate a set of make rules to build the website contained in input_dir.
	  destination_dir should be the www root of a web server.
	  If input_dir is omitted, it will be the source directory determined from
	  the build scripts location.
	
	$0 [options] build_into "destination_dir"
	  Perform the page build. Write output to destination_dir. The source directory
	  is determined from the build scripts own location.

	OPTIONS
	-------

	--source "source_dir"
	  Force a specific source directory. If not explicitly given source_dir is
	  determined from the build scripts own location. 
	  Pathes given in .sources files are interpreted as relative to source_dir
	  making this option useful when building a webpage outside of the build
	  scripts "regular" tree.

	--destination "destination_dir"
	  The directory into which the website will be built. This option can be used
	  in conjunction with the tree_maker and build_into commands. It will override
	  the destination_dir option given after those commands and is therefore
	  redundant. The option exists to provide backward compatibility to the 2002
	  build script.

	--statusdir "status_dir"
	  A directory to which messages are written. If no status_dir is provided
	  information will be written to stdout. The directory will also be used
	  to store some temporary files, which would otherwise be set up in the
	  system wide temp directory.
	
	EOHELP
}

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
              s:</[^>]*>([^<]*((<[^>]+/>|<!([^>]|<[^>]*>)*>|<\?[^>]+>)[^<]*)*)?$:\1:;'
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
    | while read glob; do echo "$basedir/"$glob 2>/dev/null; done \
    | sed -r 's:\.[a-z]{2}\.xml( |$):\n:g' \
    | sort -u \
    | while read base; do
      if [ -r "${base}.${lang}.xml" ]; then
        echo "${base}.${lang}.xml"
      elif [ -r "${base}.en.xml" ]; then
        echo "${base}.en.xml"
      else
        ls "${base}".[a-z][a-z].xml |head -n1
      fi
    done 2>/dev/null
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

  shortname="$1"

  if [ -r "${shortname}.xsl" ]; then
    echo "${shortname}.xsl"
  else
    location="$(dirname "$shortname")"
    until [ -r "$location/default.xsl" -o "$location" = . -o "$location" = / ]; do
      location="$(dirname "$location")"
    done
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
  # make escape... escape a filename for make syntax
  # possibly not complete
  while [ -n "$*" ]; do
    echo "$1"
    shift 1
  done \
  | sed -r 's;([ #]);\\\1;g' \
  | tr '\n' ' '
}

xhtml_maker(){
  # generate make rules for building html files out of xhtml
  # account for included xml files and xls rules

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
  sources="$(list_sources "${shortname}.sources" "$lang")"

  cat <<MakeEND
all: $(mes "$outfile" "$outlink")
$(mes "$outfile"): $(mes "$infile" "$processor" "$textsen" "$textsfile" "$fundraisingfile" "$menufile" $sources)
	$0 --source "$basedir" build_xmlstream "${shortname}.${lang}.xhtml" |xsltproc "${processor}" - >"${outfile}"

$(mes "$outlink"):
	ln -sf "${outbase}" "${outlink}"
MakeEND

  if [ ! -f "$(dirname "$infile")/index.${lang}.xhtml" ] && \
     [ "$(basename "$shortname")" = "$(basename $(dirname "$infile"))" ]; then
    cat <<MakeEND
all: $(mes "$outpath/index.${lang}.html" "$outpath/index.html.$lang")
$(mes "$outpath/index.${lang}.html"):
	ln -sf "$outbase" "$outpath/index.${lang}.html"
$(mes "$outpath/index.html.$lang"):
	ln -sf "$outbase" "$outpath/index.html.$lang"
MakeEND
  fi
}

copy_maker(){
  # generate make rule for copying a plain file

  infile="$1"
  outpath="$2"
  outfile="$outpath/$(basename "$infile")"
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
  # find external references in a xsl file and generate
  # Make dependencies accordingly

  file="$1"
  dir="$(dirname "$file")"

  deps="$(xslt_dependencies "$file" |while read dep; do mes "$dir/$dep"; done)"
  cat <<MakeEND
$(mes "$file"): $deps
	touch "$file"
MakeEND
}

dir_maker(){
  # set up directory tree for output
  # optimise by only issuing mkdir commands
  # for leaf directories

  input="$(echo "$1" |sed -r 's:/$::')"
  output="$(echo "$2" |sed -r 's:/$::')"

  curpath="$output"
  find "$input" -depth -type d \
  | sed -r "/(^|\/)\.svn($|\/)|^\.\.$/d;s;^$input/*;;" \
  | while read filepath; do
    oldpath="$curpath"
    curpath="$output/$filepath/"
    echo "$oldpath" |grep -q "^$curpath" || mkdir -p "$curpath"
  done
}

tree_maker(){
  # walk through file tree and issue Make rules according to file type

  input="$(echo "$1" |sed -r 's:/$::')"
  output="$(echo "$2" |sed -r 's:/$::')"

  echo ".PHONY: all"
  find "$input" -type f \
  | sed -r "/(^|\/)\.svn($|\/)|^\.\.$/d;s;^$input/*;;" \
  | while read filepath; do
    inpfile="${input}/$filepath"
    case "$filepath" in
      *.xsl) xslt_maker "$inpfile";;
      Makefile) true;;
      *.xml) true;;
      *.sources) true;;
      *.[a-z][a-z].xhtml) xhtml_maker "$inpfile" "$output/$(dirname "$filepath")";;
      *) copy_maker "$inpfile" "$output/$(dirname "$filepath")";;
    esac
  done
}

logstatus(){
  # pipeline atom to write data streams into a log file
  # log file will be created inside statusdir
  # if statusdir is not enabled, we won't log to a file
  file="$1"

  if [ -w "$statusdir" ]; then
    tee "$statusdir/$file"
  else
    cat
  fi
}

print_error(){
  echo "Error: $*" |logstatus lasterror >/dev/stderr
  echo "Run '$0 --help' to see usage instructions" >/dev/stderr
}

build_manifest(){
  # pass Makefile throug on pipe and generate
  # list of all make tagets

  outfile="$1"
  while line="$(line)"; do
    echo "$line"
    echo "$line" \
    | sed -nr 's;/\./;/;g;s;\\ ; ;g;s;([^:]+) :.*;\1;p' \
    >> "$outfile"
  done
}

remove_orphans(){
  # read list of files which should be in a directory tree
  # and remove everything else

  tree="$1"

  # idea behind the algorithm:
  # find will list every existing file once
  # the manifest of all make targets will list all wanted files once
  # concatenate all lines from manifest and find
  # every file which is listed twice is wanted and exists,
  # we use 'uniq -u' to drop those from the list
  # remaining single files exist only in the tree and are to be removed

  (find "$tree" -type f -or -type l; cat) \
  | sort \
  | uniq -u \
  | while read file; do
    echo "$file" \
    | egrep -q "^$tree" \
    && rm -v "$file"
  done
}

build_into(){
  ncpu="$(cat /proc/cpuinfo |grep ^processor |wc -l)"

  [ -w "$statusdir" -a -d "$statusdir" ] && \
     manifest="$(tempfile -d "$statusdir" -p mnfst)" \
  || manifest="$(tempfile -p w3bld)"

  dir_maker "$basedir" "$target"
  tree_maker "$basedir" "$target" \
  | logstatus Makefile \
  | build_manifest "$manifest" \
  | make -j $ncpu -f - \
  | logstatus buildlog

  remove_orphans "$target" <"$manifest" \
  | logstatus removed

  [ -w "$statusdir" -a -d "$statusdir" ] && \
     mv "$manifest" "$statusdir/manifest" \
  || rm "$manifest"
}

basedir="$(dirname $0)/.."
while [ -n "$*" ]; do
  case "$1" in
    -s|--statusdir|--status-dir)
      shift 1
      statusdir="$1"
      ;;
    --source)
      shift 1
      basedir="$1"
      ;;
    -d|--dest|--destination)
      shift 1
      target="$1"
      ;;
    -h|--help)
      command="help"
      ;;
    build_into)
      command="build_into$command"
      ;;
    build_xmlstream)
      command="build_xmlstream$command"
      ;;
    tree_maker)
      command="tree_maker$command"
      ;;
    *)
      if [ "$command" = "build_into" -a -z "$target" ]; then
        target="$1"
      elif [ "$command" = "build_xmlstream" -a -z "$workfile" ]; then
        workfile="$1"
      elif [ "$command" = "tree_maker" -a -z "$tree" ]; then
        tree="$1"
      elif [ "$command" = "tree_maker" -a -z "$target" ]; then
        target="$1"
      else
        print_error "Unknown option $1"
        exit 1
      fi
      ;;
  esac
  shift 1
done

if [ -n "$statusdir" ]; then
  mkdir -p "$statusdir"
  if [ ! -w "$statusdir" -o ! -d "$statusdir" ]; then
    print_error "Unable to set up status directory in \"$statusdir\",
either select a status directory that exists and is writable,
or run the build script without output to a status directory"
    exit 1
  fi
fi

case "$command" in
  build_into)
    [ -z "$target" ] && print_error "Missing destination directory" && exit 1
    build_into
    ;;
  build_xmlstream)
    [ -z "$workfile" ] && print_error "Missing destination directory" && exit 1
    build_xmlstream "$(get_shortname "$workfile")" "$(get_language "$workfile")"
    ;;
  tree_maker)
    [ -z "$tree" ] && tree="$basedir"
    [ -z "$target" ] && print_error "Missing target location" && exit 1
    tree_maker "$tree" "$target"
    ;;
  *help*)
    print_help
    ;;
  *)
    print_error "Urecognised command or no command given"
    ;;
esac
