#!/bin/sh

inc_makerules=true
[ -z "$inc_misc" ] && . "$basedir/build/misc.sh"
[ -z "$inc_translations" ] && . "$basedir/build/translations.sh"
[ -z "$inc_filenames" ] && . "$basedir/build/filenames.sh"
[ -z "$inc_fundraising" ] && . "$basedir/build/fundraising.sh"
[ -z "$inc_languages" ] && . "$basedir/build/languages.sh"
[ -z "$inc_sources" ] && . "$basedir/build/sources.sh"

sourcefind() {
  find "$input" -name .svn -prune -o -type f "$@" -printf '%P\n'
}

mio(){
  # make input/output abstraction, produce reusable makefiles
  # by replacing in and out pathes with make variables.
  for each in "$@"; do
    case "$each" in
      "$input"/*)  echo "\${INPUTDIR}/${each#$input/}" ;;
      "$output"/*) echo "\${OUTPUTDIR}/${each#$output/}" ;;
      *) echo "$each" ;;
    esac
  done
}

mes(){
  # make escape... escape a filename for make syntax
  # possibly not complete
  mio "$@" \
  | sed -r 's;([ #]);\\\1;g' \
  | tr '\n' ' '
}

glob_maker(){
  # issue make rules for preglobbed sources files
  sourcesfile="$1"

  filedir="\${INPUTDIR}/$(dirname "$sourcesfile")"
  shortbase="$(basename "$sourcesfile" |sed -r 's;\.sources$;;')"

  for lang in $(get_languages); do
    globfile="${filedir%/.}/._._${shortbase}.${lang}.sourceglobs"
    refglobs="${filedir%/.}/._._${shortbase}.${lang}.refglobs"
    cat <<MakeEND
$(mes "$globfile"): $(mes "\${INPUTDIR}/tagmap" "\${INPUTDIR}/$sourcesfile")
	\${PGLOBBER} \${PROCFLAGS} lang_sources "\${INPUTDIR}/$sourcesfile" "$lang" >"$globfile"
$(mes "$refglobs"): $(mes "$globfile")
	\${PGLOBBER} \${PROCFLAGS} cast_refglobs "$globfile" "$refglobs"
MakeEND
  done
}

glob_makers(){
  # generate make rules for globbing all .sources files
  # within input tree
  sourcefind -name '*.sources' \
  | while read filepath; do
    glob_maker "$filepath"
  done 
}

glob_additions(){
  printf "%s\n" "$@" \
  | egrep '.+\.sources$' \
  | xargs realpath \
  | while read addition; do
    glob_maker "${addition#$input/}"
  done
}

xhtml_maker(){
  # generate make rules for building html files out of xhtml
  # account for included xml files and xsl rules

  shortname="$input/$1"
  outpath="\${OUTPUTDIR}/${2}"
  outpath="${outpath%/.}"

  textsen="$(get_textsfile "en")"
  menufile="$basedir/tools/menu-global.xml"
  filedir="$(dirname "$shortname")"
  shortbase="$(basename "$shortname")"
  processor="$(get_processor "$shortname")"

  langglob="$filedir/._._${shortbase}.langglob"
  cast_langglob "$shortname" "$langglob"

  [ -f "$shortname".rss.xsl ] && bool_rss=true || bool_rss=false
  [ -f "$shortname".ics.xsl ] && bool_ics=true || bool_ics=false

  olang="$(echo "${shortname}".[a-z][a-z].xhtml "${shortname}".[e]n.xhtml |sed -rn 's;^.*\.([a-z]{2})\.xhtml.*$;\1;p')"

  if [ "${shortbase}" = "$(basename "$filedir")" ] && \
     [ ! -f "${filedir}/index.${olang}.xhtml" ]; then
    bool_indexname=true
  else
    bool_indexname=false
  fi

  [ -f "${shortname}.sources" ] && bool_sourceinc=true || bool_sourceinc=false

  # For speed considerations: avoid all disk I/O in this loop
  for lang in $(get_languages); do
    infile="${shortname}.${lang}.xhtml"
    [ -e "$infile" ] && depfile="$infile" || depfile="${shortname}.${olang}.xhtml" 

    infile="$(mio "$infile")"
    outbase="${shortbase}.${lang}.html"
    outfile="${outpath}/${outbase}"
    outlink="${outpath}/${shortbase}.html.$lang"
    rssfile="${outpath}/${shortbase}.${lang}.rss"
    icsfile="${outpath}/${shortbase}.${lang}.ics"

    textsfile="$(get_textsfile "$lang")"
    fundraisingfile="$(get_fundraisingfile "$lang")"
    $bool_sourceinc && sourceglobs="${filedir#./}/._._${shortbase}.${lang}.refglobs" || unset sourceglobs

    cat <<MakeEND
all: $(mes "$outfile" "$outlink")
$(mes "$outfile"): $(mes "$depfile" "$processor" "$textsen" "$textsfile" "$fundraisingfile" "$menufile" "$sourceglobs" "$langglob")
	\${PROCESSOR} \${PROCFLAGS} process_file "${infile}" "$(mio "$processor")" "$olang" >"$outfile"
$(mes "$outlink"):
	ln -sf "${outbase}" "${outlink}"
MakeEND
    $bool_rss && cat<<MakeEND
all: $(mes "$rssfile")
$(mes "$rssfile"): $(mes "$depfile" "${shortname}.rss.xsl" "$textsen" "$textsfile" "$fundraisingfile" "$menufile" "$sourceglobs")
	\${PROCESSOR} \${PROCFLAGS} process_file "${infile}" "$(mio "${shortname}.rss.xsl")" "$olang" >"$rssfile"
MakeEND
    $bool_ics && cat<<MakeEND
all: $(mes "$icsfile")
$(mes "$icsfile"): $(mes "$depfile" "${shortname}.ics.xsl" "$textsen" "$textsfile" "$fundraisingfile" "$menufile" "$sourceglobs")
	\${PROCESSOR} \${PROCFLAGS} process_file "${infile}" "$(mio "${shortname}.ics.xsl")" "$olang" >"$icsfile"
MakeEND
    $bool_indexname && cat <<MakeEND
all: $(mes "$outpath/index.${lang}.html" "$outpath/index.html.$lang")
$(mes "$outpath/index.${lang}.html"):
	ln -sf "$outbase" "$outpath/index.${lang}.html"
$(mes "$outpath/index.html.$lang"):
	ln -sf "$outbase" "$outpath/index.html.$lang"
MakeEND
  done
}

xhtml_makers(){
  # generate make rules concerning all .xhtml files in source tree
  sourcefind -name '*.[a-z][a-z].xhtml' \
  | sed -r 's;\.[a-z][a-z]\.xhtml$;;' \
  | sort -u \
  | while read shortpath; do
    xhtml_maker "$shortpath" "$(dirname "$shortpath")"
  done 
}

xhtml_additions(){
  printf "%s\n" "$@" \
  | sed -rn 's;\.[a-z][a-z]\.xhtml$;;p' \
  | sort -u \
  | xargs realpath \
  | while read addition; do
    xhtml_maker "${addition#$input/}" "$(dirname "${addition#$input/}")"
  done
}

copy_maker(){
  # generate make rule for copying a plain file
  infile="\${INPUTDIR}/$1"
  outpath="\${OUTPUTDIR}/${2}"
  outpath="${outpath%/.}"
  outfile="$outpath/$(basename "$infile")"

  cat <<MakeEND
all: $(mes "$outfile")
$(mes "$outfile"): $(mes "$infile")
	cp "$infile" "$outfile"
MakeEND
}

copy_makers(){
  # generate copy rules for entire input tree
  sourcefind \! -name 'Makefile' \! -name '*.sourceglobs' \! -name '*.refglobs' \
             \! -name '*.sources' \! -name '*.xhtml' \! -name '*.xml' \
             \! -name '*.xsl' \! -name 'tagmap' \! -name '*.langglob' \
  | while read filepath; do
    copy_maker "$filepath" "$(dirname "$filepath")"
  done 
}

copy_additions(){
  printf "%s\n" "$@" \
  | egrep -v '.+(\.sources|\.sourceglobs|\.refglobs|\.xhtml|\.xml|\.xsl|/Makefile|/)$' \
  | xargs realpath \
  | while read addition; do
    copy_maker "${addition#$input/}" "$(dirname "${addition#$input/}")"
  done
}

xslt_dependencies(){
  # list referenced xsl files for a given xsl file
  # *not* recursive since Make will handle recursive
  # dependency resolution
  file="$1"

  cat "$file" \
  | tr '\n\t' '  ' \
  | sed -r 's;(<xsl:(include|import)[^>]*>);\n\1\n;g' \
  | sed -nr '/<xsl:(include|import)[^>]*>/s;^.*href *= *"([^"]*)".*$;\1;gp'
}

xslt_maker(){
  # find external references in a xsl file and generate
  # Make dependencies accordingly

  file="$input/$1"
  dir="$(dirname "$file")"

  deps="$( xslt_dependencies "$file" |xargs -I'{}' realpath "$dir/{}" )"
  cat <<MakeEND
$(mes "$file"): $(mes $deps)
	touch "$(mio "$file")"
MakeEND
}

xslt_makers(){
  # generate make dependencies for all .xsl files in input tree
  sourcefind -name '*.xsl' \
  | while read filepath; do
    xslt_maker "$filepath"
  done 
}

xslt_additions(){
  printf "%s\n" "$@" \
  | egrep '.+\.xsl$' \
  | xargs realpath \
  | while read addition; do
    xslt_maker "${addition#$input/}"
  done
}

copy_sources(){
  # generate rules to copy all .xhtml files in the input to
  # the public source directory
  sourcefind -name '*.xhtml' \
  | while read filepath; do
    copy_maker "$filepath" "source/$(dirname "$filepath")"
  done
}

copy_sourceadditions(){
  printf "%s\n" "$@" \
  | egrep '.+\.xhtml$' \
  | xargs realpath \
  | while read addition; do
    copy_maker "${addition#$input/}" "source/$(dirname "${addition#$input/}")"
  done
}

tree_maker(){
  # walk through file tree and issue Make rules according to file type
  input="$(realpath "$1")"
  output="$(realpath "$2")"
  shift 2

  cache_textsfile
  cache_fundraising

  cat <<MakeHead
.PHONY: all
PROCESSOR = "$basedir/build/process_file.sh"
PGLOBBER = "$basedir/build/source_globber.sh"
PROCFLAGS = --source "$basedir" --statusdir "$statusdir" --domain "$domain"
INPUTDIR = $input
OUTPUTDIR = $output

# cannot store find results in variable because it will result in too many arguments for the shell
\${INPUTDIR}/tagmap: \$(shell find "$basedir" -name '*.[a-z][a-z].xml')
	find "$basedir" -name '*.[a-z][a-z].xml' |xargs \${PGLOBBER} \${PROCFLAGS} map_tags >\${INPUTDIR}/tagmap
MakeHead

  forcelog Make_globs;      Make_globs="$(logname Make_globs)"
  forcelog Make_xslt;       Make_xslt="$(logname Make_xslt)"
  forcelog Make_copy;       Make_copy="$(logname Make_copy)"
  forcelog Make_sourcecopy; Make_sourcecopy="$(logname Make_sourcecopy)"
                            Make_xhtml="$(logname Make_xhtml)"

  trap "trap - 0 2 3 6 9 15; killall \"$(basename "$0")\"" 0 2 3 6 9 15

  [ "$regen_globs" = false -a -s "$Make_globs" ] && \
     glob_additions "$@" >>"$Make_globs" \
  || glob_makers >"$Make_globs" &
  [ "$regen_xslt" = false -a -s "$Make_xslt" ] && \
     xslt_additions "$@" >>"$Make_xslt" \
  || xslt_makers >"$Make_xslt" &
  [ "$regen_copy" = false -a -s "$Make_copy" ] && \
     copy_additions "$@" >>"$Make_copy" \
  || copy_makers >"$Make_copy" &
  [ "$regen_xhtml" = false -a -s "$Make_sourcecopy" ] && \
     copy_sourceadditions "$@" >>"$Make_sourcecopy" \
  || copy_sources >"$Make_sourcecopy" &

  if [ "$regen_xhtml" = false -a -s "$Make_xhtml" ]; then
    cat "$Make_xhtml"
    xhtml_additions "$@" |tee -a "$Make_xhtml"
  else
    xhtml_makers |tee "$Make_xhtml"
  fi

  wait
  trap - 0 2 3 6 9 15

  cat "$Make_globs" "$Make_xslt" "$Make_copy" "$Make_sourcecopy"
}

