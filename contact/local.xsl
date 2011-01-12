<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="UTF-8" indent="yes" />

  <!-- Fill dynamic content -->
  <xsl:template match="dynamic-content">
    <xsl:for-each select="/html/set/contact">
      <xsl:sort select="@id" />

      <xsl:variable name="country">
        <xsl:value-of select="@id" />
      </xsl:variable>

      <!-- Heading -->
      <xsl:element name="h3">
        <xsl:value-of select="/html/set/country[@id=$country]" />
      </xsl:element>

      <!-- Address -->
      <xsl:if test="address != ''">
      <xsl:apply-templates select="address"/>
      </xsl:if>

      <!-- Email -->
      <xsl:if test="email != ''">
        <xsl:element name="p">
          <xsl:value-of select="/html/text[@id='email']" />
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
          <xsl:value-of select="/html/text[@id='phone']" />
          <xsl:text> </xsl:text>
          <xsl:value-of select="phone" />
        </xsl:element>
      </xsl:if>

      <!-- Fax -->
      <xsl:if test="fax != ''">
        <xsl:element name="p">
          <xsl:value-of select="/html/text[@id='fax']" />
          <xsl:text> </xsl:text>
          <xsl:value-of select="fax" />
        </xsl:element>
      </xsl:if>

      <!-- Core team members -->
      <xsl:element name="p">
        <xsl:choose>
          <xsl:when test="count(/html/set/person[count(country[text()=$country])>0 and string(@teams)])>0">
            <xsl:value-of select="/html/text[@id='members']" />
            <xsl:text> </xsl:text>
            <xsl:for-each select="/html/set/person[count(country[text()=$country])>0 and string(@teams)]">
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
            <xsl:value-of select="/html/text[@id='nomembers']" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:element>

    </xsl:for-each>
  </xsl:template>

  <!-- Do not copy <set> and <text> to output at all -->
  <xsl:template match="set" />
  <xsl:template match="text" />

  <!-- For all other nodes, copy verbatim -->
  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
