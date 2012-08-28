<?php

echo '
<html lang="en">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>

<h1>Tere, '.$row['firstname'].' '.$row['lastname'].'</h1>
<p>Sinu e-posti aadress '.$row['email'].' kinnitati '.$row['confirmed'].'.</p>
<p>Täname sind sinu toetuse eest <a href="http://fsfe.org/">FSFEle</a>!</p>

<h2>Kas sa tahad rohkem teha?</h2>

<p>Kui sa soovid teha rohkem kui end toetajana kirja panna, siis võid:</p>
<ul>
<li><a href="http://fsfe.org/news/newsletter">tellida FSFE uudiskirja</a>;</li>
<li><a href="http://fsfe.org/contact/community">liituda huvitavate postiloenditega</a>;</li>
<li><a href="http://fsfe.org/uk/">kohtuda oma riigitiimi liikmetega</a>;</li>
<li><a href="http://fellowship.fsfe.org/">liituda Ühinguga</a>;</li>
<li><a href="http://fsfe.org/donate/">annetada FSFEle</a>.</li>
</ul>

<p><a href="http://fsfe.org/contribute/">Vaata kõiki võimalusi kaasa löömiseks</a>.</p>

</body>
</html>
';

?>
