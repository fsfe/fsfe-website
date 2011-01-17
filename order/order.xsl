<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

  <!-- Fill dynamic content -->
  <xsl:template match="dynamic-content">
    <xsl:variable name="type"><xsl:value-of select="@type"/></xsl:variable>

    <xsl:element name="table">
      <xsl:attribute name="id">merchandise</xsl:attribute>

      <xsl:for-each select="/html/set/item [@type = $type]">
        <xsl:sort select="@date" order="descending"/>
        <xsl:variable name="id"><xsl:value-of select="@id"/></xsl:variable>
        <xsl:variable name="price"><xsl:value-of select="@price"/></xsl:variable>

        <xsl:element name="tr">
          <xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>

          <!-- Image -->
          <xsl:element name="td">
            <xsl:attribute name="class">image</xsl:attribute>
            <xsl:for-each select="image">
              <xsl:element name="a">
                <xsl:attribute name="href">
                  <xsl:value-of select="@large"/>
                </xsl:attribute>
                <xsl:element name="img">
                  <xsl:attribute name="alt">Image of the item</xsl:attribute>
                  <xsl:attribute name="src">
                    <xsl:value-of select="@small"/>
                  </xsl:attribute>
                </xsl:element>
              </xsl:element>
            </xsl:for-each>
          </xsl:element>

          <!-- Name and description -->
          <xsl:element name="td">
            <xsl:attribute name="class">description</xsl:attribute>

            <xsl:element name="h3">
              <xsl:value-of select="/html/set/info[@id=$id]/name"/>
              <xsl:text> (€</xsl:text>
              <xsl:value-of select="@price"/>
              <xsl:text>)</xsl:text>
            </xsl:element>

            <xsl:apply-templates
              select="/html/set/info[@id=$id]/description/node()"/>
          </xsl:element>

          <!-- Order quantity -->
          <xsl:element name="td">
            <xsl:attribute name="class">quantity</xsl:attribute>
            <xsl:for-each select="available">
              <xsl:element name="p">
                <xsl:value-of select="@size"/>
                <xsl:text>: </xsl:text>

                <!-- Real input for quantity -->
                <xsl:element name="input">
                  <xsl:attribute name="type">text</xsl:attribute>
                  <xsl:attribute name="size">2</xsl:attribute>
                  <xsl:attribute name="name">
                    <xsl:value-of select="$id"/>
                    <xsl:text>_</xsl:text>
                    <xsl:value-of select="@size"/>
                  </xsl:attribute>
                </xsl:element>

                <!-- Hidden input to pass price into CGI script -->
                <xsl:element name="input">
                  <xsl:attribute name="type">hidden</xsl:attribute>
                  <xsl:attribute name="name">
                    <xsl:text>_</xsl:text>
                    <xsl:value-of select="$id"/>
                    <xsl:text>_</xsl:text>
                    <xsl:value-of select="@size"/>
                  </xsl:attribute>
                  <xsl:attribute name="value">
                    <xsl:value-of select="$price"/>
                  </xsl:attribute>
                </xsl:element>

              </xsl:element>
            </xsl:for-each>
          </xsl:element>

        </xsl:element>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <!-- Do not copy <set> or <text> to output at all -->
  <xsl:template match="set"/>
  
  <!-- For all other nodes, copy verbatim -->
  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
