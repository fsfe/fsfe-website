.PHONY: all .FORCE
.FORCE:
all:

# -----------------------------------------------------------------------------
# Dive into subdirectories
# -----------------------------------------------------------------------------

SUBDIRS := $(shell find */* -name "Makefile" | xargs dirname)

$(SUBDIRS): .FORCE
	$(MAKE) -j -k -C $@ || true

all: $(SUBDIRS)

# -----------------------------------------------------------------------------
# Handle local menus
# -----------------------------------------------------------------------------

MENUSOURCES := $(shell find -name '*.xhtml' |xargs grep -l '<localmenu.*</localmenu>' )

localmenuinfo.en.xml: ./tools/buildmenu.xsl $(MENUSOURCES)
	{ printf '<localmenuset>'; \
	  grep -E '<localmenu.*</localmenu>' $^ \
          | sed -r 's;(.*/)?(.+)\.([a-z][a-z])\.xhtml:(.+);\
                    <menuitem language="\3"><dir>/\1</dir><link>\2.html</link>\4</menuitem>;'; \
	  printf '</localmenuset>'; \
	} | xsltproc -o $@ $< -

all: localmenuinfo.en.xml

# -----------------------------------------------------------------------------
# Timestamp files for regular jobs and XML inclusion in various places
# -----------------------------------------------------------------------------

YEAR  := <?xml version="1.0" encoding="utf-8"?><dateset><date year="$(shell date +%Y)" /></dateset> 
MONTH := <?xml version="1.0" encoding="utf-8"?><dateset><date month="$(shell date +%Y-%m)" /></dateset> 
DAY   := <?xml version="1.0" encoding="utf-8"?><dateset><date day="$(shell date +%Y-%m-%d)" /></dateset>

d_day.en.xml: $(if $(findstring   $(DAY),$(shell cat d_day.en.xml)),,.FORCE)
	printf %s\\n   '$(DAY)' >$@
d_month.en.xml: $(if $(findstring $(MONTH),$(shell cat d_month.en.xml)),,.FORCE)
	printf %s\\n '$(MONTH)' >$@
d_year.en.xml: $(if $(findstring  $(YEAR),$(shell cat d_year.en.xml)),,.FORCE)
	printf %s\\n  '$(YEAR)' >$@

all: d_year.en.xml d_month.en.xml d_day.en.xml

# -----------------------------------------------------------------------------
# Update .sources files
# -----------------------------------------------------------------------------

# use shell globbing to work around faulty globbing in gnu make
SOURCEDIRS = $(shell ls -d `sed -rn 's;^(.*/)[^/]*:(\[.*\])$$;\1;gp' $@`)
SOURCEREQS = $(shell ./build/source_globber.sh sourceglobs $@ |sed 's;$$;.??.xml;g' )

all: $(shell find ./ -name '*.sources')

# -----------------------------------------------------------------------------
# generate tag maps
# -----------------------------------------------------------------------------

# We only have to look at the English files; all translations will have the
# same tags. This speeds up the process and brings the list below the length
# limit for a command line (for now).
TAGMAP := $(shell find ./ -name '*.en.xml' \
             | xargs ./build/source_globber.sh map_tags \
             | sed -r "s;';'\'';g; s;[^ ]+;'&';g;" \
            )

TAGNAMES := $(shell printf '%s\n' $(TAGMAP) \
              | sed '/\...\.xml$$/d' \
              | grep -vE '[\$%/:()]' \
              | sort -u \
             )

MAPNAMES := $(shell printf 'tools/tagmaps/%s.map ' $(TAGNAMES))
INDEXNAMES := $(shell printf 'tags/tagged-%s.en.xhtml ' $(TAGNAMES))
INDEXSOURCES := $(shell printf 'tags/tagged-%s.sources ' $(TAGNAMES))

all: $(INDEXNAMES)
tags/tagged-%.en.xhtml: tags/tagged.en.xhtml
	cp $< $@

# We update a tagmap whenever any of the XML files mentioned therein *or* a
# translation of such an XML file changes. Following that, the matching
# .sources file is also updated, which causes a rebuild of the taglist page.
all: $(INDEXSOURCES)
tags/tagged-%.sources: tools/tagmaps/%.map
	printf '%s:[$*]\n' 'news/*/news' news/generated_xml/ news/nl/nl 'events/*/event' >$@
	printf 'd_day:[]' >>$@

MAPREQS = $(shell printf '%s ' $(TAGMAP) \
            | sed -r 's;[^ ]+\...\.xml;\n&;g' \
            | grep ' $*' \
            | cut -d' ' -f1 \
            | sed -r 's;\.en\.xml;.??.xml;' \
           )

all: $(MAPNAMES)

# -----------------------------------------------------------------------------
# Second Expansion rules
# -----------------------------------------------------------------------------
.SECONDEXPANSION:

%.sources: $$(SOURCEDIRS) $$(SOURCEREQS) | $(MAPNAMES) $(INDEXSOURCES)
	touch $@

tools/tagmaps/%.map: $$(MAPREQS) | $(SUBDIRS)
	printf '%s\n' $^ > $@
