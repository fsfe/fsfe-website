sources := $(wildcard folder.??.xhtml) $(wildcard leaflet-*.??.xhtml)

leaflets.en.xml: $(sources) mk-leaflets-en-xml.sh
	/bin/bash mk-leaflets-en-xml.sh $(sources)
