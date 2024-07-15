<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../fsfe.xsl" />

  <!-- Create the search form. Doing this this way to add translations for placeholders and such -->
  <xsl:template match="search-form">
    <xsl:element name="form">
      <xsl:attribute name="class">form-inline</xsl:attribute>
      <xsl:attribute name="method">GET</xsl:attribute>
      <xsl:attribute name="action"></xsl:attribute>

      <xsl:element name="div">
        <xsl:attribute name="class">form-group</xsl:attribute>
        <xsl:element name="input">
          <xsl:attribute name="type">text</xsl:attribute>
          <xsl:attribute name="class">form-control</xsl:attribute>
          <xsl:attribute name="id">search</xsl:attribute>
          <xsl:attribute name="name">q</xsl:attribute>
          <xsl:attribute name="aria-label">
            <xsl:call-template name="fsfe-gettext">
              <xsl:with-param name="id" select="'search/placeholder'" />
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name="placeholder">
            <xsl:call-template name="fsfe-gettext">
              <xsl:with-param name="id" select="'search/placeholder'" />
            </xsl:call-template>
          </xsl:attribute>
        </xsl:element> <!-- /input -->
      </xsl:element> <!-- /div -->

      <xsl:element name="button">
        <xsl:attribute name="type">submit</xsl:attribute>
        <xsl:attribute name="class">btn btn-primary</xsl:attribute>
          <xsl:call-template name="fsfe-gettext">
            <xsl:with-param name="id" select="'search'" />
          </xsl:call-template>
      </xsl:element> <!-- /button -->

    </xsl:element> <!-- /form -->
  </xsl:template>

  <!-- Run fsfe-gettext for a given id, can be used directly from the XML file -->
  <xsl:template match="translation">
    <xsl:variable name="id"><xsl:value-of select="@id"/></xsl:variable>
    <xsl:call-template name="fsfe-gettext">
      <xsl:with-param name="id" select="$id" />
    </xsl:call-template>
  </xsl:template>
</xsl:stylesheet>
