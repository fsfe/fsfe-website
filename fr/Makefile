pags = index.fr.html contact.fr.html thanks.fr.html boilerplate.html

all: $(pags)

$(pags): %.html: %.xml menu.xml fsfe-fr.xsl
	sabcmd fsfe-fr.xsl $< > $@


