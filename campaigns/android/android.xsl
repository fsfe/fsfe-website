<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../../fsfe.xsl" />
  <xsl:output method="html" encoding="utf-8" indent="yes" doctype-system="about:legacy-compat" />

  <!-- Automatically created list of content -->
  <xsl:template match="supporters">
    
    <!-- can be "logos", "table" -->
    <xsl:variable name="type"><xsl:value-of select="@type"/></xsl:variable>
    
    <!-- TYPE = LOGOS -->
    <xsl:if test="$type = 'logos'">
      
      <xsl:element name="p">
        <xsl:attribute name="style">text-align:justify;</xsl:attribute>
              
          <xsl:for-each select="/buildinfo/document/set/supporter">
            <xsl:sort select="@order" order="ascending" />
            
            <xsl:variable name="id"><xsl:value-of select="@id"/></xsl:variable>
            
            <xsl:element name="a">
              <xsl:attribute name="href">
                <xsl:value-of select="/buildinfo/document/set/supporter[@id=$id]/link" />
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
                  <xsl:value-of select="/buildinfo/document/set/supporter[@id=$id]/name" />
                </xsl:attribute>              
                
                <!-- src -->
                <xsl:attribute name="src">
                  <xsl:value-of select="/buildinfo/document/set/supporter[@id=$id]/image" />
                </xsl:attribute>              

              </xsl:element> <!-- /img -->
              
            </xsl:element> <!-- /a -->
          </xsl:for-each>
      </xsl:element> <!-- /p -->
    </xsl:if> <!-- /TYPE = LOGOS -->
    
    <!-- TYPE = TABLE -->
    <xsl:if test="$type = 'table'">
      
      <xsl:element name="div">
        <xsl:attribute name="class">thank-donors</xsl:attribute>
        <xsl:element name="table">
              
          <xsl:for-each select="/buildinfo/document/set/supporter">
            <xsl:sort select="@order" order="ascending" />
            
            <xsl:variable name="id"><xsl:value-of select="@id"/></xsl:variable>
            
            <xsl:element name="tr">
              <!-- Image -->
              <xsl:element name="td">
                <xsl:element name="a">
                  <xsl:attribute name="href">
                    <xsl:value-of select="/buildinfo/document/set/supporter[@id=$id]/link" />
                  </xsl:attribute>
                  
                  <xsl:element name="img">                  
                    <!-- alt -->
                    <xsl:attribute name="alt">
                      <xsl:value-of select="/buildinfo/document/set/supporter[@id=$id]/descr" />
                    </xsl:attribute>
                    
                    <!-- title -->
                    <xsl:attribute name="title">
                      <xsl:value-of select="/buildinfo/document/set/supporter[@id=$id]/name" />
                    </xsl:attribute>              
                    
                    <!-- src -->
                    <xsl:attribute name="src">
                      <xsl:value-of select="/buildinfo/document/set/supporter[@id=$id]/image" />
                    </xsl:attribute>              

                  </xsl:element> <!-- /img -->
                  
                </xsl:element> <!-- /a -->
              </xsl:element> <!-- /td -->
              <!-- /Image -->
              
              <!-- Description -->
              <xsl:element name="td">
                <xsl:value-of select="/buildinfo/document/set/supporter[@id=$id]/descr" />
              </xsl:element>
              <!-- /Description -->
            </xsl:element> <!-- /tr -->
            
            
          </xsl:for-each>
        </xsl:element> <!-- /table -->
      </xsl:element> <!-- /div -->
    </xsl:if> <!-- /TYPE = TABLE -->
    
  </xsl:template>

</xsl:stylesheet>
