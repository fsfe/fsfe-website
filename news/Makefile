# -----------------------------------------------------------------------------
# Makefile for FSFE website build, preparation for news subdirectory
# -----------------------------------------------------------------------------

.PHONY: all
.SECONDEXPANSION:

# -----------------------------------------------------------------------------
# Copy news archive template to each of the years
# -----------------------------------------------------------------------------

# All years for which a subdirectory exists
ARCH_YEARS := $(sort $(wildcard [0-9][0-9][0-9][0-9]))

# No archive for the current year
ARCH_YEARS := $(filter-out $(lastword $(ARCH_YEARS)),$(ARCH_YEARS))

# ... and the year before
ARCH_YEARS := $(filter-out $(lastword $(ARCH_YEARS)),$(ARCH_YEARS))

# Languages in which the template exists
ARCH_LANGS := $(suffix $(basename $(wildcard archive-template.??.xhtml)))

# .xhtml files to generate
ARCH_XHTML := $(foreach year,$(ARCH_YEARS),$(foreach lang,$(ARCH_LANGS),$(year)/$(year)$(lang).xhtml))

all: $(ARCH_XHTML)
$(ARCH_XHTML): %.xhtml: archive-template$$(suffix $$*).xhtml
	@echo "*   Creating $@"
	@# $(dir $@) returns YYYY/, we abuse the slash for closing the sed command
	@sed 's/:YYYY:/$(dir $@)g' $< > $@

# .sources files to generate
ARCH_SOURCES := $(foreach year,$(ARCH_YEARS),$(year)/$(year).sources)

all: $(ARCH_SOURCES)
$(ARCH_SOURCES): %.sources:
	@echo "*   Creating $@"
	@echo "news/$(dir $@)news-*:[]\nnews/$(dir $@).news-*:[]\nlocalmenuinfo:[]\n" > $@

# .xsl files to generate
ARCH_XSL := $(foreach year,$(ARCH_YEARS),$(year)/$(year).xsl)

all: $(ARCH_XSL)
$(ARCH_XSL): %.xsl: news.xsl
	@echo "*   Creating $@"
	@sed -r 's/(import href=")/\1..\//; s/(\.\.\/about)/..\/\1/' $< > $@

# -----------------------------------------------------------------------------
# Remove generated .xml files where original .xhtml file does not exist anymore
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

# All existing .xhtml files
XHTML := $(shell ls */*.??.xhtml | xargs grep -l '<html newsdate')

# List of .xml files to generate
XML := $(patsubst %.xhtml,%.xml,$(subst /,/.,$(XHTML)))

all: $(XML)
XMLSOURCE = $(patsubst %.xml,%.xhtml,$(subst /.,/,$@))
%.xml: $$(XMLSOURCE) xhtml2xml.xsl
	@echo '*   Generating $@'
	@xsltproc --stringparam link '/news/$(basename $(basename $<)).html' xhtml2xml.xsl '$<' > '$@'
