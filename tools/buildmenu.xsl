<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

  <xsl:template match="localmenuset">
    
    <!-- Top level element of the local menu is "localmenuset" -->
    <xsl:element name="localmenuset">
      
      <!-- In "localmenuitems" each menu item is discribed in "menu" -->
      <!-- Only the English files defines the menu structure         -->
      <xsl:element name="localmenuitems">
        <xsl:for-each select="/localmenuset/menuitem[@language='en']">

          <xsl:element name="menu">
            
            <xsl:attribute name="dir"><xsl:value-of select="dir" /></xsl:attribute>
            <xsl:attribute name="set">
              <xsl:choose><xsl:when test="localmenu/@set">
                <xsl:value-of select="localmenu/@set" />
              </xsl:when><xsl:otherwise>
                <xsl:text>0</xsl:text>
              </xsl:otherwise></xsl:choose>
            </xsl:attribute>
            
            <xsl:attribute name="id"><xsl:value-of select="localmenu/@id" /></xsl:attribute>
            <xsl:attribute name="style">
              <xsl:choose><xsl:when test="localmenu/@style">
                <xsl:value-of select="localmenu/@style" />
              </xsl:when><xsl:otherwise>
                <xsl:text>default</xsl:text>
              </xsl:otherwise></xsl:choose>
            </xsl:attribute>
            
            <xsl:value-of select="link" />
            
          </xsl:element>
        </xsl:for-each>
      </xsl:element>
      
      <!-- In "translate" each available tranlation is described in "lang_part" -->
      <xsl:element name="translate">
        
        <xsl:for-each select="/localmenuset/menuitem">
          
          <xsl:element name="lang_part">
            
            <xsl:attribute name="dir">
              <xsl:value-of select="dir" />
            </xsl:attribute>
            
            <xsl:attribute name="set">
              <xsl:choose>
                <xsl:when test="localmenu/@set">
                  <xsl:value-of select="localmenu/@set" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>0</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
            
            <xsl:attribute name="id">
              <xsl:value-of select="localmenu/@id" />
            </xsl:attribute>
            
            <xsl:attribute name="language">
              <xsl:value-of select="@language" />
            </xsl:attribute>
            
            <xsl:value-of select="localmenu" />
            
          </xsl:element>
        </xsl:for-each>
      </xsl:element>
    </xsl:element>
    
  </xsl:template>
  
</xsl:stylesheet>
