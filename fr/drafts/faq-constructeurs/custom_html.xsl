<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		version='1.0'
		xmlns="http://www.w3.org/TR/xhtml1/transitional"
		exclude-result-prefixes="#default">

<!-- Import of the stylesheet to customize -->
<!-- Local install -->
<!-- <xsl:import href="/usr/local/docbook-xsl/html/docbook.xsl"/> -->
<!-- Debian install -->
<xsl:import href="/usr/share/sgml/docbook/stylesheet/xsl/nwalsh/html/docbook.xsl"/>


<!-- HTML output will use the given stylesheet -->
<xsl:param name="html.stylesheet">lightNLegible.css</xsl:param>

<!--
<xsl:param name="css.decoration" doc:type="boolean">1</xsl:param>
<xsl:variable name="toc.section.depth">3</xsl:variable>
-->

</xsl:stylesheet>

