<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [<!ENTITY nbsp "&#160;">]>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" encoding="ISO-8859-1" indent="yes" />

  <xsl:template match="/rss/channel">
    <p>
      <xsl:apply-templates select="@*|node()"/>      
    </p>
  </xsl:template>

  <xsl:template match="/rss/channel/item">
    <p>
      <table border="0" cellpadding="0" cellspacing="0">
	<tr valign="top"  bgcolor="#736199">
	  <td bgcolor="#ffffff">
	    <img src="images/pix.png" width="5" height="1" alt=" " />
	  </td>
	  <td width="10" valign="top">
	    <img border="0" width="10" height="13" src="images/ul.png" alt="(( " />
	  </td>
	  <td bgcolor="#736199" class="newstitle">
	    <a href="{link}"><xsl:value-of select="title" /></a>
	    <b><xsl:value-of select="substring-before(description, '.')"/></b>
	  </td>
	  <td width="10" align="right" valign="top">
	    <img border="0" width="10" height="13" src="images/ur.png" alt="))" />
	  </td>
	</tr>
      </table>

      <table border="0" cellspacing="0" cellpadding="1" width="100%" bgcolor="#736199">
	<tr>
	  <td valign="bottom">
	    <table border="0" bgcolor="#cacaca" cellspacing="0" cellpadding="3" width="100%">
	      <tr>
		<td nowrap="1" class="newsinfo">
		  <a href="{link}">Lire l'article</a>
		</td>
	      </tr>
	      <tr>
		<td class="newstext">
		  <xsl:value-of disable-output-escaping="yes" select="substring-after(description, '.')" />
		</td>
	      </tr>
	    </table>
	  </td>
	</tr>
      </table>
    </p>
  </xsl:template>

  <xsl:template match="@*|node()" priority="-1">
    <xsl:apply-templates select="@*|node()"/>
  </xsl:template>

  <!--
  Local Variables: ***
  mode: xml ***
  End: ***
  -->
</xsl:stylesheet>
