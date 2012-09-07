<?php
// This is the contents of the e-mail sent to a signup whos the e-mail was
// already found in the supporter database.

$subject = 'Tak fordi du støtter FSFE';

$message = '
Tak fordi du viser din støtte til FSFE!

Din e-mail-adresse er dog allerede registreret.

Se flere oplysninger ved at åbne siden
http://fsfe.org/support/portal.en?'. $secret_from_db .'

Bemærk at den pågældende URL er personlig.  Du kan anvende 
den til at til se dine støtteoplysninger, når du har brug 
for det, og det er ikke nødvendigt at huske en adgangskode.

Tak!
';

?>
