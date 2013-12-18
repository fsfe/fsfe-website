<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="/fellowship/default.xsl" />
  <xsl:output method="html" encoding="utf-8" indent="yes"
    doctype-system="about:legacy-compat" />

  <xsl:template match="body">
    <div id="fellowship">
      <xsl:apply-templates />
    </div>
  </xsl:template>
</xsl:stylesheet>

