<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:import href="../../../fsfe.xsl" />
  
  <xsl:output method="html" encoding="utf-8" indent="yes" doctype-system="about:legacy-compat" />
  
<!-- This creates a page containing images of a gallery. All pictures are located in a directory and have numbered names (here ilovefs-gallery-thumb-NNN.jpg) -->
  <xsl:template match="picture-list">    
    <!-- appears once when <picture-list /> is called -->
    <!-- this template calls the loop below -->
    <xsl:call-template name="picture-list">
      <xsl:with-param name="num" select="1"/> <!-- starting number -->
      <xsl:with-param name="max" select="68"/> <!-- select maximum number of pictures which should be shown in picture list -->
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="picture-list">
    <xsl:param name="num"/>
    <xsl:param name="max"/>
    <xsl:if test="not($num > $max)">
      
      <!-- left side (uneven numbers) -->
      <xsl:element name="div">
        <xsl:attribute name="class">captioned left</xsl:attribute>
        <xsl:attribute name="style">max-width: 300px; width: 40%;</xsl:attribute>
        <xsl:element name="a">
          <xsl:attribute name="href">http://download.fsfe.org/campaigns/ilovefs/gallery/ilovefs-gallery-<xsl:value-of select="$num"/>.jpg</xsl:attribute>
          <xsl:element name="img">
            <xsl:attribute name="src">/campaigns/ilovefs/whylovefs/photos/gallery/ilovefs-gallery-thumb-<xsl:value-of select="$num"/>.jpg</xsl:attribute>
            <xsl:attribute name="alt">A picture of one or more Free Software loving persons</xsl:attribute>
            <xsl:attribute name="width">100%</xsl:attribute>
          </xsl:element> <!-- /img -->
        </xsl:element> <!-- /a -->
      </xsl:element> <!-- /div -->
      
      <!-- right side (even numbers) -->
      <xsl:element name="div">
        <xsl:attribute name="class">captioned right</xsl:attribute>
        <xsl:attribute name="style">max-width: 300px; width: 40%;</xsl:attribute>
        <xsl:element name="a">
          <xsl:attribute name="href">http://download.fsfe.org/campaigns/ilovefs/gallery/ilovefs-gallery-<xsl:value-of select="$num+1"/>.jpg</xsl:attribute>
          <xsl:element name="img">
            <xsl:attribute name="src">/campaigns/ilovefs/whylovefs/photos/gallery/ilovefs-gallery-thumb-<xsl:value-of select="$num+1"/>.jpg</xsl:attribute>
            <xsl:attribute name="alt">A picture of one or more Free Software loving persons</xsl:attribute>
            <xsl:attribute name="width">100%</xsl:attribute>
          </xsl:element> <!-- /img -->
        </xsl:element> <!-- /a -->
      </xsl:element> <!-- /div -->
      
      <!-- initiate the next round -->
      <xsl:call-template name="picture-list"> 
        <xsl:with-param name="num">
          <xsl:value-of select="$num+2" /> <!-- count +2, because +1 is already the right side -->
        </xsl:with-param>
        <xsl:with-param name="max" select="$max"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  <!-- / picture-list -->
  
</xsl:stylesheet>
