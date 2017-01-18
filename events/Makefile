.PHONY: generated_xml/wikievents.en.xml

generated_xml/wikievents.en.xml:
	wget -qO- https://wiki.fsfe.org/Events/Published \
	| xsltproc --html ../tools/wikicalendars.xsl - 2>&- \
	| xmllint --format - >$@.cache
	diff -q $@.cache $@ || mv $@.cache $@
