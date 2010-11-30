<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:output method="text" encoding="UTF-8" indent="no" />
  <xsl:strip-space elements="body"/> 
  
  <!-- only play with the body -->
  <xsl:template match="/">
    <xsl:copy>
      <xsl:apply-templates select="/html/body" />
    </xsl:copy>
  </xsl:template>

  <!-- Show a single event -->
  <xsl:template name="event">
    <xsl:param name="header" />

    <!-- Create variables -->
    <xsl:variable name="start">
      <xsl:value-of select="translate (@start, '-', '')" />
    </xsl:variable>
    
    <xsl:variable name="end">
      <xsl:value-of select="concat(substring(@end,1,4),substring(@end,6,2),substring(@end,9,2)+1)" />
    </xsl:variable>
    
    <xsl:variable name="link">
      <xsl:value-of select="link" />
    </xsl:variable>
    
    <xsl:variable name="page">
      <xsl:value-of select="page" />
    </xsl:variable>
    <!-- Now, the event block -->
BEGIN:VEVENT
SUMMARY:<xsl:value-of select="title" />
DTSTART:<xsl:value-of select="$start" />
DTEND:<xsl:value-of select="$end" />
DESCRIPTION:<xsl:apply-templates select="body/node()" />
END:VEVENT
  </xsl:template>

  <!-- In /html/body node, append dynamic content -->
  <xsl:template match="/html/body">
BEGIN:VCALENDAR
      <!-- $today = current date (given as <html date="...">) -->
      <xsl:variable name="today">
        <xsl:value-of select="/html/@date" />
      </xsl:variable>
      <!-- All events -->
      <xsl:for-each select="/html/set/event
        [translate (@start, '-', '') &gt; translate ($today, '-', '')]">
        <xsl:sort select="@start" order="descending" />
        <xsl:call-template name="event">
          <xsl:with-param name="header">current</xsl:with-param>
        </xsl:call-template>
      </xsl:for-each>
END:VCALENDAR
  </xsl:template>

</xsl:stylesheet>

