<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- displays list of people for a given country (or a given team, i.e. "main") -->
  <xsl:template name="country-people-list">
      <!-- parameter 'team' can be
        - a team (e.g. "core" or "athens")
        - multiple teams (e.g. "core,ga,council")
      -->
      <xsl:param name="team" select="''" />

      <!-- parameter 'display' can limit the shown people to coordinators -->
      <xsl:param name="display" select="''" />

      <!-- parameter 'extraclass' can set an additional class to div.people -->
      <xsl:param name="extraclass" select="''" />

      <!-- test if multiple teams are displayed, or only one -->
      <xsl:variable name="multiteam">
        <xsl:if test="contains($team, ',')">
          <xsl:text>yes</xsl:text>
        </xsl:if>
      </xsl:variable>

      <xsl:element name="div">
          <xsl:attribute name="class">
            <xsl:text>row people</xsl:text>
            <xsl:if test="$extraclass != ''">
              <xsl:text> </xsl:text>
              <xsl:value-of select="$extraclass" />
            </xsl:if>
          </xsl:attribute>
          <xsl:for-each select="/buildinfo/document/set/person">
              <xsl:sort select="@id" />
              <xsl:variable name="id" select="@id" />

              <!-- check whether person is in requested team -->
              <!-- TODO: This produces false-positives when among multiple teams the team "zurich" is requested, but person is only in "ch" -->
              <xsl:variable name="inthisteam">
                <xsl:for-each select="team">
                  <xsl:if test="($multiteam != 'yes' and $team = .) or ($multiteam = 'yes' and contains($team, .))">
                    <xsl:text>yes</xsl:text>
                  </xsl:if>
                </xsl:for-each>
              </xsl:variable>

              <!-- check whether person is a (deputy) coordinator of the requested team. Only works if $team is only one team -->
              <xsl:variable name="isCoordinator">
                <xsl:for-each select="function">
                  <xsl:variable name="function">
                    <xsl:value-of select="." />
                  </xsl:variable>
                  <!-- prepare translation pattern to lower-case country/team/whatever attribute value -->
                  <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
                  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
                  <!-- check whether is coord/deputy of the given country/group/team...
                  Notes:
                    - we have to lower-case here because country attributes are written in uppercase
                    - @* is the value of every attribute with the current function tag
                  -->
                  <xsl:if test="translate(@*, $uppercase, $smallcase) = translate($team, $uppercase, $smallcase) and (contains($function, 'coordinator') or contains($function, 'deputy'))">
                    <xsl:text>yes</xsl:text>
                  </xsl:if>
                </xsl:for-each>
              </xsl:variable>

              <!-- only list if:
                    * person is in the requested team AND
                      * no display limitation is set OR
                      * coordinators limitation is set AND is a coordinator/deputy
              -->
              <xsl:if test="$inthisteam != '' and ($display = '' or ($display = 'coordinators' and $isCoordinator = 'yes'))">
                <xsl:element name="div">
                  <xsl:attribute name="class">person col-xs-12 col-sm-6</xsl:attribute>
                  <xsl:attribute name="id"><xsl:value-of select="$id" /></xsl:attribute>
                  <xsl:attribute name="teams">
                    <xsl:for-each select="team">
                      <xsl:value-of select="." />
                      <xsl:if test="position() != last()">
                        <xsl:text>, </xsl:text>
                      </xsl:if>
                    </xsl:for-each>
                    <xsl:if test="employee != ''">, employee</xsl:if>
                  </xsl:attribute>
                  <xsl:element name="p">
                    <!-- Picture -->
                    <xsl:choose>
                      <xsl:when test="avatar != ''">
                        <xsl:choose>
                          <xsl:when test="link != ''">
                              <xsl:element name="a">
                                <xsl:attribute name="href">
                                  <xsl:value-of select="link" />
                                </xsl:attribute>

                                <xsl:element name="img">
                            <xsl:attribute name="alt"><xsl:value-of select="name" /></xsl:attribute>
                            <xsl:attribute name="src">/about/people/avatars/<xsl:value-of select="avatar" /></xsl:attribute>
                                </xsl:element>
                              </xsl:element>
                          </xsl:when>
                          <xsl:otherwise>

                            <xsl:element name="img">
                              <xsl:attribute name="alt"><xsl:value-of select="name" /></xsl:attribute>
                              <xsl:attribute name="src">/about/people/avatars/<xsl:value-of select="avatar" /></xsl:attribute>
                            </xsl:element>

                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:element name="img">
                          <xsl:attribute name="alt"><xsl:value-of select="name" /></xsl:attribute>
                          <xsl:attribute name="src">/about/people/avatars/default.png</xsl:attribute>
                        </xsl:element>
                      </xsl:otherwise>
                    </xsl:choose>
                    <!-- Name; if link is given show as link -->
                    <xsl:element name="span">
                        <xsl:attribute name="class">name</xsl:attribute>
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
                        <xsl:attribute name="class">email</xsl:attribute>
                        <xsl:if test="email != ''">
                            <xsl:value-of select="email" />
                        </xsl:if>
                        <xsl:if test="fingerprint != ''">
                            <xsl:element name="a">
                                <xsl:attribute name="href">openpgp4fpr:<xsl:value-of select="fingerprint" /></xsl:attribute>
                                🐾
                            </xsl:element>
                        </xsl:if>
                        <xsl:if test="keyhref != ''">
                            <xsl:element name="a">
                                <xsl:attribute name="href"><xsl:value-of select="keyhref" /></xsl:attribute>
                                🔑
                            </xsl:element>
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
                        <xsl:if test="@activity != ''">
                            <xsl:text> </xsl:text>
                            <xsl:variable name="activity">
                                <xsl:value-of select="@activity" />
                            </xsl:variable>
                            <xsl:element name="a">
                                <xsl:attribute name="href">
                                    <xsl:value-of select="/buildinfo/document/set/activity[@id=$activity]/link/@href" />
                                </xsl:attribute>
                                <xsl:value-of select="/buildinfo/document/set/activity[@id=$activity]/title" />
                            </xsl:element>
                        </xsl:if>
                        <xsl:if test="@volunteers != ''">
                            <xsl:text> </xsl:text>
                            <xsl:variable name="volunteers">
                                <xsl:value-of select="@volunteers" />
                            </xsl:variable>
                            <xsl:apply-templates select="/buildinfo/document/set/volunteers[@id=$volunteers]/node()" />
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

</xsl:stylesheet>
