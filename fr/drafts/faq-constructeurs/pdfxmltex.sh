#!/bin/sh

pdftex -ini "&pdflatex" pdfxmltex.ini

pdflatex "&pdfxmltex" $1


