<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../fsfe.xsl" />
  <xsl:output method="html" encoding="utf-8" indent="yes" doctype-system="about:legacy-compat" />

  <!-- Fill dynamic content -->
  <xsl:template match="dynamic-content">
    <xsl:for-each select="/buildinfo/document/set/contact">
      <xsl:sort select="@id" />

      <xsl:variable name="country">
        <xsl:value-of select="@id" />
      </xsl:variable>

      <!-- Heading -->
      <h2>
        <xsl:call-template name="generate-id-attribute" />
        <xsl:choose>
            <xsl:when test="homepage != ''">
                <xsl:element name="strong">
                  <xsl:element name="a">
                    <xsl:attribute name="href">
                      <xsl:value-of select="homepage" />
                    </xsl:attribute>
                    <xsl:value-of select="/buildinfo/document/set/country[@id=$country]" />
                  </xsl:element>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="/buildinfo/document/set/country[@id=$country]" />
            </xsl:otherwise>
        </xsl:choose>
      </h2>

      <!-- Address -->
      <xsl:if test="address != ''">
        <xsl:apply-templates select="address"/>
      </xsl:if>

      <!-- Email -->
      <xsl:if test="email != ''">
        <xsl:element name="p">
          <xsl:value-of select="/buildinfo/document/text[@id='email']" />
          <xsl:text> </xsl:text>
          <xsl:element name="a">
            <xsl:attribute name="href">
              <xsl:text>mailto:</xsl:text>
              <xsl:value-of select="email" />
            </xsl:attribute>
            <xsl:value-of select="email" />
          </xsl:element>
        </xsl:element>
      </xsl:if>

      <!-- Phone -->
      <xsl:if test="phone != ''">
        <xsl:element name="p">
          <xsl:value-of select="/buildinfo/document/text[@id='phone']" />
          <xsl:text> </xsl:text>
          <xsl:value-of select="phone" />
        </xsl:element>
      </xsl:if>

      <!-- Fax -->
      <xsl:if test="fax != ''">
        <xsl:element name="p">
          <xsl:value-of select="/buildinfo/document/text[@id='fax']" />
          <xsl:text> </xsl:text>
          <xsl:value-of select="fax" />
        </xsl:element>
      </xsl:if>

      <!-- Core team members -->
      <!--xsl:element name="p">
        <xsl:choose>
          <xsl:when test="count(/buildinfo/document/set/person[count(country[text()=$country])>0 and contains(@teams, 'main')])>0">
            <xsl:value-of select="/buildinfo/document/text[@id='members']" />
            <xsl:text> </xsl:text>
            <xsl:for-each select="/buildinfo/document/set/person[count(country[text()=$country])>0 and contains(@teams, 'main')]">
              <xsl:if test="position()!=1">
                <xsl:text>, </xsl:text>
              </xsl:if>
              <xsl:choose>
                <xsl:when test="link != ''">
                  <xsl:element name="a">
                    <xsl:attribute name="href">
                  <xsl:value-of select="link" />
                    </xsl:attribute>
                    <xsl:value-of select="name" />
                  </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="name" />
                </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="/buildinfo/document/text[@id='nomembers']" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:element-->

    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
