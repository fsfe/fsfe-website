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

NEWS_COMPLETE = news/news-bytes.fr.xhtml news/news-bytes.en.xhtml
NEWS_LATEST = news/news-bytes-latest.fr.xhtml news/news-bytes-latest.en.xhtml
NEWS = $(NEWS_COMPLETE) $(NEWS_LATEST)

all: news $(ENPAGES) $(FRPAGES) 

news: $(NEWS)

donations/formulaire.fr.html: donations/formulaire.fr.xml

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

server/server.en.html: server/server.en.xhtml server/sysadmin-france.en.texi

about/about.en.html about/about.fr.html about/organisation.fr.html about/reports.en.html about/signatures.html about/speakers.en.html about/speakers.fr.html about/statute.fr.html: about/menu.en.xhtml about/menu.fr.xhtml

science/chimie.en.xhtml: science/chimie.xml
	$(XSLTPROC) science/chimie.en.xsl science/chimie.xml >science/chimie.en.xhtml || rm -f science/chimie.en.xhtml

science/chimie.fr.xhtml: science/chimie.xml
	$(XSLTPROC) science/chimie.fr.xsl science/chimie.xml >science/chimie.fr.xhtml || rm -f science/chimie.fr.xhtml

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

# remove html files for which an xhtml version exists (exclude fr/)
clean:
	rm -f $(NEWS) $(ENPAGES) $(FRPAGES)

sync:
	$(SSH) -l www france.fsfeurope.org 'cd fsfe ; cvs -z3 -q update -I "*.html" -d ; ../bin/nightly' 
