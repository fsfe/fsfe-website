.PHONY: all

all: subdirs localmenus date_today

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

FIND := ./\(.*/\)*\(.*\)\.\([a-z][a-z]\)\.xhtml:[ \t]*\(.*\)
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

YEAR := <?xml version="1.0" encoding="utf-8"?><dateset><date year="$(shell date +%Y)" /></dateset> 
MONTH := <?xml version="1.0" encoding="utf-8"?><dateset><date month="$(shell date +%Y-%m)" /></dateset> 
DAY := <?xml version="1.0" encoding="utf-8"?><dateset><date day="$(shell date +%Y-%m-%d)" /></dateset> 

.PHONY: date_today
date_today: d_year.en.xml d_month.en.xml d_day.en.xml

d_year.en.xml:
	grep -q '$(YEAR)' $@ || echo '$(YEAR)' >$@
d_month.en.xml:
	grep -q '$(MONTH)' $@ || echo '$(MONTH)' >$@
d_day.en.xml:
	grep -q '$(DAY)' $@ || echo '$(DAY)' >$@
