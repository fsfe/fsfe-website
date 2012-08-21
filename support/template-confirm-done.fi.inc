<?php

echo '
<html lang="en">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>

<h1>Terve '.$row['firstname'].' '.$row['lastname'].'</h1>
<p>Osoitteesi '.$row['email'].' on vahvistettu '.$row['confirmed'].'.</p>
<p>Kiitos tukesi osoittamisesta <a href="http://fsfe.org/">FSFE:lle</a>!</p>

<h2>Haluatko tehdä enemmän?</h2>

<p>Jos haluat tehdä enemmäin kuin vain ilmoittautua tukijaksi, voit myös:</p>
<ul>
<li><a href="http://fsfe.org/news/newsletter">Tilata FSFE:n uutiskirjeen</a></li>
<li><a href="http://fsfe.org/contact/community">Liittyä kiinnostaville sähköpostilistoille</a></li>
<li><a href="http://fsfe.org/fi/">Tavata paikallistiimisi</a></li>
<li><a href="http://fellowship.fsfe.org/">Liittyä Fellowship-jäseneksi</a></li>
<li><a href="http://fsfe.org/donate/">Tukea FSFE:tä lahjoituksella</a></li>
</ul>

<p><a href="http://fsfe.org/contribute/">Katso kaikki osallistumisvaihtoehdot</a></p>

</body>
</html>
';

?>
