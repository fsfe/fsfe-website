HTML_XSLT=../xsl/html/translation.xsl
LATEX_XSLT=../xsl/latex/translation.xsl

all: translation.html translation.ps

clean:	
	rm -f translation.latex translation.dvi translation.ps translation.html translation.aux translation.log *~

%.ps:	%.dvi
	dvips -o $@ $<

%.dvi:	%.latex
	latex $<

%.latex:	%.xml $(LATEX_XSLT)
	sabcmd $(LATEX_XSLT) $< $@

%.html:	%.xml $(HTML_XSLT)
	sabcmd $(HTML_XSLT) $< $@
