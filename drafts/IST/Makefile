SGML_DFLT_EXT = html ps pdf

all: PartA.dvi PartB.dvi PartC.dvi $(SGML_DFLT_EXT:%=pdh.fr.%) \
	pdh-newarchi.ps pdh-oldarchi.ps

SGML_OPTS = -c latin #-l fr

PartA.dvi: PartA.tex
	latex PartA.tex

PartB.dvi: PartB.tex PartB.toc
	latex PartB.tex

PartB.toc: PartB.tex
	latex PartB.tex

PartC.dvi: PartC.tex PartC.toc
	latex PartC.tex

PartC.toc: PartC.tex
	latex PartC.tex

%.ps: %.dot
	dot -Tps $< -o $@

%.html: %.sgml
	sgml2html $(SGML_OPTS) --split=0 $<

%.ps: %.sgml
	sgml2latex --papersize=a4 --output=ps $<

.PRECIOUS: %.dvi

%.dvi: %.sgml
	sgml2latex $<

%.pdf: %.dvi
	convert $< $@
