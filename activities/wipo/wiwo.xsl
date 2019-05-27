<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../../fsfe.xsl" />
  <xsl:output method="html" encoding="utf-8" indent="yes" doctype-system="about:legacy-compat" />

  <xsl:template match="signatories">
    <h3 id="organisations">
      <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'osig'" /></xsl:call-template>
    </h3>
    <ul>
      <xsl:apply-templates select="/buildinfo/document/set/osig/node()" />
    </ul>

    <h3 id="individuals">
      <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'isig'" /></xsl:call-template>
    </h3>
    <ul>
      <xsl:apply-templates select="/buildinfo/document/set/isig/node()" />
    </ul>
  </xsl:template>

</xsl:stylesheet>
