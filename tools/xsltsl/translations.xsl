<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="xml" encoding="UTF-8" indent="yes" />
    
    <!-- this template is to be called to get texts contained in "tools/texts-xx.xml" files -->
    <xsl:template name="fsfe-gettext">
      <xsl:param name="id" />
      
      <xsl:choose>
        <xsl:when test="/buildinfo/textset/text[@id=$id]">
          <xsl:apply-templates select="/buildinfo/textset/text[@id=$id]/node()" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="/buildinfo/textsetbackup/text[@id=$id]/node()" />
        </xsl:otherwise>
      </xsl:choose>
      
    </xsl:template>
    
    <!-- this template is to be called to get texts contained in "tools/texts-content-xx.xml" files -->
    <xsl:template name="gettext">
      <xsl:param name="id" />
      
      <xsl:value-of select="/buildinfo/textset/text[@id=$id] |
                            /buildinfo/textsetbackup/text[ @id=$id and not(@id=/buildinfo/textset/text/@id) ]"/>
      
    </xsl:template>
    
    <!-- this template is to be called to get the text of _quotes_ contained in "tools/texts-xx.xml" files -->
    <xsl:template name="get-quote-text">
      <xsl:param name="id" />
      
      <xsl:choose>
        <xsl:when test="/buildinfo/textset/quotes/quote[@id=$id]/txt">
          <xsl:value-of select="normalize-space(/buildinfo/textset/quotes/quote[@id=$id]/txt)" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="normalize-space(/buildinfo/textsetbackup/quotes/quote[@id=$id]/txt)" />
        </xsl:otherwise>
      </xsl:choose>
      
    </xsl:template>
    
    <!-- this template is to be called to get the image of _quotes_ contained in "tools/texts-xx.xml" files -->
    <xsl:template name="get-quote-photo">
      <xsl:param name="id" />
      
      <xsl:choose>
        <xsl:when test="/buildinfo/textset/quotes/quote[@id=$id]/photo">
          <xsl:value-of select="normalize-space(/buildinfo/textset/quotes/quote[@id=$id]/photo)" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="normalize-space(/buildinfo/textsetbackup/quotes/quote[@id=$id]/photo)" />
        </xsl:otherwise>
      </xsl:choose>
      
    </xsl:template>
    
    <!-- this template is to be called to get the author's nam of _quotes_ contained in "tools/texts-xx.xml" files -->
    <xsl:template name="get-quote-author">
      <xsl:param name="id" />
      
      <xsl:choose>
        <xsl:when test="/buildinfo/textset/quotes/quote[@id=$id]/author">
          <xsl:value-of select="normalize-space(/buildinfo/textset/quotes/quote[@id=$id]/author)" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="normalize-space(/buildinfo/textsetbackup/quotes/quote[@id=$id]/author)" />
        </xsl:otherwise>
      </xsl:choose>
      
    </xsl:template>

</xsl:stylesheet>
