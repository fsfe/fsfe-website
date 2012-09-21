<?php
// This is the HTML contents shown after user submitted the support form

echo '
<p>Vielen Dank, dass Sie die FSFE unterstützen!</p>
<p>Eine Bestätigungsnachricht wurde an folgende Adresse verschickt: '. $_POST['email'] .'</p>
';

?>
