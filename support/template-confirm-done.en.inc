<?php

echo '
<html lang="en">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta http-equiv="refresh" content="3;URL=\'http://fsfe.org/support/portal#'.$row['secret'].'\'">
</head>
<body>

<h1>Hello '.$row['firstname'].' '.$row['lastname'].'</h1>
<p>Your address '.$row['email'].' was confirmed on '.$row['confirmed'].'.</p>

<p>You will be redirected to <a href="http://fsfe.org/support/portal#'.$row['secret'].'">your personal supporter page</a> in 3 seconds.</p>

</body>
</html>
';

?>
