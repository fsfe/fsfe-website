<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [<!ENTITY nbsp "&#160;">]>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="/softliste/software">
<TR>
<TD><b><xsl:value-of select="name" /></b><br />(<xsl:value-of select="date" />)</TD>
<TD><xsl:value-of select="description[@lang=$lang]" /></TD>
<TD><a href="{url}"><xsl:value-of select="url" /></a></TD>
</TR>
  </xsl:template>



</xsl:stylesheet>
