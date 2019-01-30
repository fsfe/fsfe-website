<?php echo '<?xml version="1.0" encoding="utf-8"?>'; ?>

<eventset>
  <event start="<?php echo htmlspecialchars($startdate) ?>" end="<?php if($enddate) { echo htmlspecialchars($enddate); } else { echo htmlspecialchars($startdate); }?>">

    <title><?php echo htmlspecialchars($title) . " in " . htmlspecialchars($city) . ", " . htmlspecialchars($countryname); ?></title>

    <body>
      <p><?php echo $description?></p>
    </body>

    <?php if($url) { echo "<link>" . htmlspecialchars($url) . "</link>"; }?>

    <tags>
      <tag content=""><?php echo htmlspecialchars($countrycode); ?></tag>
      <?php
        foreach ($tags as $tag) {
          echo sprintf('<tag content="">%s</tag>', htmlspecialchars($tag)) . "\n";
        }
      ?>
      <tag>front-page</tag>
    </tags>


  </event>
</eventset>
