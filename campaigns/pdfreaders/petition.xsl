<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:import href="../../tools/xsltsl/countries.xsl" />
	
  <xsl:import href="../../fsfe.xsl" />
  <xsl:output method="html" encoding="utf-8" indent="yes" doctype-system="about:legacy-compat" />

  <xsl:template match="/buildinfo/document/body/include-signatures">
      <xsl:apply-templates />
      
      <h3 id="organisations">
        <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'osig'" /></xsl:call-template>
        (<xsl:value-of select="count(/buildinfo/document/set/osig/li)" />)
      </h3>
      <ul>
        <xsl:apply-templates select="/buildinfo/document/set/osig/node()">
          <xsl:sort select="." />
        </xsl:apply-templates>
      </ul>
      
      <h3 id="businesses">
      	<xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'bsig'" /></xsl:call-template>
      	(<xsl:value-of select="count(/buildinfo/document/set/bsig/li)" />)
      </h3>
      <ul>
        <xsl:apply-templates select="/buildinfo/document/set/bsig/node()">
          <xsl:sort select="." />
        </xsl:apply-templates>
      </ul>
      
      <h3 id="individuals">
        <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'isig'" /></xsl:call-template>
        (<xsl:value-of select="count(/buildinfo/document/set/isig/li)" />)
      </h3>
      <ul>
        <xsl:apply-templates select="/buildinfo/document/set/isig/node()">
          <xsl:sort select="." />
        </xsl:apply-templates>
      </ul>
      <xsl:apply-templates select="/buildinfo/document/text/footer/node()" />
  </xsl:template>
  
  <xsl:template match="country-list">
    <xsl:call-template name="country-list" />
  </xsl:template>
  
  <!-- Add a hidden field to the form to identify the language used. -->
  <xsl:template match="add-language">
    <xsl:element name="input">
      <xsl:attribute name="type">hidden</xsl:attribute>
      <xsl:attribute name="id">lang</xsl:attribute>
      <xsl:attribute name="name">lang</xsl:attribute>
      <xsl:attribute name="value">
        <xsl:value-of select="/buildinfo/document/@language" />
      </xsl:attribute>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
