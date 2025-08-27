<?xml version="1.0" encoding="UTF-8"?>
<!-- ====================================================================== -->
<!-- Display a prefabricated module from global/data/modules                -->
<!-- ====================================================================== -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:template match="module">
    <xsl:variable name="id">
      <xsl:value-of select="@id"/>
    </xsl:variable>
    <xsl:apply-templates select="/buildinfo/document/set/module[@filename=$id]/node()"/>
  </xsl:template>
</xsl:stylesheet>
