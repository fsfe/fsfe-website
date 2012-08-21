<?php

echo '
<html lang="en">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>

<h1>Hello '.$row['firstname'].' '.$row['lastname'].'</h1>
<p>Your address '.$row['email'].' was confirmed on '.$row['confirmed'].'.</p>
<p>Thank you for your support to the <a href="http://fsfe.org/">FSFE</a>!</p>

<h2>Contribute more?</h2>

<p>If you want to contribute more than just signing up as a supporter, you may also:</p>
<ul>
<li><a href="http://fsfe.org/news/newsletter">Subscribe to the FSFE newsletter</a></li>
<li><a href="http://fsfe.org/contact/community">Join interesting mailing lists</a></li>
<li><a href="http://fsfe.org/contact/local">Meet your country team</a></li>
<li><a href="http://fellowship.fsfe.org/">Join the Fellowship</a></li>
<li><a href="http://fsfe.org/donate/"></a>Donate to the FSFE</li>
</ul>

<p><a href="http://fsfe.org/contribute/">View all options to contribute</a></p>

</body>
</html>
';

?>
