<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		version='1.0'
		xmlns="http://www.w3.org/TR/xhtml1/transitional"
		exclude-result-prefixes="#default">

<!-- Import of the stylesheet to customize -->
<xsl:import href="/usr/share/sgml/docbook/stylesheet/xsl/nwalsh/html/docbook.xsl"/>


<!-- HTML output will use the given stylesheet -->
<xsl:param name="html.stylesheet">lightNLegible.css</xsl:param>

<!--
<xsl:param name="css.decoration" doc:type="boolean">1</xsl:param>
<xsl:variable name="toc.section.depth">3</xsl:variable>
-->

<!-- Do not output nodes having a condition attribute equal to "long" -->
<!-- This is put into action because it causes problem with toc generation  -->
<!--
<xsl:template match="*">
    <xsl:if test="@condition!='long' or not(@condition)">
        <xsl:apply-imports/>
    </xsl:if>
</xsl:template>
-->

</xsl:stylesheet>

