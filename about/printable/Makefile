foldersources := $(wildcard folder.??.xhtml)
leafletsources := $(wildcard folder.??.xhtml) $(wildcard ../../activities/*/leaflet-*.??.xhtml) $(wildcard ../../activities/*/*/leaflet-*.??.xhtml) $(wildcard ../../campaigns/swpat/leaflet-*.??.xhtml) $(wildcard ../../campaigns/pdfreaders/leaflet-*.??.xhtml)

pdfs_F := $(foldersources:.xhtml=.F.pdf)
pdfs_G := $(leafletsources:.xhtml=.G.pdf)
pdfs_0 := $(leafletsources:.xhtml=.0.pdf)

# FIXME: How can we cause the rebuild to be run also when a file is deleted?

.PHONY: all

all: printable.en.xml $(pdfs_F) $(pdfs_G) $(pdfs_0)

printable.en.xml: $(leafletsources) mk-printable-en-xml.sh get_h1.xsl get_moreinfo.xsl
	/bin/bash mk-printable-en-xml.sh $(leafletsources)

%.F.pdf: %.xhtml mk-tex-a3.xsl
	xsltproc --stringparam language $(subst .,,$(suffix $*)) mk-tex-a3.xsl $< | sed -e 's/ /~/' > $*.F.tex
	pdflatex -interaction=nonstopmode -output-directory $(*D) $*.F.tex || exit 0
	rm --force $*.F.tex $*.F.log $*.F.aux

%.G.pdf: %.xhtml mk-tex-a4.xsl
	xsltproc --stringparam language $(subst .,,$(suffix $*)) --stringparam style G mk-tex-a4.xsl $< | sed -e 's/ /~/' > $*.G.tex
	pdflatex -interaction=nonstopmode -output-directory $(*D) $*.G.tex || exit 0
	rm --force $*.G.tex $*.G.log $*.G.aux

%.0.pdf: %.xhtml mk-tex-a4.xsl
	xsltproc --stringparam language $(subst .,,$(suffix $*)) --stringparam style 0 mk-tex-a4.xsl $< | sed -e 's/ /~/' > $*.0.tex
	pdflatex -interaction=nonstopmode -output-directory $(*D) $*.0.tex || exit 0
	rm --force $*.0.tex $*.0.log $*.0.aux
