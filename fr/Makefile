#
# XML validator
# -------------
# apt-get install rxp
# or
# ftp://ftp.cogsci.ed.ac.uk/pub/richard/rxp-1.2.3.tar.gz
#
# XSLT processor
# --------------
#
# sablotron (sabcmd)
# apt-get install sablotron
#
# libxslt + libxml2 (xsltproc)
# http://www.xmlsoft.org/
#
XSLTPROC = sabcmd

FSFFRANCE = . # http://france.fsfeurope.org
FSFEUROPE = http://www.fsfeurope.org
FSF       = http://www.fsf.org
GNU       = http://www.gnu.org

XSLTOPTS = \
	'$$fsfeurope=$(FSFEUROPE)' \
	'$$fsf=$(FSF)' \
	'$$gnu=$(GNU)'

all:: process 

clean:
	find . -name '*.html' -print | xargs rm 

process: 
	@find * -name '*.xhtml' -print | while read path ; \
	do \
		base=`expr $$path : '\(.*\).xhtml'` ; \
		filebase=`basename $$base` ; \
		dir=`dirname $$path` ; \
		root=`dirname $$path | perl -pe 'chop; s:([^/]+):..:g if($$_ ne ".")'` ; \
		$(XSLTPROC) fsfe-fr.xsl $$path $(XSLTOPTS) '$$fsffrance='$$root '$$filebase='$$filebase | \
		perl -MFile::Copy -p -e '$$| = 1; copy("'$$dir'/$$1", \*STDOUT) if(/\#include virtual=\"(.*?)\"/); s/\$$//g if(/\$$''Date:/);' > $$base.html ; \
	done

news: 
	$(XSLTPROC) news/news.fr.xsl news/fsfe-fr-channel.xml $(XSLTOPTS) '$$fsffrance='$$root '$$filebase='$$filebase > news/news-bytes.fr.xhtml

validate:
	find . -name '*.xhtml' -print | while read file ; \
	do \
		echo $$file ; \
		rxp -Vs $$file ; \
	done

.PHONY: process recurse news
