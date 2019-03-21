#!/bin/bash

inc_makerules=true
[ -z "$inc_languages" ] && . "$basedir/build/languages.sh"

tree_maker(){
  # walk through file tree and issue Make rules according to file type
  input="$(realpath "$1")"
  output="$(realpath "$2")"
  languages=$(get_languages)

  cat <<EOF
# -----------------------------------------------------------------------------
# Makefile for FSFE website build, phase 2
# -----------------------------------------------------------------------------

.PHONY: all
.DELETE_ON_ERROR:
.SECONDEXPANSION:
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
HTML_SRC_FILES := \$(shell find "\$(INPUTDIR)" \
  -name '*.??.xhtml' \
  -not -path '\$(INPUTDIR)/.git/*' \
)

# All basenames of .xhtml source files (without .<lang>.xhtml ending)
# Note: \$(sort ...) is used to remove duplicates
HTML_SRC_BASES := \$(sort \$(basename \$(basename \$(HTML_SRC_FILES))))

# All directories containing .xhtml source files
HTML_SRC_DIRS := \$(sort \$(dir \$(HTML_SRC_BASES)))

# The same as above, but moved to the output directory
HTML_DST_BASES := \$(patsubst \$(INPUTDIR)/%,\$(OUTPUTDIR)/%,\$(HTML_SRC_BASES))

# List of .<lang>.html files to build
HTML_DST_FILES := \$(foreach base,\$(HTML_DST_BASES),\$(foreach lang,\$(LANGUAGES),\$(base).\$(lang).html))

# .xmllist file used to build a html file
XMLLIST_DEP = \$(wildcard \$(INPUTDIR)/\$(dir \$*).\$(notdir \$*).xmllist)

# .xsl file used to build a html file
XSL_DEP = \$(firstword \$(wildcard \$(INPUTDIR)/\$*.xsl) \$(INPUTDIR)/\$(dir \$*).default.xsl)

all: \$(HTML_DST_FILES)
EOF

  for lang in ${languages}; do
    cat<<EOF
\$(filter %.${lang}.html,\$(HTML_DST_FILES)): \$(OUTPUTDIR)/%.${lang}.html: \$(INPUTDIR)/%.*.xhtml \$\$(XMLLIST_DEP) \$\$(XSL_DEP) \$(INPUTDIR)/tools/menu-global.xml \$(INPUTDIR)/tools/.texts-${lang}.xml \$(INPUTDIR)/tools/texts-en.xml \$(INPUTDIR)/.fundraising.${lang}.xml \$(INPUTDIR)/fundraising.en.xml
	echo "* Building \$*.${lang}.html"
	\${PROCESSOR} \${PROCFLAGS} process_file "\$(INPUTDIR)/\$*.${lang}.xhtml" > "\$@"
EOF
  done

  cat <<EOF

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
\$(filter %/index.${lang}.html,\$(INDEX_DST_LINKS)): \$(OUTPUTDIR)/%/index.${lang}.html:
	echo "* Creating symlink \$*/index.${lang}.html"
	ln -sf "\$(notdir \$*).${lang}.html" "\$@"
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
	echo "* Creating symlink \$*.html.${lang}"
	ln -sf "\$(notdir \$*).${lang}.html" "\$@"
EOF
  done

  cat <<EOF

# -----------------------------------------------------------------------------
# Build .rss files from .xhtml sources
# -----------------------------------------------------------------------------

# All .rss.xsl scripts which can create .rss output
RSS_SRC_SCRIPTS := \$(shell find "\$(INPUTDIR)" \
  -name '*.rss.xsl' \
  -not -path '\$(INPUTDIR)/.git/*' \
)

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
\$(OUTPUTDIR)/%.${lang}.rss: \$(INPUTDIR)/%.*.xhtml \$\$(XMLLIST_DEP) \$(INPUTDIR)/%.rss.xsl \$(INPUTDIR)/tools/menu-global.xml \$(INPUTDIR)/tools/.texts-${lang}.xml \$(INPUTDIR)/tools/texts-en.xml \$(INPUTDIR)/.fundraising.${lang}.xml \$(INPUTDIR)/fundraising.en.xml
	echo "* Building \$*.${lang}.rss"
	\${PROCESSOR} \${PROCFLAGS} process_file "\$(INPUTDIR)/\$*.${lang}.xhtml" "\$(INPUTDIR)/\$*.rss.xsl" > "\$@"
EOF
  done

  cat <<EOF

# -----------------------------------------------------------------------------
# Build .ics files from .xhtml sources
# -----------------------------------------------------------------------------

# All .ics.xsl scripts which can create .ics output
ICS_SRC_SCRIPTS := \$(shell find "\$(INPUTDIR)" \
  -name '*.ics.xsl' \
  -not -path '\$(INPUTDIR)/.git/*' \
)

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
\$(OUTPUTDIR)/%.${lang}.ics: \$(INPUTDIR)/%.*.xhtml \$\$(XMLLIST_DEP) \$(INPUTDIR)/%.ics.xsl \$(INPUTDIR)/tools/menu-global.xml \$(INPUTDIR)/tools/.texts-${lang}.xml \$(INPUTDIR)/tools/texts-en.xml \$(INPUTDIR)/.fundraising.${lang}.xml \$(INPUTDIR)/fundraising.en.xml
	echo "* Building \$*.${lang}.ics"
	\${PROCESSOR} \${PROCFLAGS} process_file "\$(INPUTDIR)/\$*.${lang}.xhtml" "\$(INPUTDIR)/\$*.ics.xsl" > "\$@"
EOF
  done

  cat <<EOF

# -----------------------------------------------------------------------------
# Copy images, docments etc
# -----------------------------------------------------------------------------

# All files which should just be copied over
COPY_SRC_FILES := \$(shell find "\$(INPUTDIR)" -type f \
  -not -path '\$(INPUTDIR)/.git/*' \
  -not -path '\$(INPUTDIR)/build/*' \
  -not -path '\$(INPUTDIR)/tools/*' \
  -not -name '.drone.yml' \
  -not -name '.gitignore' \
  -not -name 'README*' \
  -not -name 'Makefile' \
  -not -name '*.sources' \
  -not -name "*.xmllist" \
  -not -name '*.xhtml' \
  -not -name '*.xml' \
  -not -name '*.xsl' \
)

# The same as above, but moved to the output directory
COPY_DST_FILES := \$(sort \$(patsubst \$(INPUTDIR)/%,\$(OUTPUTDIR)/%,\$(COPY_SRC_FILES)))

all: \$(COPY_DST_FILES)
\$(COPY_DST_FILES): \$(OUTPUTDIR)/%: \$(INPUTDIR)/%
	echo "* Copying file \$*"
	cp "\$<" "\$@"

# -----------------------------------------------------------------------------
# Copy .xhtml files to "source" directory in target directory tree
# -----------------------------------------------------------------------------

SOURCE_DST_FILES := \$(sort \$(patsubst \$(INPUTDIR)/%,\$(OUTPUTDIR)/source/%,\$(HTML_SRC_FILES)))

all: \$(SOURCE_DST_FILES)
\$(SOURCE_DST_FILES): \$(OUTPUTDIR)/source/%: \$(INPUTDIR)/%
	echo "* Copying source \$*"
	cp "\$<" "\$@"

# -----------------------------------------------------------------------------
# Clean up excess files in target directory
# -----------------------------------------------------------------------------

ALL_DST := \$(HTML_DST_FILES) \$(INDEX_DST_LINKS) \$(HTML_DST_LINKS) \$(RSS_DST_FILES) \$(ICS_DST_FILES) \$(COPY_DST_FILES) \$(SOURCE_DST_FILES)

.PHONY: clean
all: clean
clean:
	# Write all destination filenames into "manifest" file, one per line
	\$(file >\$(STATUSDIR)/manifest)
	\$(foreach filename,\$(ALL_DST),\$(file >>\$(STATUSDIR)/manifest,\$(filename)))
	sort "\$(STATUSDIR)/manifest" > "\$(STATUSDIR)/manifest.sorted"
	find -L "\$(OUTPUTDIR)" -type f \\
	  | sort \\
	  | diff - "\$(STATUSDIR)/manifest.sorted" \\
	  | sed -rn 's;^< ;;p' \\
	  | while read file; do echo "* Deleting \$\${file}"; rm "\$\${file}"; done

# -----------------------------------------------------------------------------

EOF
}
