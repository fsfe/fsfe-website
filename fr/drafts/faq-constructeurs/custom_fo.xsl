<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.0'>

<!-- Import of the stylesheet to customize -->
<!-- Local install -->
<!-- <xsl:import href="/usr/local/docbook-xsl/fo/docbook.xsl"/> -->
<!-- Debian install -->
<xsl:import href="/usr/share/sgml/docbook/stylesheet/xsl/nwalsh/fo/docbook.xsl"/>


<xsl:param name="paper.type" select="'A4'"/>

<xsl:param name="page.orientation" select="'portrait'"/>

<xsl:param name="section.autolabel" select="1"/>

<!-- Enabling all extensions -->
<!--
<xsl:param name="use.extensions" select="1"/>
-->
<!-- Using fop or passivetex extensions to produce bookmarks for PDF output -->
<!-- fop.extensions produce buggy outputs for now... -->
<!--
<xsl:param name="fop.extensions" select="1"/>
-->
<!-- ...and i18n problems with passivetex.extensions :-( -->
<!--
<xsl:param name="passivetex.extensions" select="1"/>
-->


</xsl:stylesheet>

