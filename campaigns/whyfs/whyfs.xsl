<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../fsfe.xsl" />
  <xsl:output method="html" encoding="utf-8" indent="yes" doctype-system="about:legacy-compat" />

  <xsl:template match="speakers">
    <xsl:copy-of select="/buildinfo/document/set/table" />
  </xsl:template>
</xsl:stylesheet>

