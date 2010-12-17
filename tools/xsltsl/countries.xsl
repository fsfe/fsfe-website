<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml"
                encoding="UTF-8"
                indent="yes" />
    
    <xsl:variable name="path-for-avatars" select="'/home/www/fsfe'" />
    
    <xsl:template name="country-people-list">
        <xsl:param name="countryteam" select="''" />
        
        <xsl:element name="ul">
            <xsl:attribute name="class">people</xsl:attribute>
            <xsl:for-each select="/html/set/person[@countryteam=$countryteam or $countryteam='']">
                <xsl:sort select="@id" />
                
                <xsl:variable name="id" select="@id" />
                
                <xsl:element name="li">
                    <xsl:element name="p">
                        <!-- Picture -->
                        <xsl:choose>
                            <xsl:when test="link != ''">
                                <xsl:element name="a">
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="link" />
                                    </xsl:attribute>
                                    <xsl:element name="img">
                                        <xsl:attribute name="alt">
                                            <xsl:value-of select="name" />
                                        </xsl:attribute>
                                        <xsl:attribute name="src">
                                            <xsl:variable name="img-path" select="string(concat($path-for-avatars, '/about/', $id, '/', $id, '-avatar.jpg'))" />
                                            <xsl:choose>
                                                <xsl:when test="boolean(document($img-path))">
                                                    <xsl:value-of select="$img-path" />
                                                </xsl:when>
                                                <xsl:otherwise>/graphics/default-avatar.png</xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:attribute>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="img">
                                    <xsl:attribute name="alt">
                                        <xsl:value-of select="name" />
                                    </xsl:attribute>
                                    <xsl:attribute name="src">
                                        <xsl:value-of select="avatar" />
                                    </xsl:attribute>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                        <!-- Name; if link is given show as link -->
                        <xsl:element name="span">
                            <xsl:attribute name="class">
                            name</xsl:attribute>
                            <xsl:choose>
                                <xsl:when test="link != ''">
                                    <xsl:element name="a">
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="link" />
                                        </xsl:attribute>
                                        <xsl:value-of select="name" />
                                    </xsl:element>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="name" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:element>
                        <!-- E-mail -->
                        <xsl:element name="span">
                            <xsl:attribute name="class">
                            email</xsl:attribute>
                            <xsl:if test="email != ''">
                                <xsl:value-of select="email" />
                            </xsl:if>
                        </xsl:element>
                        <!-- Functions -->
                        <xsl:for-each select="function">
                            <xsl:if test="position()!=1">
                                <xsl:text>
, 
</xsl:text>
                            </xsl:if>
                            <xsl:variable name="function">
                                <xsl:value-of select="." />
                            </xsl:variable>
                            <xsl:apply-templates select="/html/set/function[@id=$function]/node()" />
                            <xsl:if test="@country != ''">
                                <xsl:text>
 
</xsl:text>
                                <xsl:variable name="country">
                                    <xsl:value-of select="@country" />
                                </xsl:variable>
                                <xsl:value-of select="/html/set/country[@id=$country]" />
                            </xsl:if>
                            <xsl:if test="@project != ''">
                                <xsl:text>
 
</xsl:text>
                                <xsl:variable name="project">
                                    <xsl:value-of select="@project" />
                                </xsl:variable>
                                <xsl:element name="a">
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="/html/set/project[@id=$project]/link" />
                                    </xsl:attribute>
                                    <xsl:value-of select="/html/set/project[@id=$project]/title" />
                                </xsl:element>
                            </xsl:if>
                            <xsl:if test="@volunteers != ''">
                                <xsl:text>
 
</xsl:text>
                                <xsl:variable name="volunteers">
                                    <xsl:value-of select="@volunteers" />
                                </xsl:variable>
                                <xsl:apply-templates select="/html/set/volunteers[@id=$volunteers]/node()" />
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:element>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
