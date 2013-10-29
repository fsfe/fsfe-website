<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="text" encoding="UTF-8"/>

  <xsl:param name="language"/>

  <xsl:template match="html">
    <xsl:apply-templates match="body"/>
  </xsl:template>

  <xsl:template match="head"/>

  <xsl:template match="body">
    <xsl:text>\documentclass[11pt]{article}
\usepackage[a3paper]{geometry}</xsl:text>
    <xsl:if test="$language='el'">\usepackage[english,greek]{babel}</xsl:if>
    <xsl:text>\usepackage{ucs}
\usepackage[utf8x]{inputenc}
\usepackage[T1]{fontenc}
</xsl:text>
<xsl:if test="$language='ru'">\usepackage[russian]{babel}
</xsl:if>
<xsl:if test="$language!='el'">\usepackage{helvet}</xsl:if><xsl:text>
\usepackage{graphics}
\usepackage{color}
\usepackage[absolute]{textpos}

% Switch to A3 paper
\setlength\paperwidth{420mm}
\setlength\paperheight{297mm}

% No chapter numbering
\setcounter{secnumdepth}{-2}

% Colors
\definecolor{bluedark}{cmyk}{.9,.2,.1,.05}
\definecolor{fsfeblue}{cmyk}{1,.7,.05,.2}

\renewcommand{\familydefault}{\sfdefault}

% Section and subsection formatting
\makeatletter
\renewcommand{\section}{\@startsection{section}{2}{\z@}%
  {-3.5ex \@plus -1ex \@minus -.2ex}%
  {2.3ex \@plus.2ex}%
  {\fontsize{16pt}{18pt}\selectfont\bfseries\color{fsfeblue}}}
\renewcommand{\subsection}{\@startsection{section}{3}{\z@}%
  {\bigskipamount}%
  {\smallskipamount}%
  {\fontsize{12pt}{14.4pt}\selectfont\bfseries\itshape\color{fsfeblue}}}
\makeatother

</xsl:text>

    <!-- Begin of document -->
    <xsl:text>\begin{document}</xsl:text>
    <xsl:text>\pagestyle{empty}</xsl:text>

    <!-- First (outer) page -->
    <xsl:text>\begin{textblock*}{\paperwidth}(-32pt,0pt)</xsl:text>
    <xsl:text>\includegraphics{background-a3-outer.pdf}</xsl:text>
    <xsl:text>\end{textblock*}</xsl:text>
    <xsl:text>\begin{textblock*}{170mm}(20mm,70mm)</xsl:text>
    <xsl:text>\raggedright</xsl:text>
    <xsl:apply-templates select="div[@id='contribute']"/>

    <!-- Disclaimer -->
    <xsl:if test="$language!='de' and $language!='en' and $language!='es' and $language!='it'">
      <xsl:if test="$language='el'">
        \selectlanguage{english}
      </xsl:if>
      <xsl:if test="$language!='ru'">
      <xsl:text>
        \bigskip \scriptsize This is an unofficial translation. Please see
        http://www.fsfe.org/about/printable/printable.en.html for the
        original text.
      </xsl:text>
      </xsl:if>
      <xsl:if test="$language='ru'">
      <xsl:text>
        \bigskip \scriptsize Это неофициальный перевод. Оригинальный текст
        см. на http://www.fsfe.org/about/printable/printable.en.html
      </xsl:text>
      </xsl:if>
    </xsl:if>

    <xsl:text>\end{textblock*}</xsl:text>
    <xsl:text>~\pagebreak</xsl:text>

    <!-- Second (inner) page -->
    <xsl:text>\begin{textblock*}{\paperwidth}(-32pt,0pt)</xsl:text>
    <xsl:text>\includegraphics{background-a3-inner.pdf}</xsl:text>
    <xsl:text>\end{textblock*}</xsl:text>
    <xsl:text>\begin{textblock*}{170mm}(20mm,55mm)</xsl:text>
    <xsl:text>\raggedright</xsl:text>
    <xsl:apply-templates select="div[@id='fsfe']"/>
    <xsl:text>\end{textblock*}</xsl:text>
    <xsl:text>\begin{textblock*}{170mm}(230mm,55mm)</xsl:text>
    <xsl:text>\raggedright</xsl:text>
    <xsl:apply-templates select="div[@id='free_software']"/>
    <xsl:text>\end{textblock*}</xsl:text>

    <!-- End of document -->
    <xsl:text>\end{document}</xsl:text>
  </xsl:template>

  <xsl:template match="div">
    <xsl:apply-templates select="node()"/>
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
    <xsl:apply-templates select="li"/>
    <xsl:text>\bigskip</xsl:text>
  </xsl:template>

  <xsl:template match="li">
    <xsl:apply-templates select="node()"/>
  </xsl:template>
  
  <xsl:template match="b">
    <xsl:text>\subsection{</xsl:text>
    <xsl:apply-templates select="node()"/>
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="latin">
    <xsl:text>{\selectlanguage{english}</xsl:text>
    <xsl:apply-templates select="node()"/>
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="a">
    <xsl:text>{\color{bluedark} </xsl:text>
    <xsl:apply-templates select="node()"/>
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="br">\\</xsl:template>

  <xsl:template match="timestamp"/>
  <xsl:template match="translator"/>
</xsl:stylesheet>
