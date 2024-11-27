# -----------------------------------------------------------------------------
# Makefile for FSFE website build, phase 1
# -----------------------------------------------------------------------------
# This Makefile is executed in the root of the source directory tree, and
# creates some .xml and xhtml files as well as some symlinks, all of which
# serve as input files in phase 2. The whole phase 1 runs within the source
# directory tree and does not touch the target directory tree at all.
# -----------------------------------------------------------------------------

.PHONY: all .FORCE
.FORCE:

# This will be overwritten in the command line running this Makefile.
build_env = development
languages = none

# -----------------------------------------------------------------------------
# Build search index
# -----------------------------------------------------------------------------

# This step runs a Python tool that creates an index of all news and
# articles. It extracts titles, teaser, tags, dates and potentially more.
# The result will be fed into a JS file.

.PHONY: searchindex
all: searchindex
searchindex:
	python3 tools/index-website.py

# -----------------------------------------------------------------------------
# Update CSS files
# -----------------------------------------------------------------------------

# This step recompiles the less files into the final CSS files to be
# distributed to the web server.

ifneq ($(build_env),development)
websites:=$(shell find . -mindepth 2 -maxdepth 2 -type d -regex "./[a-z\.]+\.[a-z]+/look")
all: $(foreach dir,$(websites), $(dir)/fsfe.min.css $(dir)/valentine.min.css)
$(dir $@)%.min.css: $(shell find $(dir $@) -name '*.less')
	echo "* Compiling $@"
	lessc "$*.less" -x "$@"
endif

# -----------------------------------------------------------------------------
# Update XSL stylesheets
# -----------------------------------------------------------------------------

# This step updates (actually: just touches) all XSL files which depend on
# another XSL file that has changed since the last build run. The phase 2
# Makefile then only has to consider the directly used stylesheet as a
# prerequisite for building each file and doesn't have to worry about other
# stylesheets imported into that one.
# This must run before the "dive into subdirectories" step, because in the news
# and events directories, the XSL files, if updated, will be copied for the
# per-year archives.

.PHONY: stylesheets
all: stylesheets
stylesheets: $(SUBDIRS)
	tools/update_stylesheets.sh

# -----------------------------------------------------------------------------
# Dive into subdirectories
# -----------------------------------------------------------------------------

SUBDIRS := $(shell find . -regex "./[a-z\.]+\.[a-z]+/.*/Makefile" | xargs dirname)

all: $(SUBDIRS)
$(SUBDIRS): .FORCE
	echo "* Preparing subdirectory $@"
	$(MAKE) --silent --directory=$@ languages="$(languages)"

# -----------------------------------------------------------------------------
# Create XML symlinks
# -----------------------------------------------------------------------------

# After this step, the following symlinks will exist:
# * global/data/texts/.texts.<lang>.xml for each language
# * global/data/topbanner/.topbanner.<lang>.xml for each language
# Each of these symlinks will point to the corresponding file without a dot at
# the beginning of the filename, if present, and to the English version
# otherwise. This symlinks make sure that phase 2 can easily use the right file
# for each language, also as a prerequisite in the Makefile.

TEXTS_LINKS := $(foreach lang,$(languages),global/data/texts/.texts.$(lang).xml)

all: $(TEXTS_LINKS)
global/data/texts/.texts.%.xml: .FORCE
	if [ -f global/data/texts/texts.$*.xml ]; then \
	  ln -sf texts.$*.xml $@; \
	else \
	  ln -sf texts.en.xml $@; \
	fi

TOPBANNER_LINKS := $(foreach lang,$(languages),global/data/topbanner/.topbanner.$(lang).xml)

all: $(TOPBANNER_LINKS)
global/data/topbanner/.topbanner.%.xml: .FORCE
	if [ -f global/data/topbanner/topbanner.$*.xml ]; then \
	  ln -sf topbanner.$*.xml $@; \
	else \
	  ln -sf topbanner.en.xml $@; \
	fi

# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# The following steps are handled in an external script, because the list of
# files to generate is not known when the Makefile starts - some new tags might
# be introduced when generating the .xml files in the news/* subdirectories.
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

# -----------------------------------------------------------------------------
# Create XSL symlinks
# -----------------------------------------------------------------------------

# After this step, each directory with source files for HTML pages contains a
# symlink named .default.xsl and pointing to the default.xsl "responsible" for
# this directory. These symlinks make it easier for the phase 2 Makefile to
# determine which XSL script should be used to build a HTML page from a source
# file.

.PHONY: default_xsl
all: default_xsl
default_xsl:
	tools/update_defaultxsls.sh

# -----------------------------------------------------------------------------
# Update local menus
# -----------------------------------------------------------------------------

# After this step, all .localmenu.??.xml files will be up to date.

.PHONY: localmenus
all: localmenus
localmenus: $(SUBDIRS)
	tools/update_localmenus.sh "$(languages)"

# -----------------------------------------------------------------------------
# Update XML filelists
# -----------------------------------------------------------------------------

# After this step, the following files will be up to date:
# * tags/tagged-<tags>.en.xhtml for each tag used. Apart from being
#   automatically created, these are regular source files for HTML pages, and
#   in phase 2 are built into pages listing all news items and events for a
#   tag.
# * tags/.tags.??.xml with a list of the tags useed.
# * <dir>/.<base>.xmllist for each <dir>/<base>.sources as well as for each
#   tags/tagged-<tags>.en.xhtml. These files are used in phase 2 to include the
#   correct XML files when generating the HTML pages. It is taken care that
#   these files are only updated whenever their content actually changes, so
#   they can serve as a prerequisite in the phase 2 Makefile.

.PHONY: xmllists
all: xmllists
xmllists: $(SUBDIRS)
	tools/update_xmllists.sh "$(languages)"
