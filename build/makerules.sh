#!/bin/bash

inc_makerules=true
[ -z "$inc_misc" ] && . "$basedir/build/misc.sh"
[ -z "$inc_translations" ] && . "$basedir/build/translations.sh"
[ -z "$inc_filenames" ] && . "$basedir/build/filenames.sh"
[ -z "$inc_fundraising" ] && . "$basedir/build/fundraising.sh"
[ -z "$inc_languages" ] && . "$basedir/build/languages.sh"
[ -z "$inc_sources" ] && . "$basedir/build/sources.sh"

sourcefind() {
  find "$input" -name .svn -prune -o -name .git -prune -o -type f "$@" -printf '%P\n'
}

mio(){
  # make input/output abstraction, produce reusable makefiles
  # by replacing in and out pathes with make variables.
  for each in "$@"; do
    case "$each" in
      "$input"/*)  printf '${INPUTDIR}/%s\n' "${each#${input}/}" ;;
      "$output"/*) printf '${OUTPUTDIR}/%s\n' "${each#${output}/}" ;;
      *) printf %s\\n "$each" ;;
    esac
  done
}

mes(){
  # make escape... escape a filename for make syntax
  # possibly not complete
  mio "$@" \
  | sed -r ':X; $bY; N; bX; :Y;
            s;[ #];\\&;g; s;\n; ;g'
}

xhtml_maker(){
  # generate make rules for building html files out of xhtml
  # account for included xml files and xsl rules

  shortname="$input/$1"
  outpath="\${OUTPUTDIR}/${2}"
  outpath="${outpath%/*}"

  textsen="$(get_textsfile "en")"
  menufile="$basedir/tools/menu-global.xml"
  filedir="${shortname%/*}"
  shortbase="${shortname##*/}"
  processor="$(get_processor "$shortname")"
  list_file="`dirname ${shortname}`/.`basename ${shortname}`.xmllist"

  [ -f "${list_file}" ] && xmllist="${list_file}" || unset xmllist

  # For speed considerations: avoid all disk I/O in this loop
  for lang in $(get_languages); do
    infile="${shortname}.${lang}.xhtml"
    depfile="${shortname}.*.xhtml"

    infile="$(mio "$infile")"
    outbase="${shortbase}.${lang}.html"
    outfile="${outpath}/${outbase}"

    textsfile="$(get_textsfile "$lang")"
    fundraisingfile="$(get_fundraisingfile "$lang")"

    cat <<MakeEND
all: $(mes "$outfile")
$(mes "$outfile"): $(mes "$depfile" "$processor" "$textsen" "$textsfile" "$fundraisingfile" "$menufile" "$xmllist")
	\${PROCESSOR} \${PROCFLAGS} process_file "${infile}" "$(mio "$processor")" >"$outfile" || { rm $outfile; exit 1; }
MakeEND
  done
}

xhtml_makers(){
  # generate make rules concerning all .xhtml files in source tree
  sourcefind -name '*.[a-z][a-z].xhtml' \
  | sed -r 's;\.[a-z][a-z]\.xhtml$;;' \
  | sort -u \
  | while read shortpath; do
    xhtml_maker "$shortpath" "${shortpath}"
  done 
}

xhtml_additions(){
  printf "%s\n" "$@" \
  | sed -rn 's;\.[a-z][a-z]\.xhtml$;;p' \
  | sort -u \
  | xargs realpath \
  | while read addition; do
    xhtml_maker "${addition#$input/}" "${addition#$input/}"
  done
}

xslt_dependencies(){
  # list referenced xsl files for a given xsl file
  # *not* recursive since Make will handle recursive
  # dependency resolution
  file="$1"

  cat "$file" \
  | tr '\n\t\r' '   ' \
  | sed -r 's;(<xsl:(include|import)[^>]*>);\n\1\n;g' \
  | sed -nr '/<xsl:(include|import)[^>]*>/s;^.*href *= *"([^"]*)".*$;\1;gp'
}

xslt_maker(){
  # find external references in a xsl file and generate
  # Make dependencies accordingly

  file="$input/$1"
  dir="${file%/*}"

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

tree_maker(){
  # walk through file tree and issue Make rules according to file type
  input="$(realpath "$1")"
  output="$(realpath "$2")"
  shift 2

  # List of languages in a single line, separated by blanks
  languages=$(get_languages)

  cache_textsfile
  cache_fundraising

  cat <<EOF
.PHONY: all
.DELETE_ON_ERROR:
PROCESSOR = "$basedir/build/process_file.sh"
PROCFLAGS = --source "$basedir" --statusdir "$statusdir" --domain "$domain"
INPUTDIR = $input
OUTPUTDIR = $output
STATUSDIR = $statusdir
LANGUAGES = $languages

# -----------------------------------------------------------------------------
# Build .html files from .xhtml sources
# -----------------------------------------------------------------------------

# All .xhtml source files
HTML_SRC_FILES := \$(shell find \$(INPUTDIR) -name '*.??.xhtml')

# All basenames of .xhtml source files (without .<lang>.xhtml ending)
# Note: \$(sort ...) is used to remove duplicates
HTML_SRC_BASES := \$(sort \$(basename \$(basename \$(HTML_SRC_FILES))))

# All directories containing .xhtml source files
HTML_SRC_DIRS := \$(sort \$(dir \$(HTML_SRC_BASES)))

# The same as above, but moved to the output directory
HTML_DST_BASES := \$(patsubst \$(INPUTDIR)/%,\$(OUTPUTDIR)/%,\$(HTML_SRC_BASES))

# List of .<lang>.html files to build
HTML_DST_FILES := \$(foreach base,\$(HTML_DST_BASES),\$(foreach lang,\$(LANGUAGES),\$(base).\$(lang).html))

# -----------------------------------------------------------------------------
# Create index.* symlinks
# -----------------------------------------------------------------------------

# All .xhtml source files with the same name as their parent directory
INDEX_SRC_FILES := \$(wildcard \$(foreach directory,\$(HTML_SRC_DIRS),\$(directory)\$(notdir \$(directory:/=)).??.xhtml))

# All basenames of .xhtml source files with the same name as their parent
# directory
INDEX_SRC_BASES := \$(sort \$(basename \$(basename \$(INDEX_SRC_FILES))))

# All directories containing .xhtml source files with the same name as their
# parent directory (that is, all directories in which index files should be
# created)
INDEX_SRC_DIRS := \$(dir \$(INDEX_SRC_BASES))

# The same as above, but moved to the output directory
INDEX_DST_DIRS := \$(patsubst \$(INPUTDIR)/%,\$(OUTPUTDIR)/%,\$(INDEX_SRC_DIRS))

# List of index.<lang>.html symlinks to create
INDEX_DST_LINKS := \$(foreach base,\$(INDEX_DST_DIRS),\$(foreach lang,\$(LANGUAGES),\$(base)index.\$(lang).html))

all: \$(INDEX_DST_LINKS)
EOF

  for lang in ${languages}; do
    cat<<EOF
\$(OUTPUTDIR)/%/index.${lang}.html:
	@echo "* Creating symlink \$*/index.${lang}.html"
	@ln -sf \$(notdir \$*).${lang}.html \$@
EOF
  done

  cat <<EOF

# -----------------------------------------------------------------------------
# Create symlinks from file.<lang>.html to file.html.<lang>
# -----------------------------------------------------------------------------

# List of .html.<lang> symlinks to create
HTML_DST_LINKS := \$(foreach base,\$(HTML_DST_BASES) \$(addsuffix index,\$(INDEX_DST_DIRS)),\$(foreach lang,\$(LANGUAGES),\$(base).html.\$(lang)))

all: \$(HTML_DST_LINKS)
EOF

  for lang in ${languages}; do
    cat<<EOF
\$(OUTPUTDIR)/%.html.${lang}:
	@echo "* Creating symlink \$*.html.${lang}"
	@ln -sf \$(notdir \$*).${lang}.html \$@
EOF
  done

  cat <<EOF

# -----------------------------------------------------------------------------
# Build .rss files from .xhtml sources
# -----------------------------------------------------------------------------

# All .rss.xsl scripts which can create .rss output
RSS_SRC_SCRIPTS := \$(shell find \$(INPUTDIR) -name '*.rss.xsl')

# All basenames of .xhtml source files from which .rss files should be built
RSS_SRC_BASES := \$(sort \$(basename \$(basename \$(RSS_SRC_SCRIPTS))))

# The same as above, but moved to the output directory
RSS_DST_BASES := \$(patsubst \$(INPUTDIR)/%,\$(OUTPUTDIR)/%,\$(RSS_SRC_BASES))

# List of .<lang>.rss files to build
RSS_DST_FILES := \$(foreach base,\$(RSS_DST_BASES),\$(foreach lang,\$(LANGUAGES),\$(base).\$(lang).rss))

all: \$(RSS_DST_FILES)
EOF

  for lang in ${languages}; do
    cat<<EOF
\$(OUTPUTDIR)/%.${lang}.rss: \$(INPUTDIR)/%.*.xhtml \$(INPUTDIR)/.%.xmllist \$(INPUTDIR)/%.rss.xsl \$(INPUTDIR)/tools/menu-global.xml $(get_textsfile "en") $(get_fundraisingfile "${lang}")
	@echo "* Building \$*.${lang}.rss"
	@\${PROCESSOR} \${PROCFLAGS} process_file \$(INPUTDIR)/\$*.${lang}.xhtml \$(INPUTDIR)/\$*.rss.xsl > \$@
EOF
  done

  cat <<EOF

# -----------------------------------------------------------------------------
# Build .ics files from .xhtml sources
# -----------------------------------------------------------------------------

# All .ics.xsl scripts which can create .ics output
ICS_SRC_SCRIPTS := \$(shell find \$(INPUTDIR) -name '*.ics.xsl')

# All basenames of .xhtml source files from which .ics files should be built
ICS_SRC_BASES := \$(sort \$(basename \$(basename \$(ICS_SRC_SCRIPTS))))

# The same as above, but moved to the output directory
ICS_DST_BASES := \$(patsubst \$(INPUTDIR)/%,\$(OUTPUTDIR)/%,\$(ICS_SRC_BASES))

# List of .<lang>.ics files to build
ICS_DST_FILES := \$(foreach base,\$(ICS_DST_BASES),\$(foreach lang,\$(LANGUAGES),\$(base).\$(lang).ics))

all: \$(ICS_DST_FILES)
EOF

  for lang in ${languages}; do
    cat<<EOF
\$(OUTPUTDIR)/%.${lang}.ics: \$(INPUTDIR)/%.*.xhtml \$(INPUTDIR)/.%.xmllist \$(INPUTDIR)/%.ics.xsl \$(INPUTDIR)/tools/menu-global.xml $(get_textsfile "en") $(get_fundraisingfile "${lang}")
	@echo "* Building \$*.${lang}.ics"
	@\${PROCESSOR} \${PROCFLAGS} process_file \$(INPUTDIR)/\$*.${lang}.xhtml \$(INPUTDIR)/\$*.ics.xsl > \$@
EOF
  done

  cat <<EOF

# -----------------------------------------------------------------------------
# Copy images, docments etc
# -----------------------------------------------------------------------------

# All files which should just be copied over
COPY_SRC_FILES := \$(shell find \$(INPUTDIR) -type f -not -path '\$(INPUTDIR)/.git/*' -not -name 'Makefile' -not -name '*.sources' -not -name "*.xmllist" -not -name '*.xhtml' -not -name '*.xml' -not -name '*.xsl')

# The same as above, but moved to the output directory
COPY_DST_FILES := \$(patsubst \$(INPUTDIR)/%,\$(OUTPUTDIR)/%,\$(COPY_SRC_FILES))

all: \$(COPY_DST_FILES)
\$(COPY_DST_FILES): \$(OUTPUTDIR)/%: \$(INPUTDIR)/%
	@echo "* Copying file \$*"
	@cp \$< \$@

# -----------------------------------------------------------------------------
# Copy .xhtml files to "source" directory in target directory tree
# -----------------------------------------------------------------------------

SOURCE_DST_FILES := \$(patsubst \$(INPUTDIR)/%,\$(OUTPUTDIR)/source/%,\$(HTML_SRC_FILES))

all: \$(SOURCE_DST_FILES)
\$(SOURCE_DST_FILES): \$(OUTPUTDIR)/source/%: \$(INPUTDIR)/%
	@echo "* Copying source \$*"
	@cp \$< \$@

# -----------------------------------------------------------------------------
# Clean up excess files in target directory
# -----------------------------------------------------------------------------

ALL_DST := \$(HTML_DST_FILES) \$(INDEX_DST_LINKS) \$(HTML_DST_LINKS) \$(RSS_DST_FILES) \$(ICS_DST_FILES) \$(COPY_DST_FILES) \$(SOURCE_DST_FILES)

.PHONY: clean
all: clean
clean:
	@# Write all destination filenames into "manifest" file, one per line
	\$(file >\$(STATUSDIR)/manifest)
	\$(foreach filename,\$(ALL_DST),\$(file >>\$(STATUSDIR)/manifest,\$(filename)))
	@sort \$(STATUSDIR)/manifest > \$(STATUSDIR)/manifest.sorted
	@find -L \$(OUTPUTDIR) -type f \\
	  | sort \\
	  | diff - \$(STATUSDIR)/manifest.sorted \\
	  | sed -rn 's;^< ;;p' \\
	  | while read file; do echo "* Deleting \$\${file}"; rm "\$\${file}"; done

# -----------------------------------------------------------------------------

EOF

  forcelog Make_xslt;       Make_xslt="$(logname Make_xslt)"
                            Make_xhtml="$(logname Make_xhtml)"

  trap "trap - 0 2 3 6 9 15; killall \"${0##*/}\"" 0 2 3 6 9 15

  [ "$regen_xslt" = false -a -s "$Make_xslt" ] && \
     xslt_additions "$@" >>"$Make_xslt" \
  || xslt_makers >"$Make_xslt" &

  if [ "$regen_xhtml" = false -a -s "$Make_xhtml" ]; then
    cat "$Make_xhtml"
    xhtml_additions "$@" |tee -a "$Make_xhtml"
  else
    xhtml_makers |tee "$Make_xhtml"
  fi

  wait
  trap - 0 2 3 6 9 15

  cat "$Make_xslt"
}

