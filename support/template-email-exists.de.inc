<?php
// This is the contents of the e-mail sent to a signup whos the e-mail was
// already found in the supporter database.

$subject = 'Danke, dass Sie die FSFE unterstützen';

$message = '
Vielen Dank, dass Sie die FSFE unterstützen!

Diese E-Mail-Adresse ist jedoch bereits registriert.

Erfahren Sie nähere Details auf
http://fsfe.org/support/portal.de?'. $secret_from_db .'

Dies ist Ihre persönliche URL. Sie können darüber auf Ihre Unterstützerdetails
zugreifen wann immer Sie mögen. Dazu müssen Sie sich kein weiteres Passwort
merken. 

Vielen Dank!
';

?>
