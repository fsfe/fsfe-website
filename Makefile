# -----------------------------------------------------------------------------
# Makefile for "premake" step
# -----------------------------------------------------------------------------
# This Makefile creates some .xml and xhtml files which serve as source files
# in the main build run. It is executed in the source directory, before the
# Makefile for the main build run is constructed and executed.
#
# It also touches all the .sources files which refer to added, modified, or
# deleted .xml files. This way, we avoid that in the main build Makefile each
# .html file has to list a long and changing list of .xml prerequisites - it is
# sufficient to just have the .sources file as a prerequisite.
# -----------------------------------------------------------------------------

.PHONY: all .FORCE
.FORCE:

# -----------------------------------------------------------------------------
# Dive into subdirectories
# -----------------------------------------------------------------------------

SUBDIRS := $(shell find */* -name "Makefile" | xargs dirname)

all: $(SUBDIRS)
$(SUBDIRS): .FORCE
	$(MAKE) -j -k -C $@ || true

# -----------------------------------------------------------------------------
# Handle local menus
# -----------------------------------------------------------------------------

MENUSOURCES := $(shell find -name '*.xhtml' | xargs grep -l '<localmenu.*</localmenu>' )

all: localmenuinfo.en.xml
localmenuinfo.en.xml: ./tools/buildmenu.xsl $(MENUSOURCES)
	{ printf '<localmenuset>'; \
	  grep -E '<localmenu.*</localmenu>' $^ \
          | sed -r 's;(.*/)?(.+)\.([a-z][a-z])\.xhtml:(.+);\
                    <menuitem language="\3"><dir>/\1</dir><link>\2.html</link>\4</menuitem>;'; \
	  printf '</localmenuset>'; \
	} | xsltproc -o $@ $< -

# -----------------------------------------------------------------------------
# Timestamp files for regular jobs and XML inclusion in various places
# -----------------------------------------------------------------------------

YEAR  := <?xml version="1.0" encoding="utf-8"?><dateset><date year="$(shell date +%Y)" /></dateset> 
MONTH := <?xml version="1.0" encoding="utf-8"?><dateset><date month="$(shell date +%Y-%m)" /></dateset> 
DAY   := <?xml version="1.0" encoding="utf-8"?><dateset><date day="$(shell date +%Y-%m-%d)" /></dateset>

all: d_year.en.xml d_month.en.xml d_day.en.xml
d_day.en.xml: $(if $(findstring   $(DAY),$(shell cat d_day.en.xml)),,.FORCE)
	printf %s\\n   '$(DAY)' >$@
d_month.en.xml: $(if $(findstring $(MONTH),$(shell cat d_month.en.xml)),,.FORCE)
	printf %s\\n '$(MONTH)' >$@
d_year.en.xml: $(if $(findstring  $(YEAR),$(shell cat d_year.en.xml)),,.FORCE)
	printf %s\\n  '$(YEAR)' >$@

# -----------------------------------------------------------------------------
# Generate tag maps
# -----------------------------------------------------------------------------

# Generation of tag maps is handled in an external script which generates
# tools/tagmaps/*.map, tags/tagged-*.en.xhtml, and tags/tagged-*.sources. The
# tag map files cannot be targets in this Makefile, because the list of map
# files is not known when the Makefile starts - some new tags might be created
# when generating the .xml files in the news/* subdirectories.

.PHONY: tagmaps
all: tagmaps
tagmaps: $(SUBDIRS)
	@build/make_tagmaps.sh


# -----------------------------------------------------------------------------
# Touch .sources files for which the web pages must be rebuilt
# -----------------------------------------------------------------------------

# The .sources files in the tags directory are already handled by
# make_tagmaps.sh
SOURCES_FILES := $(shell find * -name '*.sources' -not -path 'tags/*')

# Secondary expansion means that the SOURCEDIRS and SOURCEREQS variables will
# be executed once for each target, and it allows us to use the variable $@
# within the expression.
.SECONDEXPANSION:

# This variable contains all the directories listed in the .sources file. It is
# added to the prerequisites so that the removal of a file from such a
# directory also triggers a rebuild of the web pages which have included the
# now removed file. However, we explicitly exclude "." (the root source
# directory) because that also contains a lot of other files.
SOURCES_DIRS = $(shell ls -d `sed -rn 's;^(.*/)[^/]*:(\[.*\])$$;\1;gp' $@` | grep -v '^\.$$')

# This variable contains all the actual .xml files covered by the .sources
# file. It obviously is a prerequisite because a page has to be rebuilt if any
# of the .xml files included into it has changed.
SOURCES_REQS = $(shell ./build/source_globber.sh sourceglobs $@ | sed 's;$$;.??.xml;g' )

# We simply touch the .sources file. The corresponding .xhtml files in all
# languages depend on the .sources file, so all languages will be rebuilt in
# the main build run.
all: $(SOURCES_FILES)
%.sources: $$(SOURCES_DIRS) $$(SOURCES_REQS) | tagmaps
	touch $@
