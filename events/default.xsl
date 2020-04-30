<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../fsfe.xsl"/>


  <!-- ==================================================================== -->
  <!-- Display a single event                                               -->
  <!-- ==================================================================== -->

  <xsl:template match="event">

    <!-- Wrap the event entry into an <article> -->
    <xsl:element name="article">
      <xsl:attribute name="class">event</xsl:attribute>
      <xsl:attribute name="id">
        <xsl:value-of select="@filename"/>
      </xsl:attribute>

      <!-- Title with or without link -->
      <xsl:element name="h3">
        <xsl:call-template name="event-title"/>
      </xsl:element>

      <!-- Date -->
      <xsl:element name="p">
        <xsl:attribute name="class">meta</xsl:attribute>
        <xsl:call-template name="event-date"/>
      </xsl:element>

      <!-- Details -->
      <xsl:apply-templates select="body/node()"/>

      <!-- Tags -->
      <xsl:apply-templates select="tags"/>

    </xsl:element>

  </xsl:template>


  <!-- ==================================================================== -->
  <!-- Display a verbose list of events                                     -->
  <!-- ==================================================================== -->

  <xsl:template match="include-events">

    <!-- Define variables needed inside the loop -->
    <xsl:variable name="group" select="@group"/>
    <xsl:variable name="heading"><xsl:value-of select="."/></xsl:variable>

    <!-- Loop through the events matching the selected group -->
    <xsl:for-each select="/buildinfo/document/set/event[
        not(
          (
            $group = 'past'
            and
            translate(@end,'-','') &gt;= translate(/buildinfo/@date,'-','')
          )
          or
          (
            $group = 'current'
            and
            (
              translate(@start,'-','') &gt; translate(/buildinfo/@date,'-','')
              or
              translate(@end,'-','') &lt; translate(/buildinfo/@date,'-','')
            )
          )
          or
          (
            $group = 'future'
            and
            translate(@start,'-','') &lt;= translate(/buildinfo/@date,'-','')
          )
        )
      ]">

      <!-- Define sort order -->
      <!-- The first (ascending) sort is only used for current and future
           events, so for past events, the second (descending) sort order
           becomes relevant. -->
      <xsl:sort select="@start[$group = 'current' or $group = 'future']"/>
      <xsl:sort select="@start" order="descending"/>

      <!-- Before the first event, display the heading -->
      <xsl:if test="position() = 1">
        <xsl:element name="h2">
          <xsl:value-of select="$heading"/>
        </xsl:element>
      </xsl:if>

      <!-- Display the event -->
      <xsl:apply-templates select="."/>

    </xsl:for-each>

  </xsl:template>

</xsl:stylesheet>
