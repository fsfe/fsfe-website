# Copyright (C) 2001 Loic Dachary <loic@gnu.org>
# Copyright (C) 2001 Jaime Villate <villate@gnu.org>
# Copyright (C) 2002 Rodolphe Quiedeville <rodolphe@quiedeville.org>
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

XSLTOPTS = \
	'$$gnu=$(GNU)'

ENPAGES = $(shell find * -regex '.*\.en\.xhtml' -print | sed "s/xhtml$$/php/")

FRPAGES = $(shell find * -regex '.*\.fr\.xhtml' -print | sed "s/xhtml$$/php/")


RSYNC=/usr/bin/rsync
ROPT=-av
RSSH=-e ssh

all: $(ENPAGES) $(FRPAGES)


$(ENPAGES) $(FRPAGES): %.php: %.xhtml fsfe-fr.xsl navigation.en.xsl navigation.fr.xsl
	@echo "Building $@ ..."; \
	path=$< ; \
	base=`expr $$path : '\(.*\).xhtml'` ; \
	filebase=`basename $$base` ; \
	dir=`dirname $$path` ; \
	root=`dirname $$path | perl -pe 'chop; s:([^/]+):..:g if($$_ ne ".")'` ; \
	$(XSLTPROC) fsfe-fr.xsl $$path $(XSLTOPTS) \
		'$$fsffrance='$$root '$$filebase='$$filebase '$$path='$$path | \
		perl -MFile::Copy -p -e '$$| = 1; copy("'$$dir'/$$1", \*STDOUT) if(/\#include virtual=\"(.*?)\"/); s/\$$//g if(/\$$''Date:/);' \
		> $$base.php-temp && \
		( cat $$base.php-temp | \
		  perl -p -e '$$| = 1; s/\$$//g if(/\$$''Date:/); s/mode: xml \*\*\*/mode: html \*\*\*/' > $$base.php \
		) ; \
	rm -f $$base.html $$base.php-temp; \
	ln -s $$base.php $$base.html

# remove html files for which an xhtml version exists (exclude fr/)
clean:
	rm -f $(ENPAGES) $(FRPAGES)

