<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template name="body_scripts">
    <script src="{$urlprefix}/scripts/bootstrap-3.0.3.custom.js"></script>

    <xsl:if test="$build-env = 'development'">
      <xsl:element name="script">
        <xsl:attribute name="src"><xsl:value-of select="$urlprefix"/>/scripts/less.min.js</xsl:attribute>
      </xsl:element>

    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
