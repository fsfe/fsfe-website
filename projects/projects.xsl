<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml"
           encoding="ISO-8859-1"
           indent="yes"
           />

  <xsl:template match="/">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="/html/text" />

  <xsl:template match="/html/body">
    <body>
      <xsl:apply-templates />
      <table>
        <tr>
          <th class="projects"><xsl:value-of select="/html/text[@id='technical']" /></th>
          <th class="projects"><xsl:value-of select="/html/text[@id='legal']" /></th>
          <th class="projects"><xsl:value-of select="/html/text[@id='community']" /></th>
          <th class="projects"><xsl:value-of select="/html/text[@id='other']" /></th>
        </tr>
        <tr>
          <td class="projects">
            <xsl:for-each select="/html/set/project[@type='technical']">
              <p><a href="{link}"><xsl:value-of select="title" /></a><br />
               <xsl:apply-templates select="description/node()" /></p>
            </xsl:for-each>
          </td>
          <td class="projects">
            <xsl:for-each select="/html/set/project[@type='legal']">
              <p><a href="{link}"><xsl:value-of select="title" /></a><br />
               <xsl:apply-templates select="description/node()" /></p>
            </xsl:for-each>
          </td>
          <td class="projects">
            <xsl:for-each select="/html/set/project[@type='community']">
              <p><a href="{link}"><xsl:value-of select="title" /></a><br />
               <xsl:apply-templates select="description/node()" /></p>
            </xsl:for-each>
          </td>
          <td class="projects">
            <xsl:for-each select="/html/set/project[@type='other']">
              <p><a href="{link}"><xsl:value-of select="title" /></a><br />
               <xsl:apply-templates select="description/node()" /></p>
            </xsl:for-each>
          </td>
        </tr>
      </table>
    </body>
  </xsl:template>

  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="set">
  </xsl:template>
</xsl:stylesheet>

