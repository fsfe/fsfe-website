# Authors: Loic Dachary <loic@gnu.org> and Jaime Villate <villate@gnu.org>
#
# XML/XSLT processor (validator)
# -------------------------
#
# sablotron (sabcmd)
# apt-get install sablotron
#
# libxslt + libxml2 (xsltproc)
# http://www.xmlsoft.org/
#
# XML validator
# -------------
# apt-get install rxp
# or
# ftp://ftp.cogsci.ed.ac.uk/pub/richard/rxp-1.2.3.tar.gz
#

# branch tag name for the stable version of the site and only its patches
STABLEBRANCH = BS_20010825

XSLTPROC = sabcmd

FSFFRANCE = http://france.fsfeurope.org
FSFEUROPE = http://www.fsfeurope.org
FSF       = http://www.fsf.org
GNU       = http://www.gnu.org

ECHO	  = echo 
SSH	  = ssh

XSLTOPTS = \
	'$$fsffrance=$(FSFFRANCE)' \
	'$$fsf=$(FSF)' \
	'$$gnu=$(GNU)'

ENPAGESOLD = $(shell find * -path 'fr' -prune -o -regex '[^\.]*\.xhtml' -print | sed "s/xhtml$$/html/")

ENPAGES = $(shell find * -path 'fr' -prune -o -regex '.*\.en\.xhtml' -print | sed "s/xhtml$$/html/")

FRPAGES = $(shell find * -path 'fr' -prune -o -regex '.*\.fr\.xhtml' -print | sed "s/xhtml$$/html/")

DEPAGES = $(shell find * -path 'fr' -prune -o -regex '.*\.de\.xhtml' -print | sed "s/xhtml$$/html/")

PTPAGES = $(shell find * -path 'fr' -prune -o -regex '.*\.pt\.xhtml' -print | sed "s/xhtml$$/html/")

ITPAGES = $(shell find * -path 'fr' -prune -o -regex '.*\.it\.xhtml' -print | sed "s/xhtml$$/html/")

ESPAGES = $(shell find * -path 'fr' -prune -o -regex '.*\.es\.xhtml' -print | sed "s/xhtml$$/html/")

CSPAGES = $(shell find * -path 'fr' -prune -o -regex '.*\.cs\.xhtml' -print | sed "s/xhtml$$/html/")

LANGFILES = $(shell find * -path 'fr' -prune -o -regex '.*\.lang' -print)

# temporary, added by mad@april.org
NEWS = news/news.fr.html news/news.en.html news/news.pt.html

all: $(ENPAGESOLD) $(ENPAGES) $(FRPAGES) $(DEPAGES) $(PTPAGES) $(ITPAGES) $(ESPAGES) $(CSPAGES)

swpat/patents.en.html: swpat/patents-agenda.en.xml

$(ENPAGESOLD): %.html: %.xhtml fsfe.xsl navigation.en.xsl %.lang
	@$(ECHO) "Building $@ ..."; \
	path=$< ; \
	base=`expr $$path : '\(.*\).xhtml'` ; \
	filebase=`basename $$base` ; \
	dir=`dirname $$path` ; \
	root=`dirname $$path | perl -pe 'chop; s:([^/]+):..:g if($$_ ne ".")'` ; \
	langlinks="`./tools/translate.sh $$base en`" ; \
	$(XSLTPROC) fsfe.xsl $$path $(XSLTOPTS) '$$fsfeurope='$$root '$$filebase='$$filebase '$$path='$$path '$$langlinks='"$$langlinks" > $$base.html-temp && (cat $$base.html-temp | perl -p -e '$$| = 1; (s/Date://, s/Author:/by/, s/\$$//g) if(/\$$''Date:/); s/mode: xml \*\*\*/mode: html \*\*\*/' > $$base.html) ; \
	rm -f $$base.html-temp

$(ENPAGES): %.en.html: %.en.xhtml fsfe.xsl navigation.en.xsl %.lang
	@$(ECHO) "Building $@ ..."; \
	path=$< ; \
	base=`expr $$path : '\(.*\).en.xhtml'` ; \
	filebase=`basename $$base` ; \
	dir=`dirname $$path` ; \
	root=`dirname $$path | perl -pe 'chop; s:([^/]+):..:g if($$_ ne ".")'` ; \
	langlinks="`./tools/translate.sh $$base en`" ; \
	$(XSLTPROC) fsfe.xsl $$path $(XSLTOPTS) '$$fsfeurope='$$root '$$filebase='$$filebase.en '$$path='$$path '$$langlinks='"$$langlinks" > $$base.en.html-temp && (cat $$base.en.html-temp | perl -p -e '$$| = 1; (s/Date://, s/Author:/by/, s/\$$//g) if(/\$$''Date:/); s/mode: xml \*\*\*/mode: html \*\*\*/' > $$base.en.html) ; \
	rm -f $$base.en.html-temp

$(FRPAGES): %.fr.html: %.fr.xhtml fsfe.xsl navigation.fr.xsl %.lang
	@$(ECHO) "Building $@ ..."; \
	path=$< ; \
	base=`expr $$path : '\(.*\).fr.xhtml'` ; \
	filebase=`basename $$base` ; \
	dir=`dirname $$path` ; \
	root=`dirname $$path | perl -pe 'chop; s:([^/]+):..:g if($$_ ne ".")'` ; \
	langlinks="`./tools/translate.sh $$base fr`" ; \
	$(XSLTPROC) fsfe.xsl $$path $(XSLTOPTS) '$$fsfeurope='$$root '$$filebase='$$filebase.fr '$$path='$$path '$$langlinks='"$$langlinks" > $$base.fr.html-temp && (cat $$base.fr.html-temp | perl -p -e '$$| = 1; (s/Date://, s/Author:/par/, s/\$$//g) if(/\$$''Date:/); s/mode: xml \*\*\*/mode: html \*\*\*/' > $$base.fr.html) ; \
	rm -f $$base.fr.html-temp

$(DEPAGES): %.de.html: %.de.xhtml fsfe.xsl navigation.de.xsl %.lang
	@$(ECHO) "Building $@ ..."; \
	path=$< ; \
	base=`expr $$path : '\(.*\).de.xhtml'` ; \
	filebase=`basename $$base` ; \
	dir=`dirname $$path` ; \
	root=`dirname $$path | perl -pe 'chop; s:([^/]+):..:g if($$_ ne ".")'` ; \
	langlinks="`./tools/translate.sh $$base de`" ; \
	$(XSLTPROC) fsfe.xsl $$path $(XSLTOPTS) '$$fsfeurope='$$root '$$filebase='$$filebase.de '$$path='$$path '$$langlinks='"$$langlinks" > $$base.de.html-temp && (cat $$base.de.html-temp | perl -p -e '$$| = 1; (s/Date://, s/Author:/von/, s/\$$//g) if(/\$$''Date:/); s/mode: xml \*\*\*/mode: html \*\*\*/' > $$base.de.html) ; \
	rm -f $$base.de.html-temp

$(PTPAGES): %.pt.html: %.pt.xhtml fsfe.xsl navigation.pt.xsl %.lang
	@$(ECHO) "Building $@ ..."; \
	path=$< ; \
	base=`expr $$path : '\(.*\).pt.xhtml'` ; \
	filebase=`basename "$$base"` ; \
	dir=`dirname $$path` ; \
	root=`dirname $$path | perl -pe 'chop; s:([^/]+):..:g if($$_ ne ".")'` ; \
	langlinks="`./tools/translate.sh $$base pt`" ; \
	$(XSLTPROC) fsfe.xsl $$path $(XSLTOPTS) '$$fsfeurope='$$root '$$filebase='$$filebase.pt '$$path='$$path '$$langlinks='"$$langlinks" > $$base.pt.html-temp && (cat $$base.pt.html-temp | perl -p -e '$$| = 1; (s/Date://, s/Author:/por/, s/\$$//g) if(/\$$''Date:/); s/mode: xml \*\*\*/mode: html \*\*\*/' > $$base.pt.html) ; \
	rm -f $$base.pt.html-temp

$(ITPAGES): %.it.html: %.it.xhtml fsfe.xsl navigation.it.xsl %.lang
	@$(ECHO) "Building $@ ..."; \
	path=$< ; \
	base=`expr $$path : '\(.*\).it.xhtml'` ; \
	filebase=`basename $$base` ; \
	dir=`dirname $$path` ; \
	root=`dirname $$path | perl -pe 'chop; s:([^/]+):..:g if($$_ ne ".")'` ; \
	langlinks="`./tools/translate.sh $$base it`" ; \
	$(XSLTPROC) fsfe.xsl $$path $(XSLTOPTS) '$$fsfeurope='$$root '$$filebase='$$filebase.it '$$path='$$path '$$langlinks='"$$langlinks" > $$base.it.html-temp && (cat $$base.it.html-temp | perl -p -e '$$| = 1; (s/Date://, s/Author:/, da/, s/\$$//g) if(/\$$''Date:/); s/mode: xml \*\*\*/mode: html \*\*\*/' > $$base.it.html) ; \
	rm -f $$base.it.html-temp

$(ESPAGES): %.es.html: %.es.xhtml fsfe.xsl navigation.es.xsl %.lang
	@$(ECHO) "Building $@ ..."; \
	path=$< ; \
	base=`expr $$path : '\(.*\).es.xhtml'` ; \
	filebase=`basename $$base` ; \
	dir=`dirname $$path` ; \
	root=`dirname $$path | perl -pe 'chop; s:([^/]+):..:g if($$_ ne ".")'` ; \
	langlinks="`./tools/translate.sh $$base es`" ; \
	$(XSLTPROC) fsfe.xsl $$path $(XSLTOPTS) '$$fsfeurope='$$root '$$filebase='$$filebase.es '$$path='$$path '$$langlinks='"$$langlinks" > $$base.es.html-temp && (cat $$base.es.html-temp | perl -p -e '$$| = 1; (s/Date://, s/Author:/por/, s/\$$//g) if(/\$$''Date:/); s/mode: xml \*\*\*/mode: html \*\*\*/' > $$base.es.html) ; \
	rm -f $$base.es.html-temp

$(CSPAGES): %.cs.html: %.cs.xhtml fsfe.xsl navigation.cs.xsl %.lang
	@$(ECHO) "Building $@ ..."; \
	path=$< ; \
	base=`expr $$path : '\(.*\).cs.xhtml'` ; \
	filebase=`basename $$base` ; \
	dir=`dirname $$path` ; \
	root=`dirname $$path | perl -pe 'chop; s:([^/]+):..:g if($$_ ne ".")'` ;\
	langlinks="`./tools/translate.sh $$base cs`" ; \
	$(XSLTPROC) fsfe.xsl $$path $(XSLTOPTS) '$$fsfeurope='$$root '$$filebase='$$filebase.cs '$$path='$$path '$$langlinks='"$$langlinks" > $$base.cs.html-temp && (cat $$base.cs.html-temp | perl -p -e '$$| = 1; (s/Date://, s/Author:/od/, s/\$$//g) if(/\$$''Date:/); s/mode: xml \*\*\*/mode: html \*\*\*/' > $$base.cs.html) ; \
	rm -f $$base.cs.html-temp

%lang: 
	@$(ECHO) "Building $@ ..."; \
	path=$@ ; \
	base=`expr $$path : '\(.*\).lang'` ; \
	./tools/translate.sh $$base > /dev/null


# remove html files for which an xhtml version exists (exclude fr/)
clean:
	rm -f $(ENPAGES) $(FRPAGES) $(DEPAGES) $(PTPAGES) $(ITPAGES) $(ESPAGES) $(CSPAGES) $(LANGFILES)

sync:
	$(SSH) -l www france.fsfeurope.org 'cd fsfe ; cvs -z3 -q update -I "*.html" -d ; ../bin/nightly'

#
# Attempt to install a beta web site (talk to oberger@gnu.org + greve@gnu.org)
#
syncall:
	@echo "Updating stable version : $(STABLEBRANCH)"
	$(MAKE) sync
	$(SSH) -l www france.fsfeurope.org 'cd fsfe/server/testbeta ; cvs -z3 -q update -I "*.html" -d -r $(STABLEBRANCH) ; ../../../bin/nightly'
	@echo "Updating beta version :"
	$(SSH) -l www france.fsfeurope.org 'cd fsfe/server/test/fsfe/server/testbeta ; cvs -z3 -q update -I "*.html" -d -A ; ../../../../../../bin/nightly'
