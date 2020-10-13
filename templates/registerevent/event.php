<?php echo '<?xml version="1.0" encoding="utf-8"?>'; ?>

<eventset>
  <version>1</version>
  <event start="<?php echo htmlspecialchars($startdate) ?>" end="<?php if($enddate) { echo htmlspecialchars($enddate); } else { echo htmlspecialchars($startdate); }?>">
    <?php if($online === "yes") { $location = " ($location)"; } else { $location = " in " . $location; } ?>
    <title><?php echo htmlspecialchars($title) . $location ?></title>

    <body>
      <p><?php echo str_replace("</p><p>","</p>\n      <p>",nl2br(preg_replace("/(\r?\n){2,}/", "</p><p>", htmlspecialchars($description)))); ?></p>
    </body>

    <?php if($url) { echo "<link>" . htmlspecialchars($url) . "</link>"; }?>

    <tags>
      <?php if($online !== "yes") { ?><tag key="<?php echo strtolower(htmlspecialchars($countrycode)); ?>"><?php echo htmlspecialchars($countryname); ?></tag><?php } ?>
      <?php
        foreach ($tags as $tag) {
          echo sprintf('<tag key="%s"/>', htmlspecialchars($tag)) . "\n";
        }
      ?>
      <tag key="front-page"/>
    </tags>
  </event>
</eventset>
