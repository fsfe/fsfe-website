
# XML declaration
XML_DECL=/usr/lib/sgml/declaration/xml.decl

# System Catalog
CATALOG=/usr/lib/sgml/catalog


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

# Initializing XML_SRC with the given CHOICE
XML_SRC=${CHOICE}
# FAQConstructeurs.fr.xml -> cutFAQConstructeurs.fr.xml
XML_SRC_LONG=${addprefix long, ${XML_SRC}}
XML_SRC_SHORT=${addprefix short, ${XML_SRC}}

# Output directories
HTML_OUT_DIR=generated-html
PRINT_OUT_DIR=generated-print

# Using a pattern substitution
# $(patsubst pattern,replacement,text)
HTML_OUTPUT=${patsubst %.xml,%.html,${XML_SRC}}
HTML_OUTPUT_LONG=${patsubst %.xml,%.html,${XML_SRC}}
HTML_OUTPUT_SHORT=${patsubst %.xml,%.html,${XML_SRC_SHORT}}

FO_OUTPUT_LONG=${patsubst %.xml,%.fo,${XML_SRC}}
FO_OUTPUT_SHORT=${patsubst %.xml,%.fo,${XML_SRC_SHORT}}

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
.PHONY: help all test \
	clean clean-html clean-print \
	ph pp h hx hg hd hdn p

help:
	@echo "make help   prints this help message"
	@echo "make all    generates all outputs"
	@echo "make test   shows variable values"
	@echo "make h      generates html outputs (cut and uncut) using XSL"
	@echo "make p      generates print outputs using DSSSL"
	@echo "make hx     generates a single html chunk using XSL"
	@echo "make hdn    generates a single html chunk using DSSSL"
	@echo

#all: test html-xsl html-xsl-cut print
all: hg print

# Shortcuts
ph: prepare-html
pp: prepare-print
h: html-xsl html-xsl-cut
hx: html-xsl
hg: html-xsl-gnome-long html-xsl-gnome-short
hd: html-dsssl
hdn: html-dsssl-nochunk
p: print


#=======================================================================
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


#=======================================================================

xml-xsl-long: ${XML_SRC} ${LONG_SS_XSL}
	export SGML_CATALOG_FILES=${CATALOG}; \
	xsltproc \
	--catalogs \
	-o ${XML_SRC_LONG} \
	${LONG_SS_XSL} ${XML_SRC}
	touch $@

xml-xsl-short: ${XML_SRC} ${SHORT_SS_XSL}
	export SGML_CATALOG_FILES=${CATALOG}; \
	xsltproc \
	--catalogs \
	-o ${XML_SRC_SHORT} \
	${SHORT_SS_XSL} ${XML_SRC}
	touch $@


html-xsl-gnome: ${XML_SRC} ${HTML_SS_XSL} prepare-html
	export SGML_CATALOG_FILES=${CATALOG}; \
	xsltproc \
	--catalogs \
	-o ${HTML_OUT_DIR}/${HTML_OUTPUT} \
	${HTML_SS_XSL} ${XML_SRC}
	touch $@

html-xsl-gnome-long: xml-xsl-long ${HTML_SS_XSL} prepare-html
	export SGML_CATALOG_FILES=${CATALOG}; \
	xsltproc \
	--catalogs \
	-o ${HTML_OUT_DIR}/${HTML_OUTPUT_LONG} \
	${HTML_SS_XSL} ${XML_SRC_LONG}
	touch $@

html-xsl-gnome-short: xml-xsl-short ${HTML_SS_XSL} prepare-html
	export SGML_CATALOG_FILES=${CATALOG}; \
	xsltproc \
	--catalogs \
	-o ${HTML_OUT_DIR}/${HTML_OUTPUT_SHORT} \
	${HTML_SS_XSL} ${XML_SRC_SHORT}
	touch $@

fo-xsl-gnome-long: xml-xsl-long ${FO_SS_XSL} prepare-print
	export SGML_CATALOG_FILES=${CATALOG}; \
	xsltproc \
	--catalogs \
	-o ${PRINT_OUT_DIR}/${FO_OUTPUT_LONG} \
	${FO_SS_XSL} ${XML_SRC_LONG}
	touch $@

pdf-xsl-gnome-long: fo-xsl-gnome-long prepare-print
	(cd ${PRINT_OUT_DIR}; \
	../pdfxmltex.sh ${FO_OUTPUT})
	touch $@

latex-xsl-gnome-long: xml-xsl-long ${LATEX_SS_XSL} prepare-print
	export SGML_CATALOG_FILES=${CATALOG}; \
	xsltproc \
	--catalogs \
	-o ${PRINT_OUT_DIR}/${TEX_OUTPUT} \
	${LATEX_SS_XSL} ${XML_SRC_LONG}
	touch $@


#=======================================================================

# ConfCatEntityResolver is used instead of 
# com.arbortext.catalog.CatalogEntityResolver.
# debug = [0-3]
html-xsl: ${XML_SRC} ${HTML_SS_XSL} prepare-html
	java \
	-Dxml.catalog.debug=0 \
	-Dxml.catalog.override=yes \
	-Dxml.catalog.files=${CATALOG} \
	org.apache.xalan.xslt.Process -v -html \
	-entityresolver ConfCatEntityResolver \
	-in ${XML_SRC} \
	-xsl ${HTML_SS_XSL} \
	-out ${HTML_OUT_DIR}/${HTML_OUTPUT}
	touch $@

html-xsl-cut: xml-xsl-cut ${HTML_SS_XSL} prepare-html
	java \
	-Dxml.catalog.debug=0 \
	-Dxml.catalog.override=yes \
	-Dxml.catalog.files=${CATALOG} \
	org.apache.xalan.xslt.Process -v -html \
	-entityresolver ConfCatEntityResolver \
	-in ${XML_SRC_SHORT} \
	-xsl ${HTML_SS_XSL} \
	-out ${HTML_OUT_DIR}/${HTML_OUTPUT_SHORT}
	touch $@

xml-xsl-cut: ${XML_SRC} ${SHORT_SS_XSL}
	java \
	-Dxml.catalog.debug=0 \
	-Dxml.catalog.override=yes \
	-Dxml.catalog.files=${CATALOG} \
	org.apache.xalan.xslt.Process -v -html \
	-entityresolver ConfCatEntityResolver \
	-in ${XML_SRC} \
	-xsl ${SHORT_SS_XSL} \
	-out ${XML_SRC_SHORT}
	touch $@


xml-xsl-cut-with-xt: ${XML_SRC} ${HTML_SS_XSL}
	java \
	-Dcom.jclark.xsl.sax.parser=org.apache.xerces.parsers.SAXParser \
	com.jclark.xsl.sax.Driver \
	${XML_SRC} \
	${SHORT_SS_XSL} \
	${XML_SRC_SHORT}
	touch $@


#=======================================================================

# "-V use-output-dir" on the Jade command line makes Jade use an output-dir,
# if it has been specified in the DSSSL stylesheet.
# Thus, the html chunks will be written to the output-dir, 
# instead of the current directory
html-dsssl: ${XML_SRC} ${HTML_SS_DSL} prepare-html
	(cd ${HTML_OUT_DIR}; \
	jade -t sgml \
	-d ../${HTML_SS_DSL} ${XML_DECL} ../${XML_SRC});
	touch $@

# "-V use-output-dir" on the Jade command line makes Jade use an output-dir,
# if it has been specified in the DSSSL stylesheet.
# Thus, the html chunks will be written to the output-dir, 
# instead of the current directory
html-dsssl-nochunk: ${XML_SRC} ${HTML_SS_DSL} prepare-html
	jade -t sgml -V nochunks \
	-d ${HTML_SS_DSL} ${XML_DECL} ${XML_SRC} \
	> ${HTML_OUT_DIR}/${HTML_OUTPUT}
	touch $@


# dvips will generate a .ps file 
# that can be viewed with gv file.ps
#
# "cd ${PRINT_OUT_DIR}" runs dvips in the ${PRINT_OUT_DIR} directory
print: dvi
	(cd ${PRINT_OUT_DIR}; \
	dvips -o ${PS_OUTPUT} -t a4 ${DVI_OUTPUT});
	touch $@

# jadetex will generate a .dvi file 
# that can be viewed with xdvi file.dvi
#
# jadetex needs to be run as long as the .aux file changes,
# because of the cross-referencing. 
# Usually after 3 runs all the references like 
# the bibliography and the index are done.
#
# "cd ${PRINT_OUT_DIR}" runs jadetex in the ${PRINT_OUT_DIR} directory
#
dvi: tex
	cd ${PRINT_OUT_DIR}; \
	jadetex ${TEX_OUTPUT}; \
	jadetex ${TEX_OUTPUT}; \
	jadetex ${TEX_OUTPUT}; \
	jadetex ${TEX_OUTPUT}
	touch $@

# "-o output_file" on the Jade command line tells jade 
# to produce its tex output in ${PRINT_OUT_DIR}.
#
# NOTE :
# It is important to declare the option -o before the others, because if not,
# jade will complain.
tex: ${XML_SRC} prepare-print
	jade -V tex-backend -t tex \
	-o ${PRINT_OUT_DIR}/${TEX_OUTPUT} \
	-d ${PRINT_SS_DSL} ${XML_DECL} ${XML_SRC}
	touch $@


#=======================================================================

clean: clean-html clean-print
	rm -rf ${HTML_OUT_DIR} ${PRINT_OUT_DIR} # removing directories
	rm -f prepare-html prepare-print        # removing empty target files
	rm -f xml-xsl-*                         # removing empty target files
	rm -f ${XML_SRC_LONG} ${XML_SRC_SHORT}

clean-html:
	rm -f ${HTML_OUT_DIR}/*.htm*
	rm -f ${HTML_OUT_DIR}/*.css
	rm -f prepare-html            # removing empty target files
	rm -f html-xsl-*              # removing empty target files
	rm -f html-dsssl-*            # removing empty target files

clean-print:
	rm -f ${PRINT_OUT_DIR}/*.tex
	rm -f ${PRINT_OUT_DIR}/*.aux
	rm -f ${PRINT_OUT_DIR}/*.cmp
	rm -f ${PRINT_OUT_DIR}/*.log
	rm -f ${PRINT_OUT_DIR}/*.dvi
	rm -f ${PRINT_OUT_DIR}/*.ps
	rm -f prepare-print           # removing empty target files
	rm -f fo-xsl-* latex-xsl-*    # removing empty target files
	rm -f print dvi tex           # removing empty target files


