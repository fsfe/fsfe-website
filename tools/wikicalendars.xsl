<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- Strings for upper/lower case translation (plain latin will suffice here) -->
<xsl:variable name="lower" select="'abcdefghijklmnopqrstuvwxyz'" />
<xsl:variable name="upper" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />


<xsl:template name="buildevent">
  <xsl:param name="title"/>
  <xsl:param name="start"/>
  <xsl:param name="end"/>
  <xsl:param name="link"/>
  <xsl:param name="location"/>
  <xsl:param name="description"/>

  <xsl:element name="event">
    <xsl:choose><xsl:when test="translate($start, '0123456789', 'xxxxxxxxxx') = 'xxxx-xx-xx' ">
      <xsl:attribute name="start"><xsl:value-of select="$start"/></xsl:attribute>
    </xsl:when><xsl:when test="translate(substring-before($start, ' '), '0123456789', 'xxxxxxxxxx') = 'xxxx-xx-xx' ">
      <xsl:attribute name="start"><xsl:value-of select="substring-before($start, ' ')"/></xsl:attribute>
    </xsl:when></xsl:choose>

    <xsl:choose><xsl:when test="translate($end, '0123456789', 'xxxxxxxxxx') = 'xxxx-xx-xx' ">
      <xsl:attribute name="end"><xsl:value-of select="$end"/></xsl:attribute>

    </xsl:when><xsl:when test="translate(substring-before($end, ' '), '0123456789', 'xxxxxxxxxx') = 'xxxx-xx-xx' ">
      <xsl:attribute name="end"><xsl:value-of select="substring-before($end, ' ')"/></xsl:attribute>

    </xsl:when><xsl:when test="translate($start, '0123456789', 'xxxxxxxxxx') = 'xxxx-xx-xx' ">
      <xsl:attribute name="end"><xsl:value-of select="$start"/></xsl:attribute>
    </xsl:when><xsl:when test="translate(substring-before($start, ' '), '0123456789', 'xxxxxxxxxx') = 'xxxx-xx-xx' ">
      <xsl:attribute name="end"><xsl:value-of select="substring-before($start, ' ')"/></xsl:attribute>
    </xsl:when></xsl:choose>

    <xsl:element name="title"><xsl:value-of select="$title"/></xsl:element>

    <xsl:if test="$link">
      <xsl:element name="link"><xsl:value-of select="$link"/></xsl:element>
    </xsl:if>

    <xsl:if test="$description">
      <xsl:element name="body"><xsl:value-of select="$description"/></xsl:element>
    </xsl:if>
  </xsl:element>

</xsl:template>

<!-- extract data from definition array -->
<xsl:template match="dl">
  <xsl:param name="title"/>

  <!-- if-clause: only run if structure actually follows this title -->
  <xsl:if test="preceding::h1[1] = $title">
    <xsl:call-template name="buildevent">
      <xsl:with-param name="title" select="normalize-space(  $title  )"/>
      <xsl:with-param name="start"
        select="normalize-space(  dt[contains(translate(text(), $lower, $upper), 'START')]/following::dd[1]  )"/>
      <xsl:with-param name="end"
        select="normalize-space(  dt[contains(translate(text(), $lower, $upper), 'END')]/following::dd[1]  )"/>
      <xsl:with-param name="link"
        select="normalize-space(  dt[contains(translate(text(), $lower, $upper), 'LINK')]/following::dd[1]  )"/>
      <xsl:with-param name="location"
        select="normalize-space(  dt[contains(translate(text(), $lower, $upper), 'LOCATION')]/following::dd[1]  )"/>
      <xsl:with-param name="description"
        select="normalize-space(  dt[contains(translate(text(), $lower, $upper), 'DESCRIPTION')]/following::dd[1]  )"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<!-- select event entries -->
<xsl:template match="*[@id='content']">
<xsl:element name="eventset">
  <xsl:for-each select="h1|div/h1">
    <xsl:apply-templates select="following::dl[1]">
      <xsl:with-param name="title" select="node()" />
    </xsl:apply-templates>
  </xsl:for-each>
</xsl:element>
</xsl:template>

<!-- DISCARD ALL UNINTERESTING ELEMENTS -->
<xsl:template match="script"></xsl:template>
<xsl:template match="@*|node()">
  <xsl:apply-templates select="@*|node()" />
</xsl:template>

</xsl:stylesheet>
