<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.0'>

<xsl:output
	encoding="ISO-8859-1"
	method="xml"
	omit-xml-declaration="no"
	doctype-public="-//OASIS//DTD DocBook XML V4.1.2//EN"
	doctype-system="http://www.oasis-open.org/docbook/xml/4.0/docbookx.dtd"
	/>

<!--
<xsl:template match="node()|/">
-->

<xsl:template match="*|/">
    <xsl:copy>
        <xsl:copy-of select="@*"/>
	<xsl:apply-templates/>
    </xsl:copy>
</xsl:template>

<xsl:template match="*[@condition='long']">
</xsl:template>

</xsl:stylesheet>

