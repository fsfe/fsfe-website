
all: PartA.dvi PartB.dvi

PartA.dvi: PartA.tex
	latex PartA.tex

PartB.dvi: PartB.tex PartB.toc
	latex PartB.tex

PartB.toc: PartB.tex
	latex PartB.tex
