<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="UTF-8" indent="yes" />

  <xsl:template name="body_scripts">
    <!-- Piwik -->
    <script type="text/javascript">
    //enable piwik on plain text page only
    pkBaseURL = "http://piwik.fsfe.org/";
    if ("http:" == document.location.protocol) {
      document.write(unescape("%3Cscript src='" + pkBaseURL + "piwik.js' type='text/javascript'%3E%3C/script%3E"));
    }
    </script>
    <script type="text/javascript">
    try {
    var piwikTracker = Piwik.getTracker(pkBaseURL + "piwik.php", 4);
    piwikTracker.trackPageView();
    piwikTracker.enableLinkTracking();
    } catch( err ) {}
    </script>
    <!-- End Piwik Tracking Code -->
  
    <script src="/scripts/bootstrap-3.0.3.min.js"></script>
    <script src="/scripts/master.js"></script>
    <script src="/scripts/placeholder.js"></script>
    <script src="/scripts/highlight.pack.js"></script>
  </xsl:template>

</xsl:stylesheet>
