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

$(NEWS_COMPLETE): news/news-bytes.%.xhtml: news/fsfe-fr-channel.%.xml news/news.%.xsl
	@echo "Building $@ ..."; \
	$(XSLTPROC) news/news.$*.xsl news/fsfe-fr-channel.$*.xml $(XSLTOPTS) '$$fsffrance=$(FSFFRANCE)' > news/news-bytes.$*.xhtml

$(NEWS_LATEST): news/news-bytes-latest.%.xhtml: news/fsfe-fr-channel.%.xml news/news-latest.%.xsl
	@echo "Building $@ ..."; \
	$(XSLTPROC) news/news-latest.$*.xsl news/fsfe-fr-channel.$*.xml $(XSLTOPTS) '$$fsffrance=$(FSFFRANCE)' > news/news-bytes-latest.$*.xhtml

index.fr.html: news/news-bytes-latest.fr.xhtml
index.en.html: news/news-bytes-latest.en.xhtml

news/news.fr.html: news/fsfe-fr-channel.fr.xml
news/news.en.html: news/fsfe-fr-channel.en.xml

libre.fr.html: libre-bytes.xhtml
libre.en.html: libre-bytes.xhtml

server/server.en.html: server/server.en.xhtml server/sysadmin-france.en.texi

$(ENPAGES) $(FRPAGES): %.html: %.xhtml fsfe-fr.xsl navigation.en.xsl navigation.fr.xsl
	@echo "Building $@ ..."; \
	path=$< ; \
	base=`expr $$path : '\(.*\).xhtml'` ; \
	filebase=`basename $$base` ; \
	dir=`dirname $$path` ; \
	root=`dirname $$path | perl -pe 'chop; s:([^/]+):..:g if($$_ ne ".")'` ; \
	$(XSLTPROC) fsfe-fr.xsl $$path $(XSLTOPTS) \
		'$$fsffrance='$$root '$$filebase='$$filebase '$$path='$$path | \
		perl -MFile::Copy -p -e '$$| = 1; copy("'$$dir'/$$1", \*STDOUT) if(/\#include virtual=\"(.*?)\"/); s/\$$//g if(/\$$''Date:/);' \
		> $$base.html-temp && \
		( cat $$base.html-temp | \
		  perl -p -e '$$| = 1; s/\$$//g if(/\$$''Date:/); s/mode: xml \*\*\*/mode: html \*\*\*/' > $$base.html \
		) ; \
	rm -f $$base.html-temp

# remove html files for which an xhtml version exists (exclude fr/)
clean:
	rm -f $(NEWS) $(ENPAGES) $(FRPAGES)

sync:
	ssh -l www france.fsfeurope.org 'cd fsfe ; cvs -z3 -q update -I "*.html" -d ; ../bin/nightly' 
