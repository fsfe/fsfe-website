all: Constitution-fr.fr.html Constitution-fr.fr.ps

%.html : %.tex
	perl -p -e '$$_ = "" if(/scrartcl/)' < $< > tmp.tex
	-hevea tmp.tex
	perl -ni -e 'print if(/HTMLHEAD/ .. /HTMLFOOT/)' < tmp.html > $@
	rm tmp.tex tmp.html

%.ps : %.tex
	latex $<
	dvips -o $@ $*.dvi
	rm *.aux *.dvi *.log
