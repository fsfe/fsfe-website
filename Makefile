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

FSFFRANCE = http://france.fsfeurope.org
FSFEUROPE = . # http://www.fsfeurope.org
FSF       = http://www.fsf.org
GNU       = http://www.gnu.org

XSLTOPTS = \
	'$$fsffrance=$(FSFFRANCE)' \
	'$$fsf=$(FSF)' \
	'$$gnu=$(GNU)'

all:: process 

# process xhtml files in all subdirectories, except fr/
process: 
	@find * -path 'fr' -prune -o -name '*.xhtml' -print | while read path ; \
	do \
		base=`expr $$path : '\(.*\).xhtml'` ; \
		filebase=`basename $$base` ; \
		dir=`dirname $$path` ; \
		root=`dirname $$path | perl -pe 'chop; s:([^/]+):..:g if($$_ ne ".")'` ; \
		$(XSLTPROC) fsfe.xsl $$path $(XSLTOPTS) '$$fsfeurope='$$root '$$filebase='$$filebase | \
		perl -MFile::Copy -p -e '$$| = 1; copy("'$$dir'/$$1", \*STDOUT) if(/\#include virtual=\"(.*?)\"/); s/\$$//g if(/\$$''Date:/);' > $$base.html ; \
	done

# validate xhtml files in all subdirectories, except fr/
validate:
	find . -path './fr' -prune -o -name '*.xhtml' -print | while read file ; \
	do \
		echo $$file ; \
		rxp -Vs $$file ; \
	done

.PHONY: process recurse
