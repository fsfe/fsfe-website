HTML = \
	about.fr.html \
	statute.fr.html

FSFFRANCE = ..

all:: Constitution-fr.fr.html Constitution-fr.fr.ps

%.html : %.tex
	perl -p -e '$$_ = "" if(/scrartcl/)' < $< > tmp.tex
	-hevea tmp.tex
	perl -n -e 'print if(/HTMLHEAD/ .. /HTMLFOOT/)' < tmp.html > $@
	rm tmp.tex tmp.html

%.ps : %.tex
	latex $<
	dvips -t a4 -o $@ $*.dvi
	rm *.aux *.dvi *.log

include ../include.mk
