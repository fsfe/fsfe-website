<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dt="http://xsltsl.org/date-time"
  exclude-result-prefixes="dt"
  xmlns:str="http://exslt.org/strings"
  extension-element-prefixes="str">

  <xsl:template name="support-portal-javascript">
    <script type="text/javascript">
    /* <![CDATA[ */
    function map_json_to_html(data) {
        for (x in data) {
            $(x).html(data[x]);
        }
    }
    $(document).ready(function() {
        var secret = window.location.search.slice(1);
        if (secret.length == 32) {
            $.getJSON('portal-backend?'+secret, function(data) {
                $("#support_portal_loading").hide();
                $("#support_portal").show();
                if (data.error) {
                    $("#support_portal").html(data.error);
                } else {
                    map_json_to_html(data);
                }
            });
        } else {
            $("#support_portal_loading").html("Expected parameter not found, nothing to show here.");
        }
    });
    /* ]]> */
    </script>
  </xsl:template>

  <xsl:template name="support-form-javascript">
    <script type="text/javascript" src="/scripts/jquery.validate.min.js"></script>
    <!-- 
        script type="text/javascript" src="/scripts/jquery.validate-lozalization/messages_fi.js"></script 
        *How to inser lang code in above?*
     -->
    <script type="text/javascript">
    /* <![CDATA[ */
    $(document).ready(function() {
        $("input[name=ref_url]").val(document.referrer);
        $("input[name=ref_id]").val(window.location.search.toString().slice(1));
        
            $("form.support").validate({
                    rules: {
                            email: {email: true, required: true},
                            country_code: {required: true}
                     },
                     /* // didn't work with Firefox! Terrible hack written below
                     submitHandler: function(form, event) {

                // stop form from submitting normally
                event.preventDefault(); // does not seem to work on Firefox
                
                var $submitbutton = $("form.support input[type='submit']");
                $submitbutton.val($submitbutton.attr("data-loading-text"))
                
                // Send the data using post and put the results in a div
                var $form = $("form.support");
                $.post($form.attr("action"), $form.serialize(),
                  function(data) {
                      $("#support_form").fadeOut();
                      $("#introduction").append('<div id="support_form_sent">'+data+'</div>');
                      piwikTracker.trackGoal(2); // logs a conversion for goal 2
                  }
                );

                return false; // prevent submit, not sure if has any effect
             }
             */
            });
            
            // terrible hack to prevent submit in Firefox!
            var newbutton = '<input type="button" value="' + $("form.support input[type='submit']").val() + '" data-loading-text="' + $("form.support input[type='submit']").attr("data-loading-text") + '"/>';
            $("form.support input[type='submit']").after(newbutton);
            $("form.support input[type='submit']").remove();
            $("form.support input[type='button']").click(function(){
            if ( $("form.support").valid() ) {

                var $submitbutton = $("form.support input[type='button']");
                $submitbutton.val($submitbutton.attr("data-loading-text"))
                
                /* Send the data using post and put the results in a div */
                var $form = $("form.support");
                $.post($form.attr("action"), $form.serialize(),
                  function(data) {
                      $("#support_form").fadeOut();
                      $("#introduction").append('<div id="support_form_sent">'+data+'</div>');
                      piwikTracker.trackGoal(2); // logs a conversion for goal 2
                  }
                );

            }
            });
    });

    /* ]]> */
    </script>
  </xsl:template>

  <xsl:template match="support-portal-javascript">
    <xsl:call-template name="support-portal-javascript" />
  </xsl:template>
  <xsl:template match="support-form-javascript">
    <xsl:call-template name="support-form-javascript" />
  </xsl:template>

</xsl:stylesheet>
