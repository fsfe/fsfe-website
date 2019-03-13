# -----------------------------------------------------------------------------
# Makefile for FSFE website build, preparation for events subdirectory
# -----------------------------------------------------------------------------

.PHONY: all
.SECONDEXPANSION:

# -----------------------------------------------------------------------------
# Copy event archive template to each of the years
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
	@echo "events/$(dir $@)event-*:[]\nevents/$(dir $@).event-*:[]\nlocalmenuinfo:[]\n" > $@

# .xsl files to generate
ARCH_XSL := $(foreach year,$(ARCH_YEARS),$(year)/$(year).xsl)

all: $(ARCH_XSL)
$(ARCH_XSL): %.xsl: events.xsl
	@echo "*   Creating $@"
	@sed -r 's/(import href=")/\1..\//; s/(\.\.\/about)/..\/\1/' $< > $@
