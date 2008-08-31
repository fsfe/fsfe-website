sources := $(wildcard folder.??.xhtml) $(wildcard ../../projects/*/leaflet-*.??.xhtml)

# FIXME: Sorry, no support for other character sets than Latin-1 yet
foldersources := $(filter-out %.el.xhtml,$(wildcard folder.??.xhtml))
leafletsources := $(filter-out %.el.xhtml,$(sources))

pdfs_F := $(foldersources:.xhtml=.F.pdf)
pdfs_G := $(leafletsources:.xhtml=.G.pdf)
pdfs_0 := $(leafletsources:.xhtml=.0.pdf)

# FIXME: How can we cause the rebuild to be run also when a file is deleted?

.PHONY: all

all: printable.en.xml $(pdfs_F) $(pdfs_G) $(pdfs_0)

printable.en.xml: $(sources) mk-printable-en-xml.sh
	/bin/bash mk-printable-en-xml.sh $(sources)

%.F.pdf: %.xhtml mk-tex-a3.xsl
	xsltproc --stringparam language $(subst .,,$(suffix $*)) mk-tex-a3.xsl $< | sed -e 's/ /~/' > $(*F).F.tex
	pdflatex -interaction=nonstopmode $(*F).F.tex || exit 0
	rm --force $(*F).F.tex $(*F).F.log $(*F).F.aux

%.G.pdf: %.xhtml mk-tex-a4.xsl
	xsltproc --stringparam language $(subst .,,$(suffix $*)) --stringparam style G mk-tex-a4.xsl $< | sed -e 's/ /~/' > $(*F).G.tex
	pdflatex -interaction=nonstopmode $(*F).G.tex || exit 0
	rm --force $(*F).G.tex $(*F).G.log $(*F).G.aux

%.0.pdf: %.xhtml mk-tex-a4.xsl
	xsltproc --stringparam language $(subst .,,$(suffix $*)) --stringparam style 0 mk-tex-a4.xsl $< | sed -e 's/ /~/' > $(*F).0.tex
	pdflatex -interaction=nonstopmode $(*F).0.tex || exit 0
	rm --force $(*F).0.tex $(*F).0.log $(*F).0.aux
