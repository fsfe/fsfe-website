<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.0'>

<xsl:output
	encoding="ISO-8859-1"
	method="xml"
	omit-xml-declaration="no"
	doctype-public="-//OASIS//DTD DocBook XML V4.1.2//EN"
	doctype-system="http://www.oasis-open.org/docbook/xml/4.1.2/docbookx.dtd"
	/>


<!--
<xsl:template match="node()|/">
-->

<xsl:template match="*|/">
    <xsl:copy>
	<!-- 
	Copy all attribute nodes of current element.
	-->
        <xsl:copy-of select="@*"/>
	<xsl:apply-templates/>
    </xsl:copy>
</xsl:template>


<!--
Does not copy other elements than article
<xsl:template match="*[name()!='article']">
</xsl:template>
-->

<!--
Does not copy para elements.
<xsl:template match="*[name()='para']">
</xsl:template>
-->

<!--
Does not copy elements with attribute 'condition' having the value 'long'.
<xsl:template match="*[@condition='long']">
</xsl:template>
-->

<!--
Does not copy elements with an attribute 'condition'
and this attribute having another value than 'short'.
-->
<xsl:template match="*[@condition and @condition!='short']">
</xsl:template>


</xsl:stylesheet>

