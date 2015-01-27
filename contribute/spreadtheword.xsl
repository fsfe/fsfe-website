<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../fsfe.xsl" />
  <xsl:output method="html" encoding="utf-8" indent="yes" doctype-system="about:legacy-compat" />

  <!-- Fill dynamic content -->
  <xsl:template match="dynamic-content">
    <xsl:variable name="type"><xsl:value-of select="@type"/></xsl:variable>

    <!-- Full Item -->
    <xsl:element name="div">
      <xsl:attribute name="class">left break margin-vertical</xsl:attribute>

      <xsl:for-each select="/buildinfo/document/set/item [@type = $type]">
        <xsl:sort select="@order" order="descending"/>
        
        <xsl:variable name="id"><xsl:value-of select="@id"/></xsl:variable>

        <!-- Name -->
        <xsl:element name="p">
          <xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
          <xsl:element name="strong">
            <xsl:value-of select="/buildinfo/document/set/info[@id=$id]/name" />
          </xsl:element>
        </xsl:element>
        <!-- / Name -->
        
        <!-- Image -->
        <xsl:for-each select="image">
          <xsl:element name="a">
            <xsl:attribute name="href">
              <xsl:value-of select="@imglarge" />
            </xsl:attribute>
            <xsl:attribute name="title">
              <xsl:value-of select="/buildinfo/document/set/info[@id=$id]/name" />
            </xsl:attribute>
          
            <xsl:element name="img">
              <xsl:attribute name="class">left grid-30</xsl:attribute>
              <xsl:attribute name="src">
                <xsl:value-of select="@imgsmall" />
              </xsl:attribute>
            </xsl:element>
          </xsl:element>
        </xsl:for-each>
        <!-- /Image -->
        
        <!-- Description -->
        <xsl:element name="p">
          <xsl:attribute name="class">right grid-70</xsl:attribute>
          <xsl:attribute name="style">margin-top:0;</xsl:attribute>
          <xsl:value-of select="/buildinfo/document/set/info[@id=$id]/description" />
        </xsl:element>
        <!-- / Description -->
        
        <!-- Details -->
        <xsl:element name="p">
          <xsl:attribute name="class">right grid-70</xsl:attribute>
          
          <!-- Type -->
          <xsl:element name="strong">
            <xsl:text>Type: </xsl:text>
          </xsl:element>
          <xsl:value-of select="/buildinfo/document/set/info[@id=$id]/type" />
          <xsl:element name="br"></xsl:element>
        
          <!-- Size -->
          <xsl:element name="strong">
            <xsl:text>Size: </xsl:text>
          </xsl:element>
          <xsl:value-of select="/buildinfo/document/set/info[@id=$id]/size" />
          <xsl:element name="br"></xsl:element>
          
          <!-- Available formats to download -->
          <xsl:element name="strong">
            <xsl:text>Available formats (to download): </xsl:text>
          </xsl:element>
          <xsl:element name="br"></xsl:element>
          <xsl:value-of select="/buildinfo/document/set/info[@id=$id]/download" />
          <xsl:element name="br"></xsl:element>
          
          <!-- Available languages to download -->
          <xsl:element name="strong">
            <xsl:text>Available languages (to download): </xsl:text>
          </xsl:element>
          <xsl:element name="br"></xsl:element>
          <xsl:value-of select="/buildinfo/document/set/info[@id=$id]/languages" />
          <xsl:element name="br"></xsl:element>
          
          <!-- Printed versions (order) -->
          <xsl:element name="strong">
            <xsl:text>Printed versions (order): </xsl:text>
          </xsl:element>
          <xsl:element name="br"></xsl:element>
          <xsl:value-of select="/buildinfo/document/set/info[@id=$id]/printed" />
          <xsl:element name="br"></xsl:element>
          
          <!-- License -->
          <xsl:element name="strong">
            <xsl:text>License: </xsl:text>
          </xsl:element>
          <xsl:value-of select="/buildinfo/document/set/info[@id=$id]/license" />
          <xsl:element name="br"></xsl:element>
        
        </xsl:element>
        <!-- / Details -->
        
        
      </xsl:for-each>
    </xsl:element>
    <!-- / Full Item -->
    
  </xsl:template>

</xsl:stylesheet>
