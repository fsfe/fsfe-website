.PHONY: all .FORCE
.FORCE:
all:

# -----------------------------------------------------------------------------
# remove xml files where original xhtml does not exist anymore
# -----------------------------------------------------------------------------
# note the reversal of target <-> prerequisite relationship
# make will execute thew command for all xhtml files (targets) that
# do not exist, in doing so it will not make the target, but rather
# remove the xml file that generated it

REMOVALS := $(subst ___,/,$(patsubst ./generated_xml/%.xml,../%.xhtml,$(wildcard ./generated_xml/*.xml)))
../%.xhtml:
	rm generated_xml/$(subst /,___,$*).xml

all: $(REMOVALS)

# -----------------------------------------------------------------------------
# build includable xml files from all xhtml files that contain news
# -----------------------------------------------------------------------------
XMLNAMES := $(shell find ../ -name '*.xhtml' \
              | xargs grep -l "<html newsdate" \
              | sed -r 's;/;___;g; s;^\.\.___(.+)\.xhtml$$;./generated_xml/\1.xml;;' \
             )

XMLSOURCE = ../$(subst ___,/,$*).xhtml

all: $(XMLNAMES)

.SECONDEXPANSION:

generated_xml/%.xml: $$(XMLSOURCE) #xhtml2xml.xsl
	xsltproc --stringparam link /$(subst ___,/,$(basename $*)).html xhtml2xml.xsl $< > $@
