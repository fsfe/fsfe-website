<?xml version='1.0' encoding="iso-8859-1"?>
<xsl:stylesheet
          xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<xsl:output method="text" encoding="iso-8859-1"/>

<xsl:param name="lang"/>

<xsl:template match="translation">

\documentclass[a4paper]{article}
\usepackage{isolatin1}
\usepackage[T1]{fontenc}
\usepackage[french]{babel}
\usepackage{url}
\usepackage{boxedminipage}
\usepackage{palatino}

\setlength{\parskip}{1.2ex}
\setlength{\parindent}{0cm}
\setlength{\oddsidemargin}{-0.5cm}
\setlength{\evensidemargin}{-0.5cm}
\setlength{\marginparwidth}{0cm}
\setlength{\marginparsep}{0cm}

\setlength{\topmargin}{-1cm}
\setlength{\textheight}{25cm}
\setlength{\textwidth}{17cm}


\begin{document}
  
\begin{center}
<xsl:choose>
  <xsl:when test="$lang">
      \title{\Huge\bf <xsl:value-of select="./transinfo/title[@lang=$lang]"/>}
  </xsl:when>
  <xsl:otherwise>
      {\Huge\bf <xsl:value-of select="./transinfo/title[@lang=/translation@dst]"/> 

({\em <xsl:value-of select="./transinfo/title[@lang=/translation@src]"/>})}
  </xsl:otherwise>
</xsl:choose>

\vskip .5cm

<xsl:apply-templates select="transinfo/authorgroup"/>

\end{center}

<xsl:choose>
  <xsl:when test="$lang">
      <xsl:value-of select="./transinfo/abstract[@lang=$lang]"/>\\
  </xsl:when>
  <xsl:otherwise>

\begin{minipage}[t]{17cm}
\begin{minipage}[t]{8.3cm}
{\bf Original:}
<xsl:value-of select="./transinfo/abstract[@lang=/translation@src]"/>
\end{minipage}
~~~\vrule~~~
\begin{minipage}[t]{8.3cm}
{\bf Traduction:}
<xsl:value-of select="./transinfo/abstract[@lang=/translation@dst]"/>
\end{minipage}
\end{minipage}

\vskip .5cm

  </xsl:otherwise>
</xsl:choose>

\hrule
 
<xsl:apply-templates select="section"/>

\end{document}

</xsl:template>

<xsl:template match="authorgroup/author">
{\bf <xsl:value-of select="name"/><xsl:if test="organisation">, 
<xsl:value-of select="organisation"/>, 
</xsl:if>
<xsl:if test="organisation">{\tt <xsl:value-of select="email"/>}}</xsl:if>

</xsl:template>

<xsl:template match="section">
<xsl:choose>
  <xsl:when test="$lang">
    \section{<xsl:value-of select="title[@lang=$lang]"/>}
  </xsl:when>
  <xsl:otherwise>
    \section{<xsl:value-of select="title[@lang=/translation@dst]"/>\\({\em <xsl:value-of select="title[@lang=/translation@src]"/>})}
  </xsl:otherwise>
</xsl:choose>

<xsl:apply-templates select="para"/>

</xsl:template>

<xsl:template match="para">
<xsl:choose>
  <xsl:when test="$lang">
    <xsl:if test="$lang=/translation/@dst">
      <xsl:apply-templates select="dst"/>
    </xsl:if>
    <xsl:if test="$lang=/translation/@src">
      <xsl:apply-templates select="src"/>
    </xsl:if>
  </xsl:when>
  <xsl:otherwise>
\begin{minipage}[t]{17cm}
\begin{minipage}[t]{8.3cm}
{\bf Original:}
<xsl:apply-templates select="src"/>
\end{minipage}
~~~\vrule~~~
\begin{minipage}[t]{8.3cm}
{\bf Traduction:}
<xsl:apply-templates select="dst"/>
\end{minipage}
\end{minipage}

  </xsl:otherwise>
</xsl:choose>

<xsl:apply-templates select="notes"/>

\vskip .5cm

</xsl:template>


<xsl:template match="para/notes">

\begin{boxedminipage}[t]{\textwidth}
{\em
<xsl:choose>
  <xsl:when test="$lang">
    <xsl:choose>
      <xsl:when test="@lang">
        <xsl:if test="@lang=$lang">
          <xsl:apply-templates/>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:when>
  <xsl:otherwise>
    <xsl:apply-templates/>
  </xsl:otherwise>
</xsl:choose>
}
\end{boxedminipage}
</xsl:template>

</xsl:stylesheet>

