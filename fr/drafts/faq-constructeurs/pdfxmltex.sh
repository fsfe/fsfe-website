#!/bin/sh

pdftex -ini "&pdflatex" /usr/share/texmf/tex/xmltex/base/pdfxmltex.ini

pdflatex "&pdfxmltex" $1


