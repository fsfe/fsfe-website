<?php

$service = isset($_GET['service']) ? $_GET['service'] : false;
$url = isset($_GET['url']) ? $_GET['url'] : false;
$title = isset($_GET['title']) ? $_GET['title'] : false;

if(empty($service) || empty($url)) {
  echo 'At least one required variable is empty. You have to define at least service and url';
}
else {
  $service = htmlspecialchars($service);
  $url = urlencode(htmlspecialchars($url));
  $title = urlencode(htmlspecialchars($title));
  
  if ($service === "diaspora") {
    header("Location: https://sharetodiaspora.github.io/?url=" . $url . "&title=" . $title);
    die();
  } elseif($service === "twitter") {
    header("Location: https://twitter.com/share?url=" . $url . "&text=" . $title . "&via=fsfe");
    die();
  } elseif($service === "reddit") {
    header("Location: https://reddit.com/submit?url=" . $url . "&title=" . $title);
    die();
  } elseif($service === "facebook") {
    header("Location: https://www.facebook.com/sharer/sharer.php?u=" . $url);
    die();
  } elseif($service === "flattr") {
    header("Location: https://flattr.com/submit/auto?user_id=fsfe&url=" . $url . "&title=" . $title);
    die();
  } elseif($service === "gplus") {
    header("Location: https://plus.google.com/share?url=" . $url);
    die();
  } elseif($service === "hnews") {
    header("Location: https://news.ycombinator.com/submitlink?u=" . $url . "&t=" . $title);
    die();
  } elseif($service === "gnusocial") {
    header("Location: https://fsfe.org/cgi-bin/share-gnusocial.php?url=" . $url . "&title=" . $title);
    die();
  } elseif($service === "support") {
    header("Location: https://fsfe.org/donate?share");
    die();
  } else {
    echo 'Social network unknown.';
  }
}

?>
