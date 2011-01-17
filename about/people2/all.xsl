<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

  <!-- Create function name -->
  <xsl:template name="getFunctionName">
    <xsl:param name="function" />
    <xsl:param name="sex" />

    <xsl:value-of select="$function" />
    <xsl:text>/</xsl:text>
    <xsl:value-of select="$sex" />
  </xsl:template>

  <!-- Fill dynamic content -->
  <xsl:template match="dynamic-content">
    <div id="people">
      <xsl:for-each select="/html/set/person">
        <xsl:sort select="@id" />
        <div class="person">

          <!-- Image -->
          <div class="image">
            <img src="/about/people2/images/{@id}.jpg" alt="" />
          </div>

          <div class="meta">

            <!-- Name -->
            <xsl:choose>
              <xsl:when test="link != ''">
                <h3 id="{@id}"><a href="{link}"><xsl:value-of select="name" /></a></h3>
              </xsl:when>
              <xsl:otherwise>
                <h3 id="{@id}"><xsl:value-of select="name" /></h3>
              </xsl:otherwise>
            </xsl:choose>

            <ul>

              <!-- Functions -->
             <xsl:for-each select="functions">
               <xsl:sort select="." />

               <xsl:variable name="function"><xsl:value-of select="." /></xsl:variable>
               <xsl:variable name="sex"><xsl:value-of select="@sex" /></xsl:variable>

               <li>orig func: <xsl:value-of select="function" /></li> 
               <li>orig func type: <xsl:value-of select="@type" /></li>
               <!-- <xsl:variable name="function_test">
                  <xsl:value-of select="function" />foobar
                                    <xsl:choose>
                    <xsl:when test="sex = 'male'">
                      m
                    </xsl:when>
                    <xsl:when test="sex = 'female'">
                      f
                    </xsl:when>
                    <xsl:otherwise>
                      m
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>-->
                <!--<xsl:variable name="function_test"><xsl:value-of select="function" /><xsl:text>foobar</xsl:text></xsl:variable>
              -->
              <!--<li>new func: <xsl:value-of select="function_test" /></li>
              -->

                <xsl:variable name="function_test">
                  <xsl:call-template name="getFunctionName">
                    <xsl:with-param name="function" select="$function" />
                    <xsl:with-param name="sex" select="$sex" />
                  </xsl:call-template>
                </xsl:variable>

                <li><xsl:value-of select="$function_test" /></li>

                <!--
                <xsl:apply-templates select="/html/set/function[@id=$function]/node()" />
                -->
                <!--
            <xsl:if test="@country != ''">
                <xsl:text> </xsl:text>
                <xsl:variable name="country"><xsl:value-of select="@country"/></xsl:variable>
                <xsl:value-of select="/html/set/country[@id=$country]"/>
              </xsl:if>
              <xsl:if test="@project != ''">
                <xsl:text> </xsl:text>
                <xsl:variable name="project"><xsl:value-of select="@project"/></xsl:variable>
                <xsl:element name="a">
                  <xsl:attribute name="href">
                    <xsl:value-of select="/html/set/project[@id=$project]/link"/>
                  </xsl:attribute>
                  <xsl:value-of select="/html/set/project[@id=$project]/title"/>
                </xsl:element>
              </xsl:if>
              <xsl:if test="@volunteers != ''">
                <xsl:text> </xsl:text>
                <xsl:variable name="volunteers"><xsl:value-of select="@volunteers"/></xsl:variable>
                <xsl:apply-templates select="/html/set/volunteers[@id=$volunteers]/node()"/>
              </xsl:if>
              -->
              </xsl:for-each>

              <!-- E-mail -->
              <xsl:if test="email != ''">
                <li>
                  <a href="mailto:{email}"><xsl:value-of select="email" /></a>
                </li>
              </xsl:if>

              <!-- Telephone -->
              <xsl:if test="telephone != ''">
                <li>
                  <xsl:value-of select="telephone" />
                </li>
              </xsl:if>
            </ul>
          </div>

          <!-- Profile -->
          <div class="profile">
            <xsl:choose>
              <xsl:when test="profile != ''">
                <!--       <xsl:text disable-output-escaping="yes">
                  <xsl:value-of select="profile" />
                </xsl:text>-->
              </xsl:when>
              <xsl:otherwise>
                
              </xsl:otherwise>
            </xsl:choose>
            <p><a href="#top">back to top</a></p>
          </div>
        </div>
      </xsl:for-each>
    </div>
  </xsl:template>

  <!-- Do not copy <set> or <text> to output at all -->
  <xsl:template match="set" />

  <!-- For all other nodes, copy verbatim -->
  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>

