<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="xml" encoding="UTF-8" indent="yes" />
	
	
	<xsl:template name="gettext">
	  <xsl:param name="id" />
	  
      <xsl:value-of select="/html/set/textset-content/text[@id=$id] |
                            /html/set/textset-content-backup/text[@id=$id and not(@id=/html/set/textset-content/text/@id)]"/>
      
    </xsl:template>

</xsl:stylesheet>
