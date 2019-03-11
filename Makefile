# -----------------------------------------------------------------------------
# Makefile for "premake" step
# -----------------------------------------------------------------------------
# This Makefile creates some .xml and xhtml files which serve as source files
# in the main build run. It is executed in the source directory, before the
# Makefile for the main build run is constructed and executed.
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
# Generate XML filelists
# -----------------------------------------------------------------------------

# Generation of XML filelists is handled in an external script which generates
# all .xmllist and the tags/tagged-*.en.xhtml files. These files cannot be
# targets in this Makefile, because the list of tags is not known when the
# Makefile starts - some new tags might be created when generating the .xml
# files in the news/* subdirectories.

.PHONY: xmllists
all: xmllists
xmllists: $(SUBDIRS)
	@build/make_xmllists.sh
