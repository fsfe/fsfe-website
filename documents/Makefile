pags = doi.html freesoftware.html
pags.de = freesoftware.de.html
pags.fr = doi.fr.html

all: $(pags) $(pags.de) $(pags.fr)

$(pags): %.html: %.xml menu.xml ../fsfe.xsl
	sabcmd ../fsfe.xsl $< > $@

$(pags.de): %.html: %.xml menu.de.xml ../fsfe.de.xsl
	sabcmd ../fsfe.de.xsl $< > $@

$(pags.fr): %.html: %.xml menu.fr.xml ../fsfe.fr.xsl
	sabcmd ../fsfe.fr.xsl $< > $@

clean:
	rm -f $(pags) $(pags.de) $(pags.fr)


