sources := $(wildcard folder.??.xhtml) $(wildcard leaflet-*.??.xhtml)

#leafletsources := $(wildcard leaflet-*.??.xhtml)
allleafletsources := $(wildcard leaflet-FTF-about.??.xhtml)
# Sorry, no support for other character sets than Latin-1 yet
leafletsources := $(filter-out %.el.xhtml,$(allleafletsources))

pdfs_0 := $(leafletsources:.xhtml=.0.pdf)
pdfs_G := $(leafletsources:.xhtml=.G.pdf)

# FIXME: How can we cause the rebuild to be run also when a file is deleted?

.PHONY: all

all: leaflets.en.xml $(pdfs_0) $(pdfs_G)

leaflets.en.xml: $(sources) mk-leaflets-en-xml.sh
	/bin/bash mk-leaflets-en-xml.sh $(sources)

%.0.pdf: %.xhtml mk-tex.xsl
	xsltproc mk-tex.xsl $< > $*.0.tex
	pdflatex -interaction=nonstopmode $*.0.tex || exit 0
	rm --firm $*.tex $*.log $*.aux

%.G.pdf: %.xhtml mk-tex.xsl
	xsltproc mk-tex.xsl $< > $*.G.tex
	pdflatex -interaction=nonstopmode $*.G.tex || exit 0
	rm --firm $*.tex $*.log $*.aux
