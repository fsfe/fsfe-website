all: apportll.html

clean:
	rm -f apportll.html

apportll.html: apportll.xml custom_html.xsl
	export SGML_CATALOG_FILES=/usr/lib/sgml/catalog ; \
	xsltproc \
	--catalogs \
	-o apportll.html \
	custom_html.xsl apportll.xml
