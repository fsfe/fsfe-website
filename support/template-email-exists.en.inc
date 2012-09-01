<?php
// This is the contents of the e-mail sent to a signup whos the e-mail was
// already found in the supporter database.

$subject = 'Thanks for supporting the FSFE';

$message = '
Thank you for showing your support to the FSFE!

However, this e-mail address was already signed up earlier.

Please see details by opening the page
http://fsfe.org/support/portal?'. $secret_from_db .'

Note that this URL is personal. You can use it to access 
your supporter details whenever you want, and there is 
no additional password you need to remember.

Thank you!
';

?>
