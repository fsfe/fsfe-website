<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                version='1.0'>

<!-- Import of the stylesheet to customize -->
<!-- Local install -->
<!-- <xsl:import href="/usr/local/docbook-xsl/latex/docbook.xsl"/> -->
<!-- Debian install -->
<xsl:import href="/usr/share/sgml/docbook/stylesheet/xsl/nwalsh/latex/docbook.xsl"/>


<xsl:output method="text" encoding="ISO-8859-1" indent="yes"/>

<xsl:variable name="latex.override">
% -----------------------  Define your Preamble Here 
%\documentclass[english,a4]{article}
\documentclass[french,a4]{article}
\usepackage{amsmath,amsthm, amsfonts, amssymb, amsxtra,amsopn}
\usepackage{graphicx}
\usepackage{float}
\usepackage{times}
\usepackage{algorithmic}
\usepackage[dvips]{hyperref}
\DeclareGraphicsExtensions{.eps}
% ------------------------  End of you preamble.
</xsl:variable>

</xsl:stylesheet>


