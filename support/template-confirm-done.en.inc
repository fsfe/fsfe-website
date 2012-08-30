<?php
// This is the contents of the web page shown to a signup who
// clicked the confirm link in their e-mail.

echo '
<h1>Hello '.$row['firstname'].' '.$row['lastname'].'</h1>
<p>Your address '.$row['email'].' was confirmed on '.$row['confirmed'].'.</p>

<p>You will be redirected to <a href="http://fsfe.org/support/portal?'.$row['secret'].'">your personal supporter page</a> in 3 seconds.</p>
';

?>
