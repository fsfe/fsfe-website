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

FSFFRANCE ?= http://france.fsfeurope.org
FSFEUROPE ?= http://www.fsfeurope.org 
FSF       ?= http://www.fsf.org
GNU       ?= http://www.gnu.org

XSLTOPTS = \
	'$$fsffrance=$(FSFFRANCE)' \
	'$$fsfeurope=$(FSFEUROPE)' \
	'$$fsf=$(FSF)' \
	'$$gnu=$(GNU)'

all:: process recurse

recurse:
	@dirs="$(SUBDIRS)" ; \
	if [ "$$dirs" ] ; then \
		for dir in $$dirs ; \
		do \
			( cd $$dir && $(MAKE) all ) ; \
		done ; \
	fi

process: $(HTML)

validate:
	for file in $(HTML:.html=.xhtml) ; \
	do \
		rxp -Vs $$file ; \
	done

$(HTML): %.html: %.xhtml $(FSFFRANCE)/navigation.*.xsl $(FSFFRANCE)/fsfe-fr.xsl 
	@if [ ! -f navigation.fr.xsl ] ; then ln -s $(FSFFRANCE)/navigation.*.xsl . ; fi
	$(XSLTPROC) $(FSFFRANCE)/fsfe-fr.xsl $< $@ $(XSLTOPTS) 
	perl -MFile::Copy -p -e '$$| = 1; copy("$$1", \*STDOUT) if(/\#include virtual=\"(.*?)\"/);' < $@ > $*.tmp && mv $*.tmp $@
	@-test -L navigation.fr.xsl && rm -f navigation.*.xsl $*.tmp || exit 0

.PHONY: process recurse

