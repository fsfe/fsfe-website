<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../../fsfe.xsl" />

  <!--define dynamic list of country news items-->
    <xsl:template match="country-news">
        <xsl:call-template name="fetch-news">
            <xsl:with-param name="nb-items" select="3" />
        </xsl:call-template>
    </xsl:template>

    <!--define dynamic list of country event items-->
    <xsl:template match="country-events">
        <xsl:call-template name="fetch-events">
            <xsl:with-param name="nb-items" select="3" />
        </xsl:call-template>
    </xsl:template>

</xsl:stylesheet>
