
all: PartA.dvi PartB.dvi PartC.dvi

PartA.dvi: PartA.tex
	latex PartA.tex

PartB.dvi: PartB.tex PartB.toc
	latex PartB.tex

PartB.toc: PartB.tex
	latex PartB.tex

PartC.dvi: PartC.tex PartC.toc
	latex PartC.tex

PartC.toc: PartC.tex
	latex PartC.tex
