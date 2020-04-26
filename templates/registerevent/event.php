<?php echo '<?xml version="1.0" encoding="utf-8"?>'; ?>

<eventset>
  <event start="<?php echo htmlspecialchars($startdate) ?>" end="<?php if($enddate) { echo htmlspecialchars($enddate); } else { echo htmlspecialchars($startdate); }?>">

    <title><?php echo htmlspecialchars($title) . " in " . htmlspecialchars($city) . ", " . htmlspecialchars($countryname); ?></title>

    <body>
      <p><?php echo str_replace("</p><p>","</p>\n      <p>",nl2br(preg_replace("/(\r?\n){2,}/", "</p><p>", htmlspecialchars($description)))); ?></p>
    </body>

    <?php if($url) { echo "<link>" . htmlspecialchars($url) . "</link>"; }?>

    <tags>
      <tag key="<?php echo htmlspecialchars($countrycode); ?>"><?php echo htmlspecialchars($countryname); ?></tag>
      <?php
        foreach ($tags as $tag) {
          echo sprintf('<tag key="%s"/>', htmlspecialchars($tag)) . "\n";
        }
      ?>
      <tag key="front-page"/>
    </tags>
  </event>
</eventset>
