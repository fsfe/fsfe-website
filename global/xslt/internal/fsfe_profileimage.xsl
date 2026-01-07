<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:template name="profileimage" match="profileimage">
    <xsl:param name="info" select="@info"/>
    <xsl:param name="src" select="@src"/>
    <xsl:param name="alt" select="@alt"/>
    <xsl:param name="ccby" select="@ccby"/>
    <xsl:param name="cczero" select="@cczero"/>
    <xsl:param name="ccbysa" select="@ccbysa"/>
    <xsl:param name="cclink" select="@cclink"/>
    <xsl:param name="title" select="@title"/>
    <xsl:element name="figure">
        <xsl:attribute name="class">image</xsl:attribute>
        <!-- the image -->
        <xsl:element name="img">
            <xsl:attribute name="src"><xsl:value-of select="$src"/></xsl:attribute>
            <xsl:if test="$alt">
                <xsl:attribute name="alt"><xsl:value-of select="$alt"/></xsl:attribute>
                <xsl:attribute name="title">
                    <xsl:choose>
                        <xsl:when test="$title">
                            <xsl:value-of select="$title"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$alt"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
            </xsl:if>
        </xsl:element>
        <!-- caption of the image -->
        <xsl:element name="figcaption">
            <xsl:choose>
                <!-- CC BY License -->
                <xsl:when test="$ccby">
                    <xsl:element name="span">
                        <xsl:attribute name="href">http://purl.org/dc/dcmitype/StillImage</xsl:attribute>
                        <xsl:attribute name="property">dct:title</xsl:attribute>
                        <xsl:attribute name="rel">dct:type</xsl:attribute>
                        <!-- now the text -->
                        <xsl:text>This image by </xsl:text>
                        <xsl:element name="a">
                            <xsl:attribute name="href"><xsl:value-of select="$cclink" /></xsl:attribute>
                            <xsl:attribute name="property">cc:attributionName</xsl:attribute>
                            <xsl:attribute name="rel">cc:attributionURL</xsl:attribute>
                            <xsl:value-of select="$ccby" />
                        </xsl:element>
                        <xsl:text> is licensed under a </xsl:text>
                        <xsl:element name="a">
                            <xsl:attribute name="rel">license</xsl:attribute>
                            <xsl:attribute name="href">https://creativecommons.org/licenses/by/4.0/</xsl:attribute>
                            Creative Commons Attribution 4.0 International License
                        </xsl:element>
                        <xsl:text>.</xsl:text>
                    </xsl:element>
                </xsl:when>
                <!-- CC BY SA License -->
                <xsl:when test="$ccby">
                    <xsl:element name="span">
                        <xsl:attribute name="href">http://purl.org/dc/dcmitype/StillImage</xsl:attribute>
                        <xsl:attribute name="property">dct:title</xsl:attribute>
                        <xsl:attribute name="rel">dct:type</xsl:attribute>
                        <!-- now the text -->
                        <xsl:text>This image by </xsl:text>
                        <xsl:element name="a">
                            <xsl:attribute name="href"><xsl:value-of select="$cclink" /></xsl:attribute>
                            <xsl:attribute name="property">cc:attributionName</xsl:attribute>
                            <xsl:attribute name="rel">cc:attributionURL</xsl:attribute>
                            <xsl:value-of select="$ccbysa" />
                        </xsl:element>
                        <xsl:text> is licensed under a </xsl:text>
                        <xsl:element name="a">
                            <xsl:attribute name="rel">license</xsl:attribute>
                            <xsl:attribute name="href">https://creativecommons.org/licenses/by-sa/4.0/</xsl:attribute>
                            Creative Commons Attribution-ShareAlike 4.0 International License
                        </xsl:element>
                        <xsl:text>.</xsl:text>
                    </xsl:element>
                </xsl:when>
                <!-- CC Zero License -->
                <xsl:when test="$ccby">
                    <xsl:element name="span">
                        <xsl:attribute name="href">http://purl.org/dc/dcmitype/StillImage</xsl:attribute>
                        <xsl:attribute name="property">dct:title</xsl:attribute>
                        <xsl:attribute name="rel">dct:type</xsl:attribute>
                        <!-- now the text -->
                        <xsl:text>This image by </xsl:text>
                        <xsl:element name="a">
                            <xsl:attribute name="href"><xsl:value-of select="$cclink" /></xsl:attribute>
                            <xsl:attribute name="property">cc:attributionName</xsl:attribute>
                            <xsl:attribute name="rel">cc:attributionURL</xsl:attribute>
                            <xsl:value-of select="$cczero" />
                        </xsl:element>
                        <xsl:text> is licensed under a </xsl:text>
                        <xsl:element name="a">
                            <xsl:attribute name="rel">license</xsl:attribute>
                            <xsl:attribute name="href">https://creativecommons.org/publicdomain/zero/1.0/</xsl:attribute>
                            Creative Commons CC0 1.0 Universal
                        </xsl:element>
                        <xsl:text>.</xsl:text>
                    </xsl:element>
                </xsl:when>
                <!-- Use the info supplied-->
                <xsl:when test="$info">
                    <xsl:value-of select="$info"/>
                </xsl:when>
                <xsl:otherwise>
                    <!-- else use default information -->
                    <xsl:text>This image is not covered by the CC-BY-SA license, all rights reserved.</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>