<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dt="http://xsltsl.org/date-time"
  exclude-result-prefixes="dt">

  <xsl:output method="xml" encoding="UTF-8" indent="yes" />

  <!-- Do not copy non-HTML elements to output -->
  <xsl:template match="timestamp|
               buildinfo/document/translator|
               buildinfo/set|
               buildinfo/textset|
               buildinfo/textsetbackup|
               buildinfo/menuset|
               buildinfo/trlist|
               buildinfo/fundraising|
               buildinfo/localmenuset|
               buildinfo/document/tags|
               buildinfo/document/legal|
               buildinfo/document/author|
               buildinfo/document/date|
               buildinfo/document/download|
               buildinfo/document/followup"/>

  <xsl:template match="set | tags | text"/>

  <!-- For all other nodes, copy verbatim -->
  <!-- xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template -->

</xsl:stylesheet>
