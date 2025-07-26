<html>
<body>
  <p>Dear <?=$name?>,</p>
  <p>
    thank you for your recent request of promotional material from the FSFE!
    We've received your request and will normally be sending this to you
    within a few days. We will let you know once we've packed your order
    and sent it. Please note that we usually send the material without a
    tracking number.
  </p>
  <?php
  if ( !empty($donationID) ) {
  ?>
  <p>If you have yet to make your donation, you may now do so by following
    this link: <a href=https://fsfe.org/order/payonline.<?=$lang?>/<?=$donationID?>> 
    https://fsfe.org/order/payonline.<?=$lang?>/<?=$donationID?></a>. Once the donation is
    confirmed the promotional material will be send.</p>
    <p>In case you prefer to pay by bank transfer, please use the following data:</p>
    <p>Recipient: Free Software Foundation Europe e.V.<br>
    Address: Revaler Straße 19, 10245 Berlin, Germany<br>
    IBAN: DE47 4306 0967 2059 7908 01<br>
    Bank: GLS Gemeinschaftsbank eG, 44774 Bochum, Germany<br>
    BIC: GENODEM1GLS<br>
    Payment reference: <?=$donationID?><br>
    Payment amount: <?=$donate?> Euro</p>
  <?php
  }
  ?>
  <p>
    In about two weeks after we send your material, we will contact you to
    make sure it was received properly. We will also contact you later on to
    get some feedback from you about the material and how it's been used. If
    you have any questions in the mean time, please feel free to reply to
    this message.
  </p>
  <p>
    Thanks for helping us spread the word, and we hope you will have fun and
    find the material useful! If you share pictures online of the material
    having arrived or where it's been used, let us know by dropping a link
    to us here or on social networks (@fsfe).
  </p>
  <p>
    Best regards,
  </p>
</body>
</html> 
