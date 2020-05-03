<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Do not copy non-HTML elements to output -->
  <xsl:template match="
               buildinfo/document/translator|
               buildinfo/set|
               buildinfo/textset|
               buildinfo/textsetbackup|
               buildinfo/menuset|
               buildinfo/trlist|
               buildinfo/fundraising|
               buildinfo/localmenuset|
               buildinfo/document/legal|
               buildinfo/document/author|
               buildinfo/document/date|
               buildinfo/document/download|
               buildinfo/document/followup"/>

  <!-- For all other nodes, copy verbatim -->
  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
