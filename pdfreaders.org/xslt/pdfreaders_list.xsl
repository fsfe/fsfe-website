<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="readerlist">
    <xsl:element name="div"><xsl:attribute name="class">readerlist</xsl:attribute>
      <xsl:for-each select="/buildinfo/document/set/reader">
        <xsl:sort select="@priority" order="ascending" />

        <xsl:element name="div">
          <xsl:attribute name="class">reader</xsl:attribute>

          <xsl:element name="img">
            <xsl:attribute name="class">logo</xsl:attribute>
            <xsl:attribute name="src">logos/<xsl:value-of select="logo" /></xsl:attribute>
            <xsl:attribute name="alt"></xsl:attribute>
          </xsl:element>

          <xsl:element name="h1">
            <xsl:element name="a"> <xsl:attribute name="class">info homepage</xsl:attribute>
              <xsl:attribute name="href"><xsl:value-of select="homepage" /></xsl:attribute>
              <xsl:value-of select="name" />
            </xsl:element>
          </xsl:element>

          <xsl:element name="span"> <xsl:attribute name="class">label platform</xsl:attribute>
            <xsl:call-template name="fsfe-gettext">
              <xsl:with-param name="id" select="'pdfreaders-body-platforms'" />
            </xsl:call-template>
          </xsl:element>
          <xsl:for-each select="platform">
            <xsl:element name="a"> <xsl:attribute name="class">info platform</xsl:attribute>
              <xsl:attribute name="href"><xsl:value-of select="installer" /></xsl:attribute>
              <xsl:value-of select="name" />
            </xsl:element>
          </xsl:for-each>

          <xsl:element name="p"> <xsl:attribute name="class">description</xsl:attribute>
            <xsl:apply-templates select="description/node()" />
          </xsl:element>

        </xsl:element>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
