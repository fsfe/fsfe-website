<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../fsfe.xsl" />

  <!-- Fill dynamic content -->
  <xsl:template match="activity-display">
    <xsl:variable name="highlight">
      <xsl:value-of select="@highlight"/>
    </xsl:variable>
    <xsl:variable name="tag">
      <xsl:value-of select="@tag"/>
    </xsl:variable>
    <xsl:element name="div">
      <!-- different style and selection depending on $highlight -->
      <xsl:choose>
        <!-- highlighted activities in full width -->
        <xsl:when test="$highlight = 'yes'">
          <xsl:attribute name="class">icon-grid fullwidth</xsl:attribute>
          <xsl:element name="ul">
            <xsl:choose>
              <!-- request certain tag -->
              <xsl:when test="$tag != ''">
                <xsl:for-each select="/buildinfo/document/set/activity [order/@highlight = 'yes' and tags/tag/@key = $tag]">
                  <xsl:sort select="order/@priority" order="descending"/>
                  <xsl:sort select="@date" order="descending"/>
                  <xsl:call-template name="activity" />
                </xsl:for-each>
              </xsl:when>
              <!-- all tags -->
              <xsl:otherwise>
                <xsl:for-each select="/buildinfo/document/set/activity [order/@highlight = 'yes']">
                  <xsl:sort select="order/@priority" order="descending"/>
                  <xsl:sort select="@date" order="descending"/>
                  <xsl:call-template name="activity" />
                </xsl:for-each>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:element>
        </xsl:when>
        <!-- non-highlighted activities -->
        <xsl:otherwise>
          <xsl:attribute name="class">icon-grid no-icons</xsl:attribute>
          <xsl:element name="ul">
            <xsl:choose>
              <!-- request certain tag -->
              <xsl:when test="$tag != ''">
                <xsl:for-each select="/buildinfo/document/set/activity [(order/@highlight != 'yes' or not(order/@highlight)) and tags/tag/@key = $tag]">
                  <xsl:sort select="order/@priority" order="descending"/>
                  <xsl:sort select="@date" order="descending"/>
                  <xsl:call-template name="activity" />
                </xsl:for-each>
              </xsl:when>
              <!-- all tags -->
              <xsl:otherwise>
                <xsl:for-each select="/buildinfo/document/set/activity [(order/@highlight != 'yes' or not(order/@highlight))]">
                  <xsl:sort select="order/@priority" order="descending"/>
                  <xsl:sort select="@date" order="descending"/>
                  <xsl:call-template name="activity" />
                </xsl:for-each>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:element>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>

  <xsl:template name="activity">
    <xsl:element name="li">
      <!-- Logo -->
      <xsl:if test="image/@url">
        <xsl:element name="img">
          <xsl:attribute name="src">
            <xsl:value-of select="image/@url"/>
          </xsl:attribute>
          <xsl:attribute name="alt">
            <xsl:text>Logo of </xsl:text>
            <xsl:value-of select="title"/>
          </xsl:attribute>
        </xsl:element>
      </xsl:if>

      <xsl:element name="div">
        <!-- Title -->
        <xsl:element name="h3">
          <xsl:element name="a">
            <xsl:attribute name="href">
              <xsl:value-of select="link/@href"/>
            </xsl:attribute>
            <xsl:value-of select="title"/>
          </xsl:element>
          <xsl:if test="@status = 'finished'">
            <xsl:element name="span">
              <xsl:attribute name="class">status</xsl:attribute>
              <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'finished'" /></xsl:call-template>
            </xsl:element>
          </xsl:if>
        </xsl:element>

        <!-- Description -->
        <xsl:element name="p">
          <xsl:apply-templates select="description/node()"/>
        </xsl:element>
      </xsl:element> <!-- /div -->
    </xsl:element> <!-- /li -->
  </xsl:template>

</xsl:stylesheet>
