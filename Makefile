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
XSLTPROC = sabcmd

FSFFRANCE = http://france.fsfeurope.org
FSFEUROPE = http://www.fsfeurope.org
FSF       = http://www.fsf.org
GNU       = http://www.gnu.org

XSLTOPTS = \
	'$$fsffrance=$(FSFFRANCE)' \
	'$$fsf=$(FSF)' \
	'$$gnu=$(GNU)'

ENPAGES = $(shell find * -path 'fr' -prune -o \( -regex '.*\.en\.xhtml' -o -regex '[^\.]*\.xhtml' \) -print | sed "s/xhtml$$/html/")

FRPAGES = $(shell find * -path 'fr' -prune -o -regex '.*\.fr\.xhtml' -print | sed "s/xhtml$$/html/")

DEPAGES = $(shell find * -path 'fr' -prune -o -regex '.*\.de\.xhtml' -print | sed "s/xhtml$$/html/")

PTPAGES = $(shell find * -path 'fr' -prune -o -regex '.*\.pt\.xhtml' -print | sed "s/xhtml$$/html/")

all: $(ENPAGES) $(FRPAGES) $(DEPAGES) $(PTPAGES)

swpat/patents.en.html: swpat/patents-agenda.en.xml

$(ENPAGES): %.html: %.xhtml fsfe.xsl navigation.en.xsl
	@echo "Building $@ ..."; \
	path=$< ; \
	base=`expr $$path : '\(.*\).xhtml'` ; \
	filebase=`basename $$base` ; \
	dir=`dirname $$path` ; \
	root=`dirname $$path | perl -pe 'chop; s:([^/]+):..:g if($$_ ne ".")'` ; \
	$(XSLTPROC) fsfe.xsl $$path $(XSLTOPTS) '$$fsfeurope='$$root '$$filebase='$$filebase '$$path='$$path > $$base.html-temp && (cat $$base.html-temp | perl -p -e '$$| = 1; s/\$$//g if(/\$$''Date:/); s/mode: xml \*\*\*/mode: html \*\*\*/' > $$base.html) ; \
	rm -f $$base.html-temp

$(FRPAGES): %.html: %.xhtml fsfe.xsl navigation.fr.xsl
	@echo "Building $@ ..."; \
	path=$< ; \
	base=`expr $$path : '\(.*\).xhtml'` ; \
	filebase=`basename $$base` ; \
	dir=`dirname $$path` ; \
	root=`dirname $$path | perl -pe 'chop; s:([^/]+):..:g if($$_ ne ".")'` ; \
	$(XSLTPROC) fsfe.xsl $$path $(XSLTOPTS) '$$fsfeurope='$$root '$$filebase='$$filebase '$$path='$$path > $$base.html-temp && (cat $$base.html-temp | perl -p -e '$$| = 1; s/\$$//g if(/\$$''Date:/); s/mode: xml \*\*\*/mode: html \*\*\*/' > $$base.html) ; \
	rm -f $$base.html-temp

$(DEPAGES): %.html: %.xhtml fsfe.xsl navigation.de.xsl
	@echo "Building $@ ..."; \
	path=$< ; \
	base=`expr $$path : '\(.*\).xhtml'` ; \
	filebase=`basename $$base` ; \
	dir=`dirname $$path` ; \
	root=`dirname $$path | perl -pe 'chop; s:([^/]+):..:g if($$_ ne ".")'` ; \
	$(XSLTPROC) fsfe.xsl $$path $(XSLTOPTS) '$$fsfeurope='$$root '$$filebase='$$filebase '$$path='$$path > $$base.html-temp && (cat $$base.html-temp | perl -p -e '$$| = 1; s/\$$//g if(/\$$''Date:/); s/mode: xml \*\*\*/mode: html \*\*\*/' > $$base.html) ; \
	rm -f $$base.html-temp

$(PTPAGES): %.html: %.xhtml fsfe.xsl navigation.pt.xsl
	@echo "Building $@ ..."; \
	path=$< ; \
	base=`expr $$path : '\(.*\).xhtml'` ; \
	filebase=`basename $$base` ; \
	dir=`dirname $$path` ; \
	root=`dirname $$path | perl -pe 'chop; s:([^/]+):..:g if($$_ ne ".")'` ; \
	$(XSLTPROC) fsfe.xsl $$path $(XSLTOPTS) '$$fsfeurope='$$root '$$filebase='$$filebase '$$path='$$path > $$base.html-temp && (cat $$base.html-temp | perl -p -e '$$| = 1; s/\$$//g if(/\$$''Date:/); s/mode: xml \*\*\*/mode: html \*\*\*/' > $$base.html) ; \
	rm -f $$base.html-temp

# remove html files for which an xhtml version exists (exclude fr/)
clean:
	rm -f $(ENPAGES) $(FRPAGES) $(DEPAGES) $(PTPAGES)

