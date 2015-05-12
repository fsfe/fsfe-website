<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../../fsfe.xsl" />
  <xsl:output method="html" encoding="utf-8" indent="yes" doctype-system="about:legacy-compat" />

  <!-- Automatically created list of content -->
  <xsl:template match="supporters">
    <xsl:element name="p">
      <xsl:attribute name="style">text-align:justify;</xsl:attribute>
            
        <xsl:for-each select="/buildinfo/document/set/supporter">
          <xsl:sort select="@order" order="ascending" />
          
          <xsl:variable name="id"><xsl:value-of select="@id"/></xsl:variable>
          
          <xsl:element name="a">
            <xsl:attribute name="href">
              <xsl:copy-of select="/buildinfo/document/set/supporter[@id=$id]/link" />
            </xsl:attribute>
            
            <xsl:element name="img">
              <!-- class -->
              <xsl:attribute name="class">signatory-logo</xsl:attribute>
              
              <!-- alt -->
              <xsl:attribute name="alt">
                <xsl:value-of select="/buildinfo/document/set/supporter[@id=$id]/descr" />
              </xsl:attribute>
              
              <!-- title -->
              <xsl:attribute name="title">
                <xsl:copy-of select="/buildinfo/document/set/supporter[@id=$id]/name" />
              </xsl:attribute>              
              
              <!-- src -->
              <xsl:attribute name="class">
                <xsl:value-of select="/buildinfo/document/set/supporter[@id=$id]/image" />
              </xsl:attribute>              

            </xsl:element> <!-- /img -->
            
          </xsl:element> <!-- /a -->
        </xsl:for-each>
    </xsl:element> <!-- /p -->
  </xsl:template>

</xsl:stylesheet>
