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

ENPAGES = $(shell find * -path 'fr' -prune -o \( -regex '.*\.en\.xhtml' -o -regex '[^\.]*\.xhtml' \) -print | sed "s/xhtml$$/html/")

FRPAGES = $(shell find * -path 'fr' -prune -o -regex '.*\.fr\.xhtml' -print | sed "s/xhtml$$/html/")

DEPAGES = $(shell find * -path 'fr' -prune -o -regex '.*\.de\.xhtml' -print | sed "s/xhtml$$/html/")

PTPAGES = $(shell find * -path 'fr' -prune -o -regex '.*\.pt\.xhtml' -print | sed "s/xhtml$$/html/")

ITPAGES = $(shell find * -path 'fr' -prune -o -regex '.*\.it\.xhtml' -print | sed "s/xhtml$$/html/")

ESPAGES = $(shell find * -path 'fr' -prune -o -regex '.*\.es\.xhtml' -print | sed "s/xhtml$$/html/")

# temporary, added by mad@april.org
NEWS = news/news.fr.html news/news.en.html news/news.pt.html

all: $(ENPAGES) $(FRPAGES) $(DEPAGES) $(PTPAGES) $(ITPAGES) $(ESPAGES)

swpat/patents.en.html: swpat/patents-agenda.en.xml

$(ENPAGES): %.html: %.xhtml fsfe.xsl navigation.en.xsl
	@$(ECHO) "Building $@ ..."; \
	path=$< ; \
	base=`expr $$path : '\(.*\).xhtml'` ; \
	filebase=`basename $$base` ; \
	dir=`dirname $$path` ; \
	root=`dirname $$path | perl -pe 'chop; s:([^/]+):..:g if($$_ ne ".")'` ; \
	$(XSLTPROC) fsfe.xsl $$path $(XSLTOPTS) '$$fsfeurope='$$root '$$filebase='$$filebase '$$path='$$path > $$base.html-temp && (cat $$base.html-temp | perl -p -e '$$| = 1; (s/Date://, s/Author:/by/, s/\$$//g) if(/\$$''Date:/); s/mode: xml \*\*\*/mode: html \*\*\*/' > $$base.html) ; \
	rm -f $$base.html-temp

$(FRPAGES): %.html: %.xhtml fsfe.xsl navigation.fr.xsl
	@$(ECHO) "Building $@ ..."; \
	path=$< ; \
	base=`expr $$path : '\(.*\).xhtml'` ; \
	filebase=`basename $$base` ; \
	dir=`dirname $$path` ; \
	root=`dirname $$path | perl -pe 'chop; s:([^/]+):..:g if($$_ ne ".")'` ; \
	$(XSLTPROC) fsfe.xsl $$path $(XSLTOPTS) '$$fsfeurope='$$root '$$filebase='$$filebase '$$path='$$path > $$base.html-temp && (cat $$base.html-temp | perl -p -e '$$| = 1; (s/Date://, s/Author:/par/, s/\$$//g) if(/\$$''Date:/); s/mode: xml \*\*\*/mode: html \*\*\*/' > $$base.html) ; \
	rm -f $$base.html-temp

$(DEPAGES): %.html: %.xhtml fsfe.xsl navigation.de.xsl
	@$(ECHO) "Building $@ ..."; \
	path=$< ; \
	base=`expr $$path : '\(.*\).xhtml'` ; \
	filebase=`basename $$base` ; \
	dir=`dirname $$path` ; \
	root=`dirname $$path | perl -pe 'chop; s:([^/]+):..:g if($$_ ne ".")'` ; \
	$(XSLTPROC) fsfe.xsl $$path $(XSLTOPTS) '$$fsfeurope='$$root '$$filebase='$$filebase '$$path='$$path > $$base.html-temp && (cat $$base.html-temp | perl -p -e '$$| = 1; (s/Date://, s/Author:/von/, s/\$$//g) if(/\$$''Date:/); s/mode: xml \*\*\*/mode: html \*\*\*/' > $$base.html) ; \
	rm -f $$base.html-temp

$(PTPAGES): %.html: %.xhtml fsfe.xsl navigation.pt.xsl tools/translate.sh
	@$(ECHO) "Building $@ ..."; \
	path=$< ; \
	base=`expr $$path : '\(.*\).pt.xhtml'` ; \
	filebase=`basename "$$base"` ; \
	dir=`dirname $$path` ; \
	root=`dirname $$path | perl -pe 'chop; s:([^/]+):..:g if($$_ ne ".")'` ; \
	langlinks="`./tools/translate.sh $$base pt`" ; \
	$(XSLTPROC) fsfe.xsl $$path $(XSLTOPTS) '$$fsfeurope='$$root '$$filebase='$$filebase.pt '$$path='$$path '$$langlinks='"$$langlinks" > $$base.pt.html-temp && (cat $$base.pt.html-temp | perl -p -e '$$| = 1; (s/Date://, s/Author:/por/, s/\$$//g) if(/\$$''Date:/); s/mode: xml \*\*\*/mode: html \*\*\*/' > $$base.pt.html) ; \
	rm -f $$base.pt.html-temp

$(ITPAGES): %.html: %.xhtml fsfe.xsl navigation.it.xsl
	@$(ECHO) "Building $@ ..."; \
	path=$< ; \
	base=`expr $$path : '\(.*\).xhtml'` ; \
	filebase=`basename $$base` ; \
	dir=`dirname $$path` ; \
	root=`dirname $$path | perl -pe 'chop; s:([^/]+):..:g if($$_ ne ".")'` ; \
	$(XSLTPROC) fsfe.xsl $$path $(XSLTOPTS) '$$fsfeurope='$$root '$$filebase='$$filebase '$$path='$$path > $$base.html-temp && (cat $$base.html-temp | perl -p -e '$$| = 1; (s/Date://, s/Author:/, da/, s/\$$//g) if(/\$$''Date:/); s/mode: xml \*\*\*/mode: html \*\*\*/' > $$base.html) ; \
	rm -f $$base.html-temp

$(ESPAGES): %.html: %.xhtml fsfe.xsl navigation.es.xsl
	@$(ECHO) "Building $@ ..."; \
	path=$< ; \
	base=`expr $$path : '\(.*\).xhtml'` ; \
	filebase=`basename $$base` ; \
	dir=`dirname $$path` ; \
	root=`dirname $$path | perl -pe 'chop; s:([^/]+):..:g if($$_ ne ".")'` ; \
	$(XSLTPROC) fsfe.xsl $$path $(XSLTOPTS) '$$fsfeurope='$$root '$$filebase='$$filebase '$$path='$$path > $$base.html-temp && (cat $$base.html-temp | perl -p -e '$$| = 1; (s/Date://, s/Author:/por/, s/\$$//g) if(/\$$''Date:/); s/mode: xml \*\*\*/mode: html \*\*\*/' > $$base.html) ; \
	rm -f $$base.html-temp

# remove html files for which an xhtml version exists (exclude fr/)
clean:
	rm -f $(ENPAGES) $(FRPAGES) $(DEPAGES) $(PTPAGES) $(ITPAGES) $(ESPAGES)

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
