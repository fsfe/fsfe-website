sources := $(wildcard folder.??.xhtml) $(wildcard leaflet-*.??.xhtml)

#leafletsources := $(wildcard leaflet-*.??.xhtml)
leafletsources := $(wildcard leaflet-FTF-about.??.xhtml)

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
