pags = index.html contact.html mailinglists.html
pags.de = index.de.html
pags.fr = index.fr.html

all: $(pags) $(pags.de) $(pags.fr)

$(pags): %.html: %.xml menu.xml fsfe.xsl
	sabcmd fsfe.xsl $< > $@

$(pags.de): %.html: %.xml menu.de.xml fsfe.de.xsl
	sabcmd fsfe.de.xsl $< > $@

$(pags.fr): %.html: %.xml menu.fr.xml fsfe.fr.xsl
	sabcmd fsfe.fr.xsl $< > $@


