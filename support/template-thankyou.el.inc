<?php
// This is the HTML contents shown after user submitted the support form

echo '
<p>Ευχαριστούμε που δείχνετε την υποστήριξή σας FSFE!</p>
<p>Ένα μήνυμα επιβεβαίωσης έχει σταλεί στη διεύθυνση του ηλεκτρονικού σας 
ταχυδρομείου '. $_POST['email'] .'</p>
';

?>
