<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

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
                <h3><a href="{link}"><xsl:value-of select="name" /></a></h3>
              </xsl:when>
              <xsl:otherwise>
                <h3><xsl:value-of select="name" /></h3>
              </xsl:otherwise>
            </xsl:choose>

            <ul>

              <!-- Functions -->
              <xsl:for-each select="function">
                <xsl:if test="position() != 1">
                  <xsl:text>/</xsl:text>
                </xsl:if>
                <xsl:variable name="function">
                  <xsl:value-of select="." />/
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
                </xsl:variable>
                <xsl:apply-templates select="/html/set/function[@id=$function]/node()"/>
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
          <div class="profile">
            <xsl:choose>
              <xsl:when test="profile != ''">
                <xsl:value-of select="profile" />
              </xsl:when>
              <xsl:otherwise>
                &nbsp;
              </xsl:otherwise>
            </xsl:choose>
          </div>
        </div>
      </xsl:for-each>
    </div>
  </xsl:template>

  <!-- Do not copy <set> to output at all -->
  <xsl:template match="set"/>

  <!-- For all other nodes, copy verbatim -->
  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
