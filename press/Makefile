pags = index.html
pags.fr = index.fr.html

all: $(pags) $(pags.fr)

$(pags): %.html: %.xml menu.xml ../fsfe.xsl
	sabcmd ../fsfe.xsl $< > $@

$(pags.fr): %.html: %.xml menu.fr.xml ../fsfe.fr.xsl
	sabcmd ../fsfe.fr.xsl $< > $@



