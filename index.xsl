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
      <table style="border: solid red">
       <tr>
        <td>
         The FSF Europe supports the <a href="http://swpat.ffii.org/group/demo/index.en.html">online demonstration against software patents</a>. The European Parliament will vote on a directive validating Software Patents on September the 1st. Read more about why software patents are a bad idea on <a href="http://swpat.ffii.org/">SWPAT</a>, and learn how you can help fight them.
        </td>
       </tr>
      </table>

      <table class="news">
      <xsl:for-each select="/html/set/news">
        <xsl:sort select="@date" order="descending" />
        <xsl:if test="position() &lt; 6">
          <tr>
            <td class="newstitle"><xsl:value-of select="title" /></td>
            <td class="newsdate"><xsl:value-of select="@date" /></td>
          </tr>
          <tr>
           <td colspan="2" class="newsbody">
            <xsl:apply-templates select="body/node()" />
            <xsl:variable name="link"><xsl:value-of select="link" /></xsl:variable>
            <xsl:if test="$link!=''">
              [<a href="{link}"><xsl:value-of select="/html/text[@id='more']" /></a>]
            </xsl:if>
           </td>
          </tr> 
          <tr height="15"><td colspan="2"></td></tr>
        </xsl:if>
      </xsl:for-each>
      </table>
    </body>
  </xsl:template>

  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="set" />
</xsl:stylesheet>

