sources := $(wildcard folder.??.xhtml) $(wildcard leaflet-*.??.xhtml)

# FIXME: How can we cause the rebuild to be run also when a file is deleted?

leaflets.en.xml: $(sources) mk-leaflets-en-xml.sh
	/bin/bash mk-leaflets-en-xml.sh $(sources)
