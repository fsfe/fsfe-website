sources := $(wildcard folder.??.xhtml) $(wildcard leaflet-*.??.xhtml)

#leafletsources := $(wildcard leaflet-*.??.xhtml)
allleafletsources := $(wildcard leaflet-FTF-about.??.xhtml)
# Sorry, no support for other character sets than Latin-1 yet
leafletsources := $(filter-out %.el.xhtml,$(allleafletsources))

pdfs := $(leafletsources:.xhtml=.pdf)

# FIXME: How can we cause the rebuild to be run also when a file is deleted?

.PHONY: all

all: leaflets.en.xml $(pdfs)

leaflets.en.xml: $(sources) mk-leaflets-en-xml.sh
	/bin/bash mk-leaflets-en-xml.sh $(sources)

%.pdf: %.xhtml mk-tex.xsl
	xsltproc mk-tex.xsl $< > $*.tex
	pdflatex -interaction=nonstopmode $*.tex || exit 0
	rm $*.tex $*.log $*.aux
