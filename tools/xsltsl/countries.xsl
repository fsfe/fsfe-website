<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="UTF-8" indent="yes" />
  
  <!-- displays list of people for a given country (or a given team, i.e. "main") -->
  <xsl:template name="country-people-list">
      <xsl:param name="team"
                 select="''" />
      <!-- parameter 'team' is your country code -->
      
      <xsl:param name="display" select="''" />
      <!-- parameter 'display' can limit the shown people to coordinators -->
      
      <xsl:variable name="teamcomma"><xsl:value-of select="$team" />,</xsl:variable>
      <xsl:variable name="commateam">, <xsl:value-of select="$team" /></xsl:variable>
      
      <xsl:element name="ul">
          <xsl:attribute name="class">people</xsl:attribute>
          <xsl:for-each select="/buildinfo/document/set/person[team = $team or $team = '']">
                                                
              <xsl:sort select="@id" />
              <xsl:variable name="id" select="@id" />
              
              <!-- check whether person is a (deputy) coordinator -->
              <xsl:variable name="isCoordinator">
                <xsl:for-each select="function">
                  <xsl:variable name="function">
                    <xsl:value-of select="." />
                  </xsl:variable>
                  <!-- prepare translation pattern to lower-case country/team/whatever attribute value -->
                  <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
                  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
                  <xsl:choose>
                    <!-- check whether is coord/deputy of the given country/group/team... -->
                    <!-- we have to lower-case here because country attributes are written in uppercase -->
                    <xsl:when test="translate(@*, $uppercase, $smallcase) = translate($team, $uppercase, $smallcase) and (contains($function, 'coordinator') or contains($function, 'deputy'))">
                      <xsl:text>yes</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                      <!-- if person isn't a coordinator, the variable $isCoordinator is left blank --> 
                      <xsl:text></xsl:text>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:for-each>
              </xsl:variable>
              
              <!-- only list if there is no display limitation set, or if person matches this criteria -->
              <xsl:if test="$display = '' or ($display = 'coordinators' and $isCoordinator = 'yes')">
                <xsl:element name="li">
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
                                  
                                  <xsl:element name="img">
                              <xsl:attribute name="alt"><xsl:value-of select="name" /></xsl:attribute>
                              <xsl:attribute name="src"><xsl:value-of select="avatar" /></xsl:attribute>
                                  </xsl:element>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>

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
                          <xsl:if test="@group != ''">
                              <xsl:text> </xsl:text>
                              <xsl:variable name="group">
                                  <xsl:value-of select="@group" />
                              </xsl:variable>
                              <xsl:value-of select="/buildinfo/document/set/group[@id=$group]" />
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
                      
                      <!-- Employee status for transparency reasons-->
                      <!-- TODO: I (hugo) did this, so there s probably room for improvement -->
                      <xsl:for-each select="employee">
                          <xsl:element name="span">
                              <xsl:choose>
                                  <xsl:when test="substring-before( . , '/') = 'full'">
                                      <xsl:attribute name="class">employee full</xsl:attribute>
                                  </xsl:when>
                                  <xsl:when test="substring-before( . , '/') = 'part'">
                                      <xsl:attribute name="class">employee part</xsl:attribute>
                                  </xsl:when>
                                  <xsl:when test="substring-before( . , '/') = 'freelancer'">
                                      <xsl:attribute name="class">employee freelancer</xsl:attribute>
                                  </xsl:when>
                                  <xsl:when test="substring-before( . , '/') = 'intern'">
                                      <xsl:attribute name="class">employee intern</xsl:attribute>
                                  </xsl:when>
                                  <xsl:otherwise></xsl:otherwise>
                              </xsl:choose>
                              <xsl:variable name="employee">
                                  <xsl:value-of select="." />
                              </xsl:variable>
                              <xsl:apply-templates select="/buildinfo/document/set/employee[@id=$employee]/node()" />
                          </xsl:element>
                      </xsl:for-each>
                      <!-- / employee status -->
                      
                    </xsl:element>
                    
                </xsl:element> <!-- /li -->
            </xsl:if>
          </xsl:for-each>
      </xsl:element>
  </xsl:template>
  
  <!-- showing a dropdown select menu with all countries in /tools/countries.**.xml -->
  <xsl:template name="country-list">
    <xsl:param name="required" select="'no'" />
    <xsl:param name="class" select="''" />
    <xsl:element name="select">
      <xsl:attribute name="id">country</xsl:attribute>
      <xsl:attribute name="name">country</xsl:attribute>
      <!-- if called with a "class" value, set it as the CSS class --> 
      <xsl:choose>
        <xsl:when test="$class != ''">
          <xsl:attribute name="class"><xsl:value-of select="$class" /></xsl:attribute>
        </xsl:when>
      </xsl:choose>
      <!-- when called with the required="yes" param, add the attribute 
      and an empty option -->
      <xsl:choose>
        <xsl:when test="$required = 'yes'">
          <xsl:attribute name="required">required</xsl:attribute>
          <option></option> <!-- this will force people to pick a choice actively -->
        </xsl:when>
      </xsl:choose>
      <!-- loop over all countries in countries.**.xml -->
      <xsl:for-each select="/buildinfo/document/set/country">
        <xsl:sort select="." lang="en" />
        <!-- will output: <option value="ZZ">Fooland</option> -->
        <xsl:element name="option">
          <xsl:attribute name="value">
            <xsl:value-of select="@id" />|<xsl:value-of select="." />
          </xsl:attribute>
          <xsl:value-of select="." />
        </xsl:element>  <!-- /option -->
      </xsl:for-each>
    </xsl:element> <!-- /select -->
  </xsl:template>
  
  <!-- please note that there is also a country list ordered by continent (Europe or not) in static-elements.xsl -->
  
</xsl:stylesheet>
