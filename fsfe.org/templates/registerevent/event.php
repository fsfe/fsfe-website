<?php echo '<?xml version="1.0" encoding="utf-8"?>'; ?>

<eventset>
  <version>1</version>
  <event start="<?php echo htmlspecialchars($startdate); ?>" end="<?php if (
      $enddate
  ) {
      echo htmlspecialchars($enddate);
  } else {
      echo htmlspecialchars($startdate);
  } ?>">
    <?php if ('yes' === $online) {
        $location = " ({$location})";
        $countrycode = "ONLINE";
    } else {
        $location = ' in '.$location;
    } ?>
    <country><?php echo htmlspecialchars($countrycode) ?></country>
    <city><?php echo htmlspecialchars($city) ?> </city>
    <series><?php echo htmlspecialchars($eventseries);echo "-";echo htmlspecialchars($eventseriesyear); ?></series>
    <title><?php echo htmlspecialchars($title).$location; ?></title>
    <group>
     <name><?php echo htmlspecialchars($groupname); ?></name> 
     <url><?php echo htmlspecialchars($groupurl); ?></url>
    </group>

    <body>
      <p><?php echo str_replace(
          '</p><p>',
          "</p>\n     <p>",
          nl2br(
              preg_replace(
                  "/(\r?\n){2,}/",
                  '</p><p>',
                  htmlspecialchars($description)
              )
          )
      ); ?></p>
    </body>

    <?php if ($url) {
        echo '<link>'.htmlspecialchars($url).'</link>';
    } ?>

    <tags>
      <?php if ('yes' !== $online) { ?>
      <tag key="<?php echo strtolower(htmlspecialchars($countrycode)); ?>">
          <?php echo htmlspecialchars($countryname); ?>
      </tag>
      <?php } ?>
      <?php foreach ($tags as $tag) {
          echo sprintf('<tag key="%s"/>', htmlspecialchars($tag))."\n";
      } ?>
      <tag key="front-page"/>
    </tags>
  </event>
</eventset>
