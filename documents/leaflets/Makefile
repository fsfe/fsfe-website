sources := $(wildcard folder.??.xhtml) $(wildcard leaflet-*.??.xhtml)

# FIXME: Sorry, no support for other character sets than Latin-1 yet
leafletsources := $(filter-out %.el.xhtml,$(sources))

pdfs_0 := $(leafletsources:.xhtml=.0.pdf)
pdfs_G := $(leafletsources:.xhtml=.G.pdf)

# FIXME: How can we cause the rebuild to be run also when a file is deleted?

.PHONY: all

all: leaflets.en.xml $(pdfs_0) $(pdfs_G)

leaflets.en.xml: $(sources) mk-leaflets-en-xml.sh
	/bin/bash mk-leaflets-en-xml.sh $(sources)

%.0.pdf: %.xhtml mk-tex-a4.xsl
	xsltproc --stringparam language $(subst .,,$(suffix $*)) --stringparam style 0 mk-tex-a4.xsl $< | sed -e 's/ /~/' > $*.0.tex
	pdflatex -interaction=nonstopmode $*.0.tex || exit 0
	rm --force $*.0.tex $*.0.log $*.0.aux

%.G.pdf: %.xhtml mk-tex-a4.xsl
	xsltproc --stringparam language $(subst .,,$(suffix $*)) --stringparam style G mk-tex-a4.xsl $< | sed -e 's/ /~/' > $*.G.tex
	pdflatex -interaction=nonstopmode $*.G.tex || exit 0
	rm --force $*.G.tex $*.G.log $*.G.aux
