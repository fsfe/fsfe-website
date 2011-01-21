<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="ISO-8859-1" indent="yes"/>

  <!-- Fill dynamic content -->
  <xsl:template match="dynamic-content">
    <xsl:element name="ul">
      <xsl:for-each select="/html/set/person[@association-member='yes']">
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
              <xsl:text>&gt;</xsl:text>
            </xsl:if>

          </xsl:element>
        </xsl:element>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <!-- Do not copy <set> or <text> to output at all -->
  <xsl:template match="set | tags"/>

  <!-- For all other nodes, copy verbatim -->
  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
