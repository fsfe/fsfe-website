.PHONY: all

all: subdirs localmenus

# -----------------------------------------------------------------------------
# Dive into subdirectories
# -----------------------------------------------------------------------------

SUBDIRS := $(shell find */* -name "Makefile" | xargs --max-args=1 dirname)

.PHONY: subdirs $(SUBDIRS)

subdirs: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@

# -----------------------------------------------------------------------------
# Handle local menus
# -----------------------------------------------------------------------------

HELPERFILE := menuhelper
SELECT := '<localmenu.*</localmenu>'
STYLESHEET := ./tools/buildmenu.xsl 

FIND := ./\(.*\)/*\(.*\)\.\([a-z][a-z]\)\.xhtml:[ \t]*\(.*\)
REPLACE := <menuitem language="\3"><dir>/\1</dir><link>\2.html</link>\4</menuitem>

sources := $(shell grep -l -R --include='*.xhtml' $(SELECT) . )

.PHONY: localmenus

localmenus: localmenuinfo.en.xml

localmenuinfo.en.xml: $(sources) $(STYLESHEET)
	echo \<localmenuset\> > $(HELPERFILE)
	grep -R --include='*.xhtml' $(SELECT) .| sed -e 's,$(FIND),$(REPLACE),' >> $(HELPERFILE)
	echo \</localmenuset\> >> $(HELPERFILE)
	xsltproc -o $@ $(STYLESHEET) $(HELPERFILE) 
	rm $(HELPERFILE)
