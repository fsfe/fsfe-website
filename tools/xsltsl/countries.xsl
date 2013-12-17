<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:import href="feeds.xsl" />
    <xsl:output method="xml" encoding="UTF-8" indent="yes" />
    
    <!-- displays list of people for a given country (or a given team, i.e. "main") -->
    <xsl:template name="country-people-list">
        <xsl:param name="team"
                   select="''" />
        <!-- parameter 'team' is your country code -->
        
        <xsl:variable name="teamcomma"><xsl:value-of select="$team" />,</xsl:variable>
        <xsl:variable name="commateam">, <xsl:value-of select="$team" /></xsl:variable>
        
        <xsl:element name="ul">
            <xsl:attribute name="class">people</xsl:attribute>
            <xsl:for-each select="/buildinfo/document/set/person[
                                    contains(@teams, $commateam) or
                                    contains(@teams, $teamcomma) or
                                    @teams=$team or
                                    $team='']"> 
                
                <xsl:sort select="@id" />
                <xsl:variable name="id"
                              select="@id" />

<!--                <xsl:variable name="avatar" select="@avatar" />-->

                <xsl:element name="li">
					<!-- background color depending from employee status -->
					<xsl:choose>
						<xsl:when test="employee = 'full'">
							<xsl:attribute name="style">background-color: #BEF5BE</xsl:attribute>
						</xsl:when>
						<xsl:when test="employee = 'part'">
							<xsl:attribute name="style">background-color: #E4F7E4</xsl:attribute>
                        </xsl:when>
                        <xsl:when test="employee = 'fee'">
							<xsl:attribute name="style">background-color: #EFF2FB</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
						</xsl:otherwise>
					</xsl:choose>
					<!-- /background color --> 
                    
                    <xsl:element name="p">
                        <!-- Picture -->
                        <xsl:choose>
                                <xsl:when test="avatar">
                                        <xsl:choose>
                                            <xsl:when test="link != ''">
                                                <xsl:element name="a">
                                                    <xsl:attribute name="href">
                                                        <xsl:value-of select="link" />
                                                    </xsl:attribute>
                                                    
                <!--                                    <xsl:call-template name="avatar">-->
                <!--                                     <xsl:with-param name="id" select="$id" />-->
                <!--                                     <xsl:with-param name="haveavatar" select="$avatar" />-->
                <!--                                    </xsl:call-template>-->
                                                        <xsl:element name="img">
															<xsl:attribute name="alt"><xsl:value-of select="name" /></xsl:attribute>
															<xsl:attribute name="src"><xsl:value-of select="avatar" /></xsl:attribute>
                                                        </xsl:element>
                                                </xsl:element>
                                            </xsl:when>
                                            <xsl:otherwise>

                <!--                                <xsl:call-template name="avatar">-->
                <!--                                 <xsl:with-param name="id" select="$id" />-->
                <!--                                 <xsl:with-param name="haveavatar" select="$avatar" />-->
                <!--                                </xsl:call-template>-->
                                                <xsl:element name="img">
                                                        <xsl:attribute name="alt"><xsl:value-of select="name" /></xsl:attribute>
                                                        <xsl:attribute name="src"><xsl:value-of select="avatar" /></xsl:attribute>
                                                </xsl:element>

                                            </xsl:otherwise>
                                        </xsl:choose>
                                </xsl:when>
                                <xsl:otherwise>
                                        <xsl:element name="img">
                                                <xsl:attribute name="alt"><xsl:value-of select="name" /></xsl:attribute>
                                                <xsl:attribute name="src">/graphics/default-avatar.png</xsl:attribute>
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

                        <!-- Association organisation name -->
                        <!-- not used
                        <xsl:if test="association != ''">
                        	<xsl:element name="span">
                                <xsl:value-of select="association" />
                            </xsl:element>
                        </xsl:if> -->

                        <!-- Functions -->
                        <xsl:for-each select="function">
                            <xsl:if test="position()!=1">
                                <xsl:text>, </xsl:text>
                            </xsl:if>
                            <xsl:variable name="function">
                                <xsl:value-of select="." />
                            </xsl:variable>
                            <xsl:apply-templates select="/buildinfo/document/set/function[@id=$function]/node()" />
                            <xsl:if test="@country != ''">
                                <xsl:text> </xsl:text>
                                <xsl:variable name="country">
                                    <xsl:value-of select="@country" />
                                </xsl:variable>
                                <xsl:value-of select="/buildinfo/document/set/country[@id=$country]" />
                            </xsl:if>
                            <xsl:if test="@project != ''">
                                <xsl:text> </xsl:text>
                                <xsl:variable name="project">
                                    <xsl:value-of select="@project" />
                                </xsl:variable>
                                <xsl:element name="a">
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="/buildinfo/document/set/project[@id=$project]/link" />
                                    </xsl:attribute>
                                    <xsl:value-of select="/buildinfo/document/set/project[@id=$project]/title" />
                                </xsl:element>
                            </xsl:if>
                            <xsl:if test="@volunteers != ''">
                                <xsl:text> </xsl:text>
                                <xsl:variable name="volunteers">
                                    <xsl:value-of select="@volunteers" />
                                </xsl:variable>
                                <xsl:apply-templates select="/buildinfo/document/set/volunteers[@id=$volunteers]/node()" />
                            </xsl:if>
                            <xsl:if test="@projects != ''">
                                <xsl:text> </xsl:text>
                                <xsl:variable name="projects">
                                    <xsl:value-of select="@projects" />
                                </xsl:variable>
                                <xsl:apply-templates select="/buildinfo/document/set/projects[@id=$projects]/node()" />
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:element>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    
    
    <xsl:template name="country-list">
			
			<select id="country" name="country">
				
				<xsl:for-each select="/buildinfo/document/set/country">
					<xsl:sort select="." lang="en" />
					
					<option><xsl:value-of select="." /></option>
					
				</xsl:for-each>
				
			</select>
			
    </xsl:template>
    
    <!-- please note that there is also a country list ordered by continent (Europe or not) in static-elements.xsl -->
    
</xsl:stylesheet>
