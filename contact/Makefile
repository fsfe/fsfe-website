pags = index.html

all: $(pags)

$(pags): %.html: %.xml menu.xml ../fsfe.xsl
	sabcmd ../fsfe.xsl $< > $@



