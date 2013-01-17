<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../../../fsfe.xsl" />
  <xsl:output method="html" encoding="utf-8" indent="yes" doctype-system="about:legacy-compat" />

  <!-- Fill dynamic content -->
  <xsl:template match="dynamic-content">
    <xsl:element name="ul">
      <xsl:for-each select="/buildinfo/document/set/person[@chapter_de='yes']">
        <xsl:sort select="@id"/>
        <xsl:element name="li">
          <xsl:value-of select="name"/>
        </xsl:element>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
