# -----------------------------------------------------------------------------
# Makefile to generate includeable .xml files from .xhtml news pages
# -----------------------------------------------------------------------------

.PHONY: all

# -----------------------------------------------------------------------------
# Remove .xml files where original .xhtml file does not exist anymore
# -----------------------------------------------------------------------------
# note the reversal of target <-> prerequisite relationship
# make will execute thew command for all xhtml files (targets) that
# do not exist, in doing so it will not make the target, but rather
# remove the xml file that generated it

# All currently existing generated .xml files
GENERATED_XML := $(wildcard */.*.xml)

# List of corresponding source files (foo/.bar.xx.xml -> foo/bar.xx.xhtml)
GENERATED_XML_SOURCES := $(patsubst %.xml,%.xhtml,$(subst /.,/,$(GENERATED_XML)))

all: $(GENERATED_XML_SOURCES)
%.xhtml:
	@echo '*   Removing $(subst /,/.,$*).xml'
	@rm '$(subst /,/.,$*).xml'

# -----------------------------------------------------------------------------
# Generate .xml files from .xhtml files
# -----------------------------------------------------------------------------

.SECONDEXPANSION:

# All existing .xhtml files
XHTML := $(shell ls */*.??.xhtml | xargs grep -l '<html newsdate')

# List of .xml files to generate
XML := $(patsubst %.xhtml,%.xml,$(subst /,/.,$(XHTML)))

all: $(XML)
XMLSOURCE = $(patsubst %.xml,%.xhtml,$(subst /.,/,$@))
%.xml: $$(XMLSOURCE) xhtml2xml.xsl
	@echo '*   Generating $@'
	@xsltproc --stringparam link '/news/$(basename $(basename $<)).html' xhtml2xml.xsl '$<' > '$@'
