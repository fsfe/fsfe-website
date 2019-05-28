<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../tools/xsltsl/countries.xsl" />
  <xsl:import href="../fsfe.xsl" />

  <!-- Fill dynamic content -->
  <xsl:template match="dynamic-content">
    <xsl:variable name="type"><xsl:value-of select="@type"/></xsl:variable>

    <xsl:element name="table">
      <xsl:attribute name="class">merchandise</xsl:attribute>

      <xsl:for-each select="/buildinfo/document/set/item[@type=$type]">
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
              <xsl:value-of select="/buildinfo/document/set/info[@id=$id]/name"/>
              <xsl:text> (</xsl:text>
              <xsl:choose>
                <xsl:when test="@oldprice">
                  <xsl:element name="span">
                    <xsl:attribute name="style">text-decoration: line-through;</xsl:attribute>
                    <xsl:text>€</xsl:text>
                    <xsl:value-of select="@oldprice"/>
                  </xsl:element>
                  <xsl:text> </xsl:text>
                  <xsl:element name="span">
                    <xsl:attribute name="style">color: red;</xsl:attribute>
                    <xsl:text>€</xsl:text>
                    <xsl:value-of select="@price"/>
                  </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>€</xsl:text>
                  <xsl:value-of select="@price"/>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:text>)</xsl:text>
            </xsl:element>

            <xsl:apply-templates
              select="/buildinfo/document/set/info[@id=$id]/description/node()"/>
          </xsl:element>

          <!-- Order quantity -->
          <xsl:element name="td">
            <xsl:attribute name="class">quantity</xsl:attribute>
            <xsl:for-each select="available">
              <xsl:element name="p">

                <!-- Label, possibly with tooltip -->
                <xsl:choose>
                  <xsl:when test="$type='other'">
                    <xsl:value-of select="@size"/>
                    <xsl:text>:&#160;</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:element name="span">
                      <xsl:attribute name="class">tooltip-anchor</xsl:attribute>
                      <xsl:value-of select="@size"/>
                      <xsl:text>:</xsl:text>
                      <xsl:element name="span">
                        <xsl:attribute name="class">tooltip-content</xsl:attribute>
                        <xsl:element name="img">
                          <xsl:attribute name="src">
                            <xsl:choose>
                              <xsl:when test="$type='hooded'">size-hooded.svg</xsl:when>
                              <xsl:otherwise>size-tshirt.svg</xsl:otherwise>
                            </xsl:choose>
                          </xsl:attribute>
                        </xsl:element>
                        <xsl:element name="br"/>
                        <xsl:text>a&#160;=&#160;</xsl:text>
                        <xsl:value-of select="@a"/>
                        <xsl:text>&#160;cm</xsl:text>
                        <xsl:element name="br"/>
                        <xsl:text>b&#160;=&#160;</xsl:text>
                        <xsl:value-of select="@b"/>
                        <xsl:text>&#160;cm</xsl:text>
                        <xsl:if test="$type='hooded'">
                          <xsl:element name="br"/>
                          <xsl:text>c&#160;=&#160;</xsl:text>
                          <xsl:value-of select="@c"/>
                          <xsl:text>&#160;cm</xsl:text>
                        </xsl:if>
                      </xsl:element>
                      <xsl:text>&#160;</xsl:text>
                    </xsl:element>
                  </xsl:otherwise>
                </xsl:choose>

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

  <!-- Dropdown list of countries requiring a choice -->
  <xsl:template match="country-list">
    <xsl:call-template name="country-list">
      <xsl:with-param name="class" select="'form-control'"/>
      <xsl:with-param name="required" select="'yes'"/>
    </xsl:call-template>
  </xsl:template>

</xsl:stylesheet>
