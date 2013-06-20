XSL_STYLESHEET := xhtml2xml.xsl

# For a correct generation of the link, use full path from this directory
FILES := ../news/*/*.xhtml ../projects/*/*.xhtml

# Trying to keep things readable
ACTUAL_PREREQUISITE = ../$$(echo $* | sed -e 's,___,/,g').xhtml
FIND_XHTML = ../$$(echo $$FILE | sed -e 's,___,/,g').xhtml
TRANSFORM = xsltproc  --stringparam link $$(echo $$FILE | sed -e 's,\.\.,,' | sed -e 's,..\.xhtml,html,') $(XSL_STYLESHEET) $$FILE > $@

# Select files
sources := $(shell grep -l "<html newsdate" $(FILES))
all_xmls := $(notdir $(basename $(wildcard ./generated_xml/*.xml)))

# Create targets 
first_step = $(subst /,___, $(subst ../,, $(sources)))
too_xml := $(addprefix ./generated_xml/, $(first_step:.xhtml=.xml))


.PHONY: all
all: $(too_xml) remove_artifacts

generated_xml/%.xml: $(sources)
	for FILE in $?; do if [ "$$FILE" = "$(ACTUAL_PREREQUISITE)" ]; then $(TRANSFORM); else touch $@ ;  fi; done

# Remove xml files for files thas are no longer in CVS
.PHONY: remove_artifacts
remove_artifacts:
	for FILE in $(all_xmls); do if [ ! -f $(FIND_XHTML) ]; then rm generated_xml/$$FILE.xml ; fi ; done



