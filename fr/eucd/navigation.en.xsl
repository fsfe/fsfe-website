<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [<!ENTITY nbsp "&#160;">]>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="/html[@lang='en']/body/div">

    <!-- Top menu line -->
    <table border="1" cellpadding="5" cellspacing="10" class="main">
      <tr>
	<td colspan="2">
	  <span>EUCD</span>
	</td>
      </tr>
      
      <tr>
	<td valign="top">
	  <a href="/">Home</a><br />
	  <a href="/tarif.fr.html">Info</a><br />
	</td>
	
	<td>
	  
	  <xsl:apply-templates select="@*|node()"/>

	</td>
      </tr>

    </table>

  </xsl:template> 

<!--
Local Variables: ***
mode: xml ***
End: ***
-->
</xsl:stylesheet>
