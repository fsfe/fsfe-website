
# XML declaration
XML_DECL=/usr/lib/sgml/declaration/xml.decl

# System Catalogs
# Deactivating default XML catalog support for now
# Defining variables and exporting them at the same time
export XML_CATALOG_FILES=
export SGML_CATALOG_FILES=/usr/lib/sgml/catalog

# Every variables in this makefile are computed from the XML_SRC variable
# It has a default value, so the makefile works by itself is one just
# types : 
# $ make
# But this XML_SRC variable can be modified without editing this makefile,
# thus making it possible to process any XML document with the same
# makefile :-)
# Example :
# $ make CHOICE=FAQConstructeurs.en.xml
CHOICE=FAQConstructeurs.fr.xml

# The server which does the publishing
DEPLOYMENT="aful:"

# Initializing XML_SRC with the given CHOICE
XML_SRC=${CHOICE}
XML_SRC_LONG=${addprefix long, ${XML_SRC}}
XML_SRC_SHORT=${addprefix short, ${XML_SRC}}

# Output directories
HTML_OUT_DIR=generated-html
PRINT_OUT_DIR=generated-print

# All LONG outputs have the same name as the original document whith only 
# the extension that is changing. The SHORT outputs have the same name as
# the LONG outputs with the "short" string prepended.
#
# Using a pattern substitution
# $(patsubst pattern,replacement,text)
HTML_OUTPUT=${patsubst %.xml,%.html,${XML_SRC}}
HTML_OUTPUT_LONG=${patsubst %.xml,%.html,${XML_SRC}}
HTML_OUTPUT_SHORT=${patsubst %.xml,%.html,${XML_SRC_SHORT}}

FO_OUTPUT=${patsubst %.xml,%.fo,${XML_SRC}}
FO_OUTPUT_LONG=${patsubst %.xml,%.fo,${XML_SRC}}
FO_OUTPUT_SHORT=${patsubst %.xml,%.fo,${XML_SRC_SHORT}}

LATEX_OUTPUT=${patsubst %.xml,%.tex,${XML_SRC}}
LATEX_OUTPUT_LONG=${patsubst %.xml,%.tex,${XML_SRC}}
LATEX_OUTPUT_SHORT=${patsubst %.xml,%.tex,${XML_SRC_SHORT}}

TEX_OUTPUT=${patsubst %.xml,%.tex,${XML_SRC}}
DVI_OUTPUT=${patsubst %.xml,%.dvi,${XML_SRC}}
PS_OUTPUT=${patsubst %.xml,%.ps,${XML_SRC}}


#=======================================================================
# Stylesheets
#=======================================================================

# XSL filter stylesheets to delete some specific elements.
# Customization has to be done in this filter.
LONG_SS_XSL=longVersion.xsl
SHORT_SS_XSL=shortVersion.xsl

#---------------------------------------------
# XSL stylesheets for the various outputs
#---------------------------------------------
# XSL stylesheet for HTML
HTML_SS_XSL=custom_html.xsl
# CSS stylesheet to be used by the HTML output
HTML_SS_CSS=lightNLegible.css

# XSL stylesheet that generates FO to get PDF output
FO_SS_XSL=custom_fo.xsl

# XSL stylesheet that generates high level LaTeX (but still beta)
LATEX_SS_XSL=custom_latex.xsl

# DSSSL stylesheet for HTML
HTML_SS_DSL=custom_html.dsl

# DSSSL stylesheet for TeX
PRINT_SS_DSL=custom_print.dsl
MAX_TEX_RECURSION=4


#=======================================================================

# Makefile rules :
# target: p1 p2 ... pn
#         actions
#
# 1. each prerequisite p is processed in order
# 2. actions are triggered if 
#     - target does not exist
#     - any prerequisite p is more recent than the file target

# Phony Targets, they got called all the time, even if a file with the same 
# name exists. There is no file existence check for those targets, 
# thus it improves performance.
#
# NOTE : 
# Don't put empty targets in the .PHONY targets, they would get executed all
# the time, which is the opposite of what they are for.
.PHONY: help test all \
	clean clean-html clean-print \
	xml-long xml-short \
	html html-long html-short \
	latex latex-long latex-short \
	tex dvi ps \
	fo fo-long fo-short \
	pdf pdf-long pdf-short

help:
	@echo "make help   prints this help message"
	@echo "make test   shows variable values"
	@echo
	@echo "make all    generates HTML + PDF outputs"
	@echo "make html   generates HTML outputs"
	@echo "make latex  generates LaTeX outputs"
	@echo "make dvi    generates DVI outputs"
	@echo "make fo     generates FO outputs"
	@echo "make pdf    generates PDF outputs"
	@echo "make ps     generates PostScript outputs"
	@echo

# Shortcuts
all:
oldall: html pdf
ph: prepare-html
pp: prepare-print
html: html-long html-short
latex: latex-long latex-short
fo: fo-long fo-short
pdf: pdf-long pdf-short

# Prints the values of the different variables to check if they are correct.
test:
	@echo "CATALOG = ${CATALOG}"
	@echo "XML_SRC = ${XML_SRC}"
	@echo "XML_SRC_LONG = ${XML_SRC_LONG}"
	@echo "XML_SRC_SHORT = ${XML_SRC_SHORT}"
	@echo "HTML_OUTPUT_LONG = ${HTML_OUTPUT_LONG}"
	@echo "HTML_OUTPUT_SHORT = ${HTML_OUTPUT_SHORT}"
	@echo "TEX_OUTPUT= ${TEX_OUTPUT}"
	@echo "DVI_OUTPUT = ${DVI_OUTPUT}"
	@echo "PS_OUTPUT = ${PS_OUTPUT}"

#=======================================================================
# Validates the XML source document
#=======================================================================

# -s : suppress output, error messages still printed
# -wxml : warnings about non-xml constructs
validate:
	nsgmls -s -wxml ${XML_DECL} ${XML_SRC}

#=======================================================================
# Creates the directories where the outputs will be generated
#=======================================================================

# This target uses an empty target file (see the touch).
# $@ is an automatic variable corresponding to the name of the target.
#
# [-d file] returns True if file exists and is a directory.
# So this target creates an output directory if there isn't any already.
# Using "mkdir ${HTML_DIR} || true" is not a good option since mkdir updates
# the last modification time of the directory even if it exists.
prepare-html: ${HTML_SS_CSS}
	if [ ! -d ${HTML_OUT_DIR} ]; then \
	mkdir ${HTML_OUT_DIR}; \
	fi
	cp -f ${HTML_SS_CSS} ${HTML_OUT_DIR}
	touch $@

prepare-print:
	if [ ! -d ${PRINT_OUT_DIR} ]; then \
	mkdir ${PRINT_OUT_DIR}; \
	fi
	touch $@

# Copies through SSH the generated files on a remote server for publication
deploy:
	scp ${HTML_OUT_DIR}/*.html ${PRINT_OUT_DIR}/*.pdf ${DEPLOYMENT}

#=======================================================================
# Generates filtered XML sources from the XML original source
#=======================================================================

xml-long: ${XML_SRC} ${LONG_SS_XSL}
	xsltproc \
	--catalogs \
	-o ${XML_SRC_LONG} \
	${LONG_SS_XSL} ${XML_SRC}
	touch $@

xml-short: ${XML_SRC} ${SHORT_SS_XSL}
	xsltproc \
	--catalogs \
	-o ${XML_SRC_SHORT} \
	${SHORT_SS_XSL} ${XML_SRC}
	touch $@

#=======================================================================

html-long: xml-long ${HTML_SS_XSL} prepare-html
	xsltproc \
	--catalogs \
	-o ${HTML_OUT_DIR}/${HTML_OUTPUT_LONG} \
	${HTML_SS_XSL} ${XML_SRC_LONG}
	touch $@

html-short: xml-short ${HTML_SS_XSL} prepare-html
	xsltproc \
	--catalogs \
	-o ${HTML_OUT_DIR}/${HTML_OUTPUT_SHORT} \
	${HTML_SS_XSL} ${XML_SRC_SHORT}
	touch $@

#=======================================================================

latex-long: xml-long ${LATEX_SS_XSL} prepare-print
	xsltproc \
	--catalogs \
	-o ${PRINT_OUT_DIR}/${LATEX_OUTPUT_LONG} \
	${LATEX_SS_XSL} ${XML_SRC_LONG}
	touch $@

latex-short: xml-short ${LATEX_SS_XSL} prepare-print
	xsltproc \
	--catalogs \
	-o ${PRINT_OUT_DIR}/${LATEX_OUTPUT_SHORT} \
	${LATEX_SS_XSL} ${XML_SRC_SHORT}
	touch $@

#=======================================================================

fo-long: xml-long ${FO_SS_XSL} prepare-print
	xsltproc \
	--catalogs \
	-o ${PRINT_OUT_DIR}/${FO_OUTPUT_LONG} \
	${FO_SS_XSL} ${XML_SRC_LONG}
	touch $@

fo-short: xml-short ${FO_SS_XSL} prepare-print
	xsltproc \
	--catalogs \
	-o ${PRINT_OUT_DIR}/${FO_OUTPUT_SHORT} \
	${FO_SS_XSL} ${XML_SRC_SHORT}
	touch $@

#=======================================================================

# Note that 2 recursion are necessary to get cross-references right.
pdf-long: fo-long prepare-print
	(cd ${PRINT_OUT_DIR}; \
	../pdfxmltex.sh ${FO_OUTPUT_LONG}; \
	../pdfxmltex.sh ${FO_OUTPUT_LONG} \
	)
	touch $@

# Note that 2 recursion are necessary to get cross-references right.
pdf-short: fo-short prepare-print
	(cd ${PRINT_OUT_DIR}; \
	../pdfxmltex.sh ${FO_OUTPUT_SHORT}; \
	../pdfxmltex.sh ${FO_OUTPUT_SHORT} \
	)
	touch $@

#=======================================================================

clean: clean-html clean-print
	rm -f prepare-html prepare-print        # removing empty target files
	rm -rf ${HTML_OUT_DIR} ${PRINT_OUT_DIR} # removing directories
	rm -f xml-*                             # removing empty target files
	rm -f ${XML_SRC_LONG} ${XML_SRC_SHORT}  # removing filtered sources

clean-html:
	rm -f ${HTML_OUT_DIR}/*
	rm -f html-*                  # removing empty target files

clean-print:
	rm -f ${PRINT_OUT_DIR}/*
	rm -f latex-* fo-* pdf-*      # removing empty target files
	rm -f tex dvi ps              # removing empty target files



# Local Variables:
# mode: makefile
# End:

