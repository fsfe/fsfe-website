<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:import href="../../tools/xsltsl/countries.xsl" />
	
  <xsl:output method="xml"
           encoding="UTF-8"
           indent="yes"
           />

  <xsl:template match="/">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="/html/body">
    <body>
      <xsl:apply-templates />
      
      <h3>
        <xsl:value-of select="/html/text[@id='osig']" />
        (<xsl:value-of select="count(/html/set/osig/li)" />)
      </h3>
      <ul>
        <xsl:apply-templates select="/html/set/osig/node()">
          <xsl:sort select="." />
        </xsl:apply-templates>
      </ul>
      
      <h3>
      	<xsl:value-of select="/html/text[@id='bsig']" />
      	(<xsl:value-of select="count(/html/set/bsig/li)" />)
      </h3>
      <ul>
        <xsl:apply-templates select="/html/set/bsig/node()">
          <xsl:sort select="." />
        </xsl:apply-templates>
      </ul>
      
      <h3>
        <xsl:value-of select="/html/text[@id='isig']" />
        (<xsl:value-of select="count(/html/set/isig/li)" />)
      </h3>
      <ul>
        <xsl:apply-templates select="/html/set/isig/node()">
          <xsl:sort select="." />
        </xsl:apply-templates>
      </ul>
      <xsl:apply-templates select="/html/text/footer/node()" />
    </body>
  </xsl:template>
  
  <xsl:template match="country-list">
    <xsl:call-template name="country-list">
      <xsl:with-param name="lang" select="/html/@lang" />
    </xsl:call-template>
  </xsl:template>

  <!-- Add a hidden field to the form to identify the language used. -->
  <xsl:template match="add-language">
    <xsl:element name="input">
      <xsl:attribute name="type">hidden</xsl:attribute>
      <xsl:attribute name="id">lang</xsl:attribute>
      <xsl:attribute name="name">lang</xsl:attribute>
      <xsl:attribute name="value">
        <xsl:value-of select="/html/@lang" />
      </xsl:attribute>
    </xsl:element>
  </xsl:template>

  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="/html/set" />
  <xsl:template match="/html/text" />
</xsl:stylesheet>
