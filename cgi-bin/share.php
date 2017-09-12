<?php

// Default variables
$gnusocialuser = "@fsfe@quitter.no";
$twitteruser = "fsfe";
$flattruser = "fsfe";
$supporturl = "https://fsfe.org/donate?share";

// Don't change below here
$service = isset($_GET['service']) ? $_GET['service'] : false;
$url = isset($_GET['url']) ? $_GET['url'] : false;
$title = isset($_GET['title']) ? $_GET['title'] : false;
$ref = isset($_GET['ref']) ? $_GET['ref'] : false;
$diasporapod = isset($_GET['diasporapod']) ? $_GET['diasporapod'] : false;
$gnusocialpod = isset($_GET['gnusocialpod']) ? $_GET['gnusocialpod'] : false;

if(empty($service) || empty($url)) {
  echo 'At least one required variable is empty. You have to define at least service and url';
} else {

  $service = htmlspecialchars($service);
  $diasporapod = htmlspecialchars($diasporapod);
  $gnusocialpod = htmlspecialchars($gnusocialpod);
  $url = urlencode($url);
  $title = urlencode($title);
  
  if($ref == "pmpc-side" || $ref == "pmpc-spread") {
    $via_gs = "";
    $via_tw = "";
    $supporturl = "https://fsfe.org/donate?pmpc";
  } else {
    $via_gs = " via " . $gnusocialuser;
    $via_tw = "&via=" . $twitteruser;
  }
  
  if ($service === "diaspora") {
    $diasporapod = validateurl($diasporapod);
    header("Location: " . $diasporapod . "/bookmarklet?url=" . $url . "&title=" . $title);
    die();
  } elseif($service === "gnusocial") {
    $gnusocialpod = validateurl($gnusocialpod);
    header("Location: " . $gnusocialpod . "/notice/new?status_textarea=" . $title . " " . $url . $via_gs);
    die();
  } elseif($service === "reddit") {
    header("Location: https://reddit.com/submit?url=" . $url . "&title=" . $title);
    die();
  } elseif($service === "flattr") {
    header("Location: https://flattr.com/submit/auto?user_id=" . $flattruser . "&url=" . $url . "&title=" . $title);
    die();
  } elseif($service === "hnews") {
    header("Location: https://news.ycombinator.com/submitlink?u=" . $url . "&t=" . $title);
    die();
  } elseif($service === "twitter") {
    header("Location: https://twitter.com/share?url=" . $url . "&text=" . $title . $via_tw);
    die();
  } elseif($service === "facebook") {
    header("Location: https://www.facebook.com/sharer/sharer.php?u=" . $url);
    die();
  } elseif($service === "gplus") {
    header("Location: https://plus.google.com/share?url=" . $url);
    die();
  } elseif($service === "support") {
    header("Location: " . $supporturl);
    die();
  } else {
    echo 'Social network unknown.';
  }
}

// If diaspora/GS pod has been typed without http(s):// prefix, add it
function validateurl($url) {
  if (preg_match('#^https?://#i', $url) === 0) {
    return 'https://' . $url;
  } else {
    return $url;
  }
}

?>
