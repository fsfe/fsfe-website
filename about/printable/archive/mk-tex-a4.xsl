<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="text" encoding="UTF-8"/>

  <xsl:param name="language"/>
  <xsl:param name="style"/>

  <xsl:template match="html">
    <xsl:apply-templates match="body"/>
  </xsl:template>

  <xsl:template match="head"/>

  <xsl:template match="body">
    <xsl:text>\documentclass[a4paper]{article}</xsl:text>
    <xsl:if test="$language='el'">\usepackage[english,greek]{babel}</xsl:if>
    <xsl:text>\usepackage{ucs}
\usepackage[utf8x]{inputenc}
\usepackage[T1]{fontenc}
</xsl:text>
<xsl:if test="$language='ru'">\usepackage[russian]{babel}
</xsl:if>
<xsl:if test="$language!='el'">\usepackage{helvet}</xsl:if><xsl:text>
\usepackage{fancyhdr}
\usepackage{multicol}
</xsl:text><xsl:if test="$style='G'">\usepackage{graphics}
\usepackage[absolute]{textpos}
</xsl:if><xsl:text>
% Page layout
\setlength{\topmargin}{58pt}
\setlength{\headheight}{12pt}
\setlength{\headsep}{36pt}
\setlength{\textheight}{530pt}
\setlength{\footskip}{48pt}
\setlength{\oddsidemargin}{-32pt}
\setlength{\columnsep}{10pt}
\setlength{\textwidth}{514pt}
</xsl:text>
<xsl:if test="$language!='ru'">
\raggedright
</xsl:if>
<xsl:text>

% Header and footer
\chead{}
\rhead{\fontseries{bc}\selectfont (</xsl:text>
<xsl:value-of select="$language"/>
<xsl:text>)}
\cfoot{}
\rfoot{}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}

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
  {-3ex \@plus -1ex \@minus -.2ex}%
  {3pt}%
  {\fontsize{11pt}{12pt}\selectfont\bfseries\itshape}}
\makeatother

</xsl:text>
    <xsl:apply-templates select="a[@id='moreinfo']"/>
    <xsl:apply-templates select="address"/>
    <xsl:text>\begin{document}</xsl:text>
    <xsl:text>\pagestyle{fancy}</xsl:text>

    <!-- Folders -->
    <xsl:apply-templates select="div[@id='fsfe']"/>
    <xsl:apply-templates select="div[@id='contribute']"/>
    <xsl:apply-templates select="div[@id='free_software']"/>

    <!-- Leaflets -->
    <xsl:apply-templates select="h1"/>
    <xsl:text>\begin{bfseries}</xsl:text>
    <xsl:apply-templates select="p[@class='background']"/>
    <xsl:text>\end{bfseries}</xsl:text>
    <xsl:text>\begin{multicols}{2}</xsl:text>
    <xsl:apply-templates select="h2|p[not(@class='background')]|ul"/>
    <xsl:text>\end{multicols}</xsl:text>

    <!-- End of document -->
    <xsl:text>\end{document}</xsl:text>
  </xsl:template>

  <xsl:template match="a[@id='moreinfo']">
    <xsl:text>\lhead{</xsl:text>
    <xsl:if test="$style='G'">
      <xsl:text>\begin{textblock*}{\paperwidth}(0pt,0pt)</xsl:text>
      <xsl:text>\includegraphics{background-a4.pdf}</xsl:text>
      <xsl:text>\end{textblock*}</xsl:text>
    </xsl:if>
    <xsl:text>\fontseries{bc}\selectfont </xsl:text>
    <xsl:value-of select="node()"/>
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="address">
    <xsl:text>\lfoot{\fontsize{8pt}{9.5pt}\selectfont </xsl:text>
    <xsl:apply-templates select="node()"/>
    <!-- Disclaimer -->
    <xsl:if test="$language!='de' and $language!='en' and $language!='es' and $language!='it'">
      <xsl:if test="$language='el'">\selectlanguage{english}</xsl:if>
      <xsl:if test="$language!='ru'">
        <xsl:text>This is an unofficial translation. Please see </xsl:text>
        <xsl:text>http://www.fsfe.org/about/printable/printable.en.html</xsl:text>
        <xsl:text> for the original text.</xsl:text>
      </xsl:if>
      <xsl:if test="$language='ru'">
        <xsl:text>Это неофициальный перевод. </xsl:text>
        <xsl:text>Оригинальный текст см. на </xsl:text>
        <xsl:text>http://www.fsfe.org/about/printable/printable.en.html.</xsl:text>
      </xsl:if>
    </xsl:if>
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="div">
    <xsl:if test="@id='free_software'">
      <xsl:text>\break</xsl:text>
    </xsl:if>
    <xsl:if test="not(@id='fsfe')">
      <xsl:apply-templates select="h1"/>
    </xsl:if>
    <xsl:text>\begin{bfseries}</xsl:text>
    <xsl:apply-templates select="p[@class='background']"/>
    <xsl:text>\end{bfseries}\smallskip</xsl:text>
    <xsl:apply-templates select="h2|p[not(@class='background')]|ul"/>
  </xsl:template>

  <xsl:template match="h1">
    <xsl:text>\section{</xsl:text>
    <xsl:apply-templates select="node()"/>
    <xsl:text>}</xsl:text>
  </xsl:template>
  
  <xsl:template match="h2">
    <xsl:text>\subsection{</xsl:text>
    <xsl:apply-templates select="node()"/>
    <xsl:text>}</xsl:text>
  </xsl:template>
  
  <xsl:template match="p">
    <xsl:apply-templates select="node()"/>
    <xsl:text>\par </xsl:text>
  </xsl:template>

  <xsl:template match="ul">
    <xsl:text>\begin{itemize}</xsl:text>
    <xsl:text>\itemsep 3pt</xsl:text>
    <xsl:apply-templates select="li"/>
    <xsl:text>\end{itemize}</xsl:text>
  </xsl:template>

  <xsl:template match="li">
    <xsl:text>\item </xsl:text>
    <xsl:apply-templates select="node()"/>
  </xsl:template>
  
  <xsl:template match="b">
    <xsl:text>{\bfseries </xsl:text>
    <xsl:apply-templates select="node()"/>
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="latin">
    <xsl:text>{\selectlanguage{english}</xsl:text>
    <xsl:apply-templates select="node()"/>
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="a">
    <xsl:apply-templates select="node()"/>
  </xsl:template>

  <xsl:template match="br">\\</xsl:template>

  <xsl:template match="timestamp"/>
  <xsl:template match="translator"/>
</xsl:stylesheet>
