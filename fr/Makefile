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

ECHO	 = echo
SSH	 = ssh

FSFFRANCE = http://france.fsfeurope.org
FSFEUROPE = http://www.fsfeurope.org
FSF       = http://www.fsf.org
GNU       = http://www.gnu.org

XSLTOPTS = \
	'$$fsfeurope=$(FSFEUROPE)' \
	'$$fsf=$(FSF)' \
	'$$gnu=$(GNU)'

ENPAGES = $(shell find * -regex '.*\.en\.xhtml' -print | sed "s/xhtml$$/html/")

FRPAGES = $(shell find * -regex '.*\.fr\.xhtml' -print | sed "s/xhtml$$/html/")

ITPAGES = $(shell find * -regex '.*\.it\.xhtml' -print | sed "s/xhtml$$/html/")

NEWS_COMPLETE = news/news-bytes.fr.xhtml news/news-bytes.en.xhtml
NEWS_LATEST = news/news-bytes-latest.fr.xhtml news/news-bytes-latest.en.xhtml
NEWS = $(NEWS_COMPLETE) $(NEWS_LATEST)

SCIENCE = science/documentation.fr.xhtml science/documentation.en.xhtml science/chimie.fr.xhtml science/chimie.en.xhtml science/biologie.fr.xhtml science/biologie.en.xhtml

all: news $(ENPAGES) $(FRPAGES) $(ITPAGES) science

news: $(NEWS)

science: $(SCIENCE)

donations/formulaire.fr.html: donations/formulaire.fr.xml
donations/*.fr.html: donations/menu.fr.xhtml

$(NEWS_COMPLETE): news/news-bytes.%.xhtml: news/fsfe-fr-channel.%.xml news/news.%.xsl
	@$(ECHO) "Building $@ ..."; \
	$(XSLTPROC) news/news.$*.xsl news/fsfe-fr-channel.$*.xml $(XSLTOPTS) '$$fsffrance=$(FSFFRANCE)' > news/news-bytes.$*.xhtml

$(NEWS_LATEST): news/news-bytes-latest.%.xhtml: news/fsfe-fr-channel.%.xml news/news-latest.%.xsl
	@$(ECHO) "Building $@ ..."; \
	$(XSLTPROC) news/news-latest.$*.xsl news/fsfe-fr-channel.$*.xml $(XSLTOPTS) '$$fsffrance=$(FSFFRANCE)' > news/news-bytes-latest.$*.xhtml

index.fr.html: news/news-bytes-latest.fr.xhtml
index.en.html: news/news-bytes-latest.en.xhtml

news/news.fr.html: news/fsfe-fr-channel.fr.xml
news/news.en.html: news/fsfe-fr-channel.en.xml

libre.fr.html: libre-bytes.xhtml
libre.en.html: libre-bytes.xhtml

server/wrap-sysadmin-france.en.html: server/wrap-sysadmin-france.en.xhtml server/sysadmin-france.en.texi
server/wrap-publish.en.html: server/wrap-publish.en.xhtml server/publish.en.texi

about/about.en.html about/about.fr.html about/organisation.fr.html about/reports.en.html about/signatures.html about/speakers.en.html about/speakers.fr.html about/statute.fr.html: about/menu.en.xhtml about/menu.fr.xhtml

science/chimie.en.xhtml: science/chimie.xml
	$(XSLTPROC) science/chimie.en.xsl science/chimie.xml >science/chimie.en.xhtml || rm -f science/chimie.en.xhtml

science/chimie.fr.xhtml: science/chimie.xml
	$(XSLTPROC) science/chimie.fr.xsl science/chimie.xml >science/chimie.fr.xhtml || rm -f science/chimie.fr.xhtml

science/documentation.en.xhtml: science/documentation.xml
	$(XSLTPROC) science/documentation.en.xsl science/documentation.xml >science/documentation.en.xhtml || rm -f science/documentation.en.xhtml

science/documentation.fr.xhtml: science/documentation.xml
	$(XSLTPROC) science/documentation.fr.xsl science/documentation.xml >science/documentation.fr.xhtml || rm -f science/documentation.fr.xhtml

science/biologie.en.xhtml: science/biologie.xml
	$(XSLTPROC) science/biologie.en.xsl science/biologie.xml >science/biologie.en.xhtml || rm -f science/biologie.en.xhtml

science/biologie.fr.xhtml: science/biologie.xml
	$(XSLTPROC) science/biologie.fr.xsl science/biologie.xml >science/biologie.fr.xhtml || rm -f science/biologie.fr.xhtml

$(ENPAGES): %.html: %.xhtml fsfe-fr.xsl navigation.en.xsl
	@$(ECHO) "Building $@ ..."; \
	path=$< ; \
	base=`expr $$path : '\(.*\).xhtml'` ; \
	filebase=`basename $$base` ; \
	dir=`dirname $$path` ; \
	root=`dirname $$path | perl -pe 'chop; s:([^/]+):..:g if($$_ ne ".")'` ; \
	$(XSLTPROC) fsfe-fr.xsl $$path $(XSLTOPTS) \
		'$$fsffrance='$$root '$$filebase='$$filebase '$$path='$$path | \
		perl -MFile::Copy -p -e '$$| = 1; copy("'$$dir'/$$1", \*STDOUT) if(/\#include virtual=\"(.*?)\"/); (s/Date://, s/Author:/by/, s/\$$//g) if(/\$$''Date:/); s/mode: xml \*\*\*/mode: html \*\*\*/' \
		> $$base.html

$(FRPAGES): %.html: %.xhtml fsfe-fr.xsl navigation.fr.xsl
	@$(ECHO) "Building $@ ..."; \
	path=$< ; \
	base=`expr $$path : '\(.*\).xhtml'` ; \
	filebase=`basename $$base` ; \
	dir=`dirname $$path` ; \
	root=`dirname $$path | perl -pe 'chop; s:([^/]+):..:g if($$_ ne ".")'` ; \
	$(XSLTPROC) fsfe-fr.xsl $$path $(XSLTOPTS) \
		'$$fsffrance='$$root '$$filebase='$$filebase '$$path='$$path | \
		perl -MFile::Copy -p -e '$$| = 1; copy("'$$dir'/$$1", \*STDOUT) if(/\#include virtual=\"(.*?)\"/); (s/Date://, s/Author:/par/, s/\$$//g) if(/\$$''Date:/); s/mode: xml \*\*\*/mode: html \*\*\*/' \
		> $$base.html

$(ITPAGES): %.html: %.xhtml fsfe-fr.xsl navigation.en.xsl
	@$(ECHO) "Building $@ ..."; \
	path=$< ; \
	base=`expr $$path : '\(.*\).xhtml'` ; \
	filebase=`basename $$base` ; \
	dir=`dirname $$path` ; \
	root=`dirname $$path | perl -pe 'chop; s:([^/]+):..:g if($$_ ne ".")'` ; \
	$(XSLTPROC) fsfe-fr.xsl $$path $(XSLTOPTS) \
		'$$fsffrance='$$root '$$filebase='$$filebase '$$path='$$path | \
		perl -MFile::Copy -p -e '$$| = 1; copy("'$$dir'/$$1", \*STDOUT) if(/\#include virtual=\"(.*?)\"/); (s/Date://, s/Author:/par/, s/\$$//g) if(/\$$''Date:/); s/mode: xml \*\*\*/mode: html \*\*\*/' \
		> $$base.html

# remove html files for which an xhtml version exists (exclude fr/)
clean:
	rm -f $(NEWS) $(ENPAGES) $(FRPAGES) $(ITPAGES)

sync:
	$(SSH) -l www france.fsfeurope.org 'cd fsfe/fr ; cvs -z3 -q update -I "*.html" -d ; ../../bin/nightly' 
