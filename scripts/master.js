/*

/scripts/master.js -- Misc. script snippets needed for fsfe.org

*/

$(document).ready(function() {

    // Close service notice when clicking dismiss button.
    $("#service-notice .close a").click(function() {
	$("#service-notice").fadeOut("slow");
    });

});
