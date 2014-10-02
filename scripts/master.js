/*
 * Master script snippet(s) for fsfe.org
 *
 * @license GPL-2.0 <https://github.com/jquery/jquery/blob/master/GPL-LICENSE.txt>
 * @license MIT <https://github.com/jquery/jquery/blob/master/MIT-LICENSE.txt>
 * @license-comment As this makes use of jQuery, the jQuery licensing has been concluded.
 */

$(document).ready(function() {

    // Close service notice on dismiss button.
    $(".alert a.close").click(function() {
        $(".alert").hide();
    });

});
