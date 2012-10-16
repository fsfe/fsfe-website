<!--<?php
// This is the contents of the e-mail sent to a signup whos the e-mail was
// already found in the supporter database.

$subject = 'Thanks for supporting the FSFE';

$message = '
Thank you for showing your support to the FSFE!

However, this e-mail address was already signed up earlier.

Please see details by opening the page
http://fsfe.org/support/portal.en?'. $secret_from_db .'

Note that this URL is personal. You can use it to access 
your supporter details whenever you want, and there is 
no additional password you need to remember.

Thank you!
';

?>-->

<?php
// This is the contents of the e-mail sent to a signup whos the e-mail was
// already found in the supporter database.

$subject = 'Grazie per il vostro sostegno alla FSFE';

$message = '
Vi ringraziamo per aver espresso il vostro sostegno alla FSFE!

Tuttavia, questo indirizzo e-mail era già presente tra quelli dei nostri sostenitori.

Puoi vedere i dettagli alla pagina:
http://fsfe.org/support/portal.en?'. $secret_from_db .'

Questo URL è personale. Puoi utilizzarlo per accedere ai tuoi dettagli di sostenitore quando lo desideri, senza bisogno di ulteriori password.

Grazie!
';

?>
