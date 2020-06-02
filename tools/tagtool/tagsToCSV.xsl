<?xml version="1.0" encoding="UTF-8"?>
<!-- create a csv file from the aggregated tags files in tags/
	
Usage to find duplicate tags:
xsltproc tools/tagtool/tagsToCSV.xsl tags/.tags.en.xml |sort
/-->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dt="http://xsltsl.org/date-time">
  <xsl:output method="text"
              encoding="utf-8"
              indent="yes"
              doctype-system="about:legacy-compat" />
  <xsl:template match="/">action;name;id;section;count
<xsl:for-each select="tagset/tag">
;<xsl:value-of select='.'/>;<xsl:value-of select='@key'/>;<xsl:value-of select='@section'/>;<xsl:value-of select='@count'/></xsl:for-each>;
 </xsl:template>
</xsl:stylesheet>
