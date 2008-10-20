<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="ISO-8859-1" indent="yes"/>

  <!-- Fill dynamic content -->
  <xsl:template match="dynamic-content">
    <xsl:element name="ul">
      <xsl:for-each select="/html/set/person[@team='yes']">
        <xsl:sort select="@id"/>
        <xsl:element name="li">
          <xsl:element name="p">

            <!-- Name; if link is given show as link -->
            <xsl:element name="b">
              <xsl:choose>
                <xsl:when test="link != ''">
                  <xsl:element name="a">
                    <xsl:attribute name="href">
                      <xsl:value-of select="link"/>
                    </xsl:attribute>
                    <xsl:value-of select="name"/>
                  </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="name"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:element>

            <!-- E-mail -->
            <xsl:if test="email != ''">
              <xsl:text> &lt;</xsl:text>
              <xsl:element name="i">
                <xsl:value-of select="email"/>
              </xsl:element>
              <xsl:text>&gt; - </xsl:text>
            </xsl:if>

            <!-- Functions -->
            <xsl:for-each select="function">
              <xsl:if test="position()!=1">
                <xsl:text>, </xsl:text>
              </xsl:if>
              <xsl:variable name="function"><xsl:value-of select="."/></xsl:variable>
              <xsl:apply-templates select="/html/set/function[@id=$function]/node()"/>
              <xsl:if test="@country != ''">
                <xsl:text> </xsl:text>
                <xsl:variable name="country"><xsl:value-of select="@country"/></xsl:variable>
                <xsl:value-of select="/html/set/country[@id=$country]"/>
              </xsl:if>
              <xsl:if test="@project != ''">
                <xsl:text> </xsl:text>
                <xsl:variable name="project"><xsl:value-of select="@project"/></xsl:variable>
                <xsl:element name="a">
                  <xsl:attribute name="href">
                    <xsl:value-of select="/html/set/project[@id=$project]/link"/>
                  </xsl:attribute>
                  <xsl:value-of select="/html/set/project[@id=$project]/title"/>
                </xsl:element>
              </xsl:if>
              <xsl:if test="@volunteers != ''">
                <xsl:text> </xsl:text>
                <xsl:variable name="volunteers"><xsl:value-of select="@volunteers"/></xsl:variable>
                <xsl:apply-templates select="/html/set/volunteers[@id=$volunteers]/node()"/>
              </xsl:if>
            </xsl:for-each>

          </xsl:element>
        </xsl:element>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <!-- Do not copy <set> to output at all -->
  <xsl:template match="set"/>

  <!-- For all other nodes, copy verbatim -->
  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
