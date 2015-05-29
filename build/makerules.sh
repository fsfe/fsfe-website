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

glob_maker(){
  sourcesfile="$1"

  filedir=$(dirname "$sourcesfile")
  shortbase="$(basename "$sourcesfile" |sed -r 's;\.sources$;;')"
  sourceglobfile="${filedir}/._._${shortbase}.sourceglobs"

  cat <<MakeEND
$(mes "$sourceglobfile"): $(mes $(all_sources "$sourcesfile"))
	\${PSOURCEGLOBS} \${PROCFLAGS} "$sourcesfile" >"$sourceglobfile"
MakeEND

  for lang in $(get_languages); do
    globfile="${filedir}/._._${shortbase}.${lang}.sourceglobs"
    cat <<MakeEND
$(mes "$globfile"): $(mes "$sourceglobfile")
	\${PGLOBCASTER} \${PROCFLAGS} "$sourceglobfile" "$lang" "$globfile"
MakeEND
  done
}
glob_makers(){
  sourcefind -name '*.sources' \
  | while read filepath; do
    glob_maker "$input/$filepath"
  done 
}

xhtml_maker(){
  # generate make rules for building html files out of xhtml
  # account for included xml files and xsl rules

  shortname="$1"
  outpath="$2"

  textsen="$(get_textsfile "en")"
  menufile="$basedir/tools/menu-global.xml"
  filedir="$(dirname "$shortname")"
  shortbase="$(basename "$shortname")"
  processor="$(get_processor "$shortname")"

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
    [ -f "$infile" ] && depfile="$infile" || depfile="${shortname}.${olang}.xhtml" 

    outbase="${shortbase}.${lang}.html"
    outfile="${outpath}/${outbase}"
    outlink="${outpath}/${shortbase}.html.$lang"
    rssfile="${outpath}/${shortbase}.${lang}.rss"
    icsfile="${outpath}/${shortbase}.${lang}.ics"

    textsfile="$(get_textsfile "$lang")"
    fundraisingfile="$(get_fundraisingfile "$lang")"
    $bool_sourceinc && sourceglobs="${filedir}/._._${shortbase}.${lang}.sourceglobs" || unset sourceglobs

    cat <<MakeEND
all: $(mes "$outfile" "$outlink")
$(mes "$outfile"): $(mes "$depfile" "$processor" "$textsen" "$textsfile" "$fundraisingfile" "$menufile" "$sourceglobs")
	\${PROCESSOR} \${PROCFLAGS} "${infile}" "$processor" "$olang" >"$outfile"
$(mes "$outlink"):
	ln -sf "${outbase}" "${outlink}"
MakeEND
    $bool_rss && cat<<MakeEND
all: $(mes "$rssfile")
$(mes "$rssfile"): $(mes "$depfile" "${shortname}.rss.xsl" "$textsen" "$textsfile" "$fundraisingfile" "$menufile" "$sourceglobs")
	\${PROCESSOR} \${PROCFLAGS} "${infile}" "${shortname}.rss.xsl" "$olang" >"$rssfile"
MakeEND
    $bool_ics && cat<<MakeEND
all: $(mes "$icsfile")
$(mes "$icsfile"): $(mes "$depfile" "${shortname}.ics.xsl" "$textsen" "$textsfile" "$fundraisingfile" "$menufile" "$sourceglobs")
	\${PROCESSOR} \${PROCFLAGS} "${infile}" "${shortname}.ics.xsl" "$olang" >"$icsfile"
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
  sourcefind -name '*.[a-z][a-z].xhtml' \
  | sed -r "s;^(.+)\.[a-z][a-z]\.xhtml$;\1;" \
  | sort -u \
  | while read shortpath; do
    xhtml_maker "$input/$shortpath" "$output/$(dirname "$shortpath")"
  done 
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
copy_makers(){
  sourcefind \! -name 'Makefile' \! -name '*.sourceglobs' \! -name '*.sources' \
             \! -name '*.xhtml' \! -name '*.xml' \! -name '*.xsl' \
  | while read filepath; do
    copy_maker "$input/$filepath" "$output/$(dirname "$filepath")"
  done 
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
xslt_makers(){
  sourcefind -name '*.xsl' \
  | while read filepath; do
    xslt_maker "$input/$filepath"
  done 
}

copy_sources(){
  sourcefind -name '*.xhtml' \
  | while read filepath; do
    copy_maker "$input/$filepath" "$output/source/$(dirname "$filepath")"
  done
}

tree_maker(){
  # walk through file tree and issue Make rules according to file type
  input="$(echo "$1" |sed -r 's:/$::')"
  output="$(echo "$2" |sed -r 's:/$::')"

  cache_textsfile
  cache_fundraising

  logstatus Make_head <<-MakeHead
	.PHONY: all
	PROCESSOR = "$basedir/build/process_file.sh"
	PSOURCEGLOBS = "$basedir/build/source_globber.sh" sourceglobs
	PGLOBCASTER = "$basedir/build/source_globber.sh" cast_globfile
	PROCFLAGS = --source "$basedir" --statusdir "$statusdir" --domain "$domain"
	MakeHead

  forcelog Make_globs;      Make_globs="$(logname Make_globs)"
  forcelog Make_xslt;       Make_xslt="$(logname Make_xslt)"
  forcelog Make_copy;       Make_copy="$(logname Make_copy)"
  forcelog Make_sourcecopy; Make_sourcecopy="$(logname Make_sourcecopy)"
  forcelog Make_xhtml;      Make_xhtml="$(logname Make_xhtml)"

  [ "$regen_globs" = false -a -s "$Make_globs" ] \
  || glob_makers >"$Make_globs" &
  [ "$regen_xslt" = false -a -s "$Make_xslt" ] \
  || xslt_makers >"$Make_xslt" &
  [ "$regen_copy" = false -a -s "$Make_copy" ] \
  || copy_makers >"$Make_copy" &
  [ "$regen_xhtml" = false -a -s "$Make_sourcecopy" ] \
  || copy_sources >"$Make_sourcecopy" &
  [ "$regen_xhtml" = false -a -s "$Make_xhtml" ] \
  || xhtml_makers >"$Make_xhtml" &

  trap "trap - 0 2 3 6 9 15; killall \"$(basename "$0")\"" 0 2 3 6 9 15
  wait
  trap - 0 2 3 6 9 15
  cat "$Make_globs" "$Make_xslt" "$Make_copy" "$Make_sourcecopy" "$Make_xhtml"
}

