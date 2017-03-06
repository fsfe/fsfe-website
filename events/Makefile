.PHONY: all .FORCE
.FORCE:
all:

# -----------------------------------------------------------------------------
# Fetch event calendar from Wiki
# -----------------------------------------------------------------------------

generated_xml/wikievents.en.xml: .FORCE
	wget --user-agent="" -qO- "https://wiki.fsfe.org/Events/Published?action=refresh" \
	| xsltproc --html ../tools/wikicalendars.xsl - 2>&- \
	| xmllint --format - >$@.cache
	diff -q $@.cache $@ || mv $@.cache $@

all: generated_xml/wikievents.en.xml
