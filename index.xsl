<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dt="http://xsltsl.org/date-time">
  
  <xsl:import href="tools/xsltsl/date-time.xsl" />
  <xsl:output method="xml" encoding="UTF-8" indent="yes" />

  <!-- $today = current date (given as <html date="...">) -->
  <xsl:variable name="today">
    <xsl:value-of select="/html/@date" />
  </xsl:variable>

  <!-- Basically, copy everything -->
  <xsl:template match="/">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <!-- Show a single news item -->
  <xsl:template name="news">
    <xsl:variable name="link"><xsl:value-of select="link" /></xsl:variable>
    <div class="entry">
      <xsl:choose>
        <xsl:when test="$link != ''">
          <h3><a href="{link}"><xsl:value-of select="title" /></a></h3>
        </xsl:when>
        <xsl:otherwise>
          <h3><xsl:value-of select="title" /></h3>
        </xsl:otherwise>
      </xsl:choose>
      
      <div class="text">
        <xsl:apply-templates select="body/node()" />
      </div>
      
    </div>
  </xsl:template>

  <!-- Show a single newsletter entry -->
  <xsl:template name="newsletter">
    <xsl:variable name="date">
      <xsl:value-of select="@date" />
    </xsl:variable>

    <xsl:variable name="link">
      <xsl:value-of select="link" />
    </xsl:variable>
    
    <xsl:variable name="month">
      <xsl:call-template name="dt:get-month-name">
	<xsl:with-param name="month" select="substring($date,6,2)" />
      </xsl:call-template>
    </xsl:variable>
    
    <xsl:variable name="year">
      <xsl:value-of select="substring($date,0,5)" />
    </xsl:variable>

    <li><a href="{link}">Newsletter from <xsl:value-of select="$month" />&#160;<xsl:value-of select="$year" /></a></li>
  </xsl:template>

  <!-- Show a single event -->
  <xsl:template name="event">

    <!-- Create variables -->
    <xsl:variable name="start">
      <xsl:value-of select="@start" />
    </xsl:variable>
    
    <xsl:variable name="start_day">
      <xsl:value-of select="substring($start,9,2)" />
    </xsl:variable>
    
    <xsl:variable name="start_month">
      <xsl:call-template name="dt:get-month-name">
        <xsl:with-param name="month" select="substring($start,6,2)" />
      </xsl:call-template>
    </xsl:variable>
    
    <xsl:variable name="end">
      <xsl:value-of select="@end" />
    </xsl:variable>
    
    <xsl:variable name="end_day">
      <xsl:value-of select="substring($end,9,2)" />
    </xsl:variable>
    
    <xsl:variable name="end_month">
      <xsl:call-template name="dt:get-month-name">
        <xsl:with-param name="month" select="substring($end,6,2)" />
      </xsl:call-template>
    </xsl:variable>
    
    <xsl:variable name="link">
      <xsl:value-of select="link" />
    </xsl:variable>
 
    <div class="entry">
      <xsl:choose>
        <xsl:when test="$link != ''">
          <h3><a href="{link}"><xsl:value-of select="title" /></a></h3>
        </xsl:when>
        <xsl:otherwise>
          <h3><xsl:value-of select="title" /></h3>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:choose>
        <xsl:when test="$start != $end">
          <p class="date">
            <xsl:value-of select="$start_day" />
            <xsl:text> </xsl:text>
            <xsl:value-of select="$start_month" />
            <xsl:text> to </xsl:text>
            <xsl:value-of select="$end_day" />
            <xsl:text> </xsl:text>
            <xsl:value-of select="$end_month" />
          </p>
        </xsl:when>
        <xsl:otherwise>
          <p class="date">
            <xsl:value-of select="$start_day" />
            <xsl:text> </xsl:text>
            <xsl:value-of select="$start_month" />
          </p>
        </xsl:otherwise>
      </xsl:choose>
    </div>
  </xsl:template>

  <!-- In /html/body node, append dynamic content -->
  <xsl:template match="/html/body">
    <body>
      <xsl:apply-templates />
      
      <div id="feeds">
        <div id="news" class="section">
          <h2>
            <a class="rss-feed" href="/news.rss"><img src="/graphics/rss.png" alt="News RSS" /></a>
            <a class="identica" href="http://identi.ca/fsfe"><img src="/graphics/identica.png" alt="identica" title="follow FSFE on identi.ca"/></a>
            <a href="/news/news.html"><xsl:value-of select="/html/text[@id='news']"/></a>
          </h2>

          <xsl:for-each select="/html/set/news[translate (@date, '-', '') &lt;= translate ($today, '-', '')]">
            <xsl:sort select="@date" order="descending" />
            <xsl:if test="position() &lt; 6">
              <xsl:call-template name="news" />
            </xsl:if>
          </xsl:for-each>
        </div>

        <div id="newsletter" class="section">
          <h2><a href="/news/newsletter.html">Newsletter</a></h2>
          
          <div class="entry">
            <p>
              Subscribe to FSFE's monthly newsletter
            </p>

            <form method="post" action="http://mail.fsfeurope.org/mailman/subscribe/press-release">
              <p>
                <select id="language" name="language">
                  <option value="en" selected="selected">English</option>
  		  <option value="el">Ελληνικά</option>	
		  <option value="es">Español</option>
		  <option value="de">Deutsch</option>
		  <option value="fr">Français</option>
                  <option value="it">Italiano</option>
		  <option value="nl">Nederlands</option>
		  <option value="pt">Português</option>
		  <option value="ru">Русский</option>
                  <option value="sv">Svenska</option>
                </select>
                
		<xsl:element name="input">
		  <xsl:attribute name="id">email</xsl:attribute>
		  <xsl:attribute name="type">email</xsl:attribute>
		  <xsl:attribute name="placeholder"><xsl:value-of select="/buildinfo/textset/text[@id='email-address-label']" /></xsl:attribute>
		</xsl:element>
                
                <input type="submit" id="submit" value="Subscribe" />
              </p>
            </form>

	    <ul>
	      <xsl:for-each select="/html/set/news
				    [translate(@date, '-', '') &lt;= translate($today, '-', '')
				    and (@type = 'newsletter')]">
		<xsl:sort select="@date" order="descending" />
		<xsl:if test="position()&lt;3">
		  <xsl:call-template name="newsletter" />
		</xsl:if>
	      </xsl:for-each>
	      <li><a href="news/newsletter.html"><xsl:value-of select="/buildinfo/textset/text[@id='email-address-label']" />...</a></li>
	    </ul>
          </div><!-- /.entry -->
        </div> <!-- /#newsletter -->

        <div id="events" class="section">
          <h2>
            <a class="rss-feed" href="/events.rss"><img src="/graphics/rss.png" alt="Events RSS" /></a>
            <a class="ical" href="/events.ical"><img src="/graphics/ical.png" alt="iCal" title="FSFE events as iCal feed" /></a>
            <a href="/events/events.html"><xsl:value-of select="/html/text[@id='events']"/></a>
          </h2>
        
          <xsl:for-each select="/html/set/event
            [translate (@end, '-', '') &gt;= translate ($today, '-', '')]">
            <xsl:sort select="@start" />
            <xsl:if test="position() &lt; 6">
              <xsl:call-template name="event" />
            </xsl:if>
          </xsl:for-each>
        </div>
      </div>
    </body>
  </xsl:template>

  <!-- Do not copy <set> and <text> to output at all -->
  <xsl:template match="/html/text" />
  <xsl:template match="set" />

  <!-- For all other nodes, copy verbatim -->
  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
    
  </xsl:template>
  
</xsl:stylesheet>