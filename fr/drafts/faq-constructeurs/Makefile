
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
XML_SRC_CUT=${addprefix cut, ${XML_SRC}}

# Using a pattern substitution
# $(patsubst pattern,replacement,text)
HTML_OUTPUT=${patsubst %.xml,%.html,${XML_SRC}}
HTML_OUTPUT_CUT=${patsubst %.xml,%.html,${XML_SRC_CUT}}
TEX_OUTPUT=${patsubst %.xml,%.tex,${XML_SRC}}
DVI_OUTPUT=${patsubst %.xml,%.dvi,${XML_SRC}}
PS_OUTPUT=${patsubst %.xml,%.ps,${XML_SRC}}

# Output directories
HTML_OUT_DIR=generated-html
PRINT_OUT_DIR=generated-print

# XML declaration
XML_DECL=/usr/lib/sgml/declaration/xml.decl

# System Catalog
CATALOG=/usr/lib/sgml/catalog

# XSL filter stylesheet to delete some specific elements
# Customization has to be done in this filter.
CUT_SS_XSL=deleteElements.xsl

# XSL stylesheet for HTML
HTML_SS_XSL=custom_html.xsl
#HTML_SS_XSL=file:///usr/share/doc/hardware/AFUL/custom_html.xsl

# CSS stylesheet to be used by the HTML output
HTML_SS_CSS=lightNLegible.css

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
	init \
	ph pp h hx hd hdn p

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
all: test hdn print

# Shortcuts
ph: prepare-html
pp: prepare-print
h: html-xsl html-xsl-cut
hx: html-xsl
hd: html-dsssl
hdn: html-dsssl-nochunk
p: print


#=======================================================================
# Prints the values of the different variables to check if they are correct.
test:
	@echo "XML_SRC = ${XML_SRC}"
	@echo "XML_SRC_CUT = ${XML_SRC_CUT}"
	@echo "HTML_OUTPUT = ${HTML_OUTPUT}"
	@echo "HTML_OUTPUT_CUT = ${HTML_OUTPUT_CUT}"
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
	-in ${XML_SRC_CUT} \
	-xsl ${HTML_SS_XSL} \
	-out ${HTML_OUT_DIR}/${HTML_OUTPUT_CUT}
	touch $@

xml-xsl-cut: ${XML_SRC} ${CUT_SS_XSL}
	java \
	-Dxml.catalog.debug=0 \
	-Dxml.catalog.override=yes \
	-Dxml.catalog.files=${CATALOG} \
	org.apache.xalan.xslt.Process -v -html \
	-entityresolver ConfCatEntityResolver \
	-in ${XML_SRC} \
	-xsl ${CUT_SS_XSL} \
	-out ${XML_SRC_CUT}
	touch $@


xml-xsl-cut-with-xt: ${XML_SRC} ${HTML_SS_XSL}
	java \
	-Dcom.jclark.xsl.sax.parser=org.apache.xerces.parsers.SAXParser \
	com.jclark.xsl.sax.Driver \
	${XML_SRC} \
	${CUT_SS_XSL} \
	${XML_SRC_CUT}
	touch $@


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

clean-html:
	rm -f ${HTML_OUT_DIR}/*.htm*
	rm -f ${HTML_OUT_DIR}/*.css
	rm -f prepare-html # removing empty target files

clean-print:
	rm -f ${PRINT_OUT_DIR}/*.tex
	rm -f ${PRINT_OUT_DIR}/*.aux
	rm -f ${PRINT_OUT_DIR}/*.cmp
	rm -f ${PRINT_OUT_DIR}/*.log
	rm -f ${PRINT_OUT_DIR}/*.dvi
	rm -f ${PRINT_OUT_DIR}/*.ps
	rm -f prepare-print # removing empty target files

init:
	rm -rf ${HTML_OUT_DIR} ${PRINT_OUT_DIR}
	rm -f prepare-html prepare-print # removing empty target files


