<?xml version="1.0" encoding="UTF-8"?>

<!-- ====================================================================== -->
<!-- Display a prefabricated module from global/data/modules                -->
<!-- ====================================================================== -->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="module">
    <xsl:variable name="id"><xsl:value-of select="@id"/></xsl:variable>
    <xsl:apply-templates select="/buildinfo/document/set/module[@filename=$id]/node()" />
  </xsl:template>
</xsl:stylesheet>
