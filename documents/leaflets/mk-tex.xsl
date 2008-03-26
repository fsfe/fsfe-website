<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="text" encoding="ISO-8859-1"/>

  <xsl:param name="style"/>

  <xsl:template match="html">
    <xsl:apply-templates match="body"/>
  </xsl:template>

  <xsl:template match="head"/>

  <xsl:template match="body">
    <xsl:text>\documentclass[a4paper]{article}
\usepackage[latin1]{inputenc}
\usepackage{helvet}
\usepackage{fancyheadings}
\usepackage{multicol}
</xsl:text><xsl:if test="$style='G'">\usepackage{graphics}
\usepackage[absolute]{textpos}
</xsl:if><xsl:text>
% Page layout
\setlength{\topmargin}{58pt}
\setlength{\headheight}{12pt}
\setlength{\headsep}{36pt}
\setlength{\textheight}{506pt}
\setlength{\footskip}{72pt}
\setlength{\oddsidemargin}{-32pt}
\setlength{\columnsep}{10pt}
\setlength{\textwidth}{514pt}
\raggedright

% Header and footer
\lhead{}
\chead{}
\rhead{}
\setlength{\headrulewidth}{0pt}
\cfoot{}
\rfoot{}
\setlength{\footrulewidth}{0pt}

% No chapter numbering
\setcounter{secnumdepth}{-2}

\renewcommand{\familydefault}{\sfdefault}

% Section and subsection formatting
\makeatletter
\renewcommand{\section}{\@startsection{section}{2}{\z@}%
  {-3.5ex \@plus -1ex \@minus -.2ex}%
  {2.3ex \@plus.2ex}%
  {\fontsize{12pt}{14.4pt}\selectfont\bfseries\itshape}}
\renewcommand{\subsection}{\@startsection{section}{3}{\z@}%
  {-3.25ex \@plus -1ex \@minus -.2ex}%
  {1.5ex \@plus.2ex}%
  {\fontsize{11pt}{12pt}\selectfont\bfseries\itshape}}
\makeatother

</xsl:text>
    <xsl:apply-templates select="h3"/>
    <xsl:apply-templates select="address"/>
    <xsl:text>
\begin{document}
  \pagestyle{fancy}</xsl:text><xsl:if test="$style='G'">
  \begin{textblock*}{\paperwidth}(0pt,0pt)
    \includegraphics{background.pdf}
  \end{textblock*}</xsl:if>
    <xsl:apply-templates select="h1"/>
    <xsl:text>
        \begin{bfseries}
            </xsl:text>
    <xsl:apply-templates select="p[@class='background']"/>
    <xsl:text>
        \end{bfseries}

          \begin{multicols}{2}
              </xsl:text>
    <xsl:apply-templates select="h2|p[not(@class='background')]|ul"/>
    <xsl:text>
        \end{multicols}
      \end{document}
    </xsl:text>
  </xsl:template>

  <xsl:template match="h3">
    <xsl:text>\lhead{\fontseries{bc}\selectfont </xsl:text>
    <xsl:value-of select="node()"/>
    <xsl:text>}
</xsl:text>
  </xsl:template>

  <xsl:template match="address">
    <xsl:text>\lfoot{\fontsize{8pt}{9.5pt}\selectfont </xsl:text>
    <xsl:apply-templates select="node()"/>
    <xsl:text>}
</xsl:text>
  </xsl:template>

  <xsl:template match="h1">
  \section{<xsl:value-of select="node()"/>}
  </xsl:template>
  
  <xsl:template match="h2">
    \subsection{<xsl:value-of select="node()"/>}
  </xsl:template>
  
  <xsl:template match="p">
    <xsl:text>
  </xsl:text>
    <xsl:apply-templates select="node()"/>
    <xsl:text>
  </xsl:text>
  </xsl:template>

  <xsl:template match="ul">
    \begin{itemize}
    <xsl:apply-templates select="li"/>
    \end{itemize}
  </xsl:template>

  <xsl:template match="li">
    \item <xsl:apply-templates select="node()"/>
  </xsl:template>
  
  <xsl:template match="a">
    <xsl:apply-templates select="node()"/>
  </xsl:template>

  <xsl:template match="br">\\</xsl:template>

  <xsl:template match="timestamp"/>
  <xsl:template match="translator"/>
</xsl:stylesheet>
