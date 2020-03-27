<?php
// This script signs up an email address with other (partly optional) data
// to the community database (occasional emails) and the newsletter

// parse data from POST or cli arg
if (php_sapi_name() === 'cli') {
  $data = json_decode($argv[1], true);
} else {
  $data = $_POST;
}

$list = $data['list'] ?? false;
$mail = $data['mail'] ?? false;
$name = $data['name'] ?? false;
$lang = $data['lang'] ?? false;
$address = $data['address'] ?? false;
$zip = $data['zip'] ?? false;
$city = $data['city'] ?? false;
$country = $data['country'] ?? false;

# Generic function to make POST request
function mail_signup($url, $data) {
  $context = stream_context_create(
    array(
      'http' => array(
        'method' => 'POST',
        'header' => 'Content-type: application/x-www-form-urlencoded',
        'user_agent' => 'FSFE mail-signup.php',
        'content' => http_build_query($data),
        'timeout' => 10
      )
    )
  );
  // DEBUG: set a local URL here to catch the requests
  file_get_contents($url, FALSE, $context);
}

# Function to scrape the subscribe token from newsletter signup forms
function get_token($url) {
  $file = file_get_contents($url);
  $html = new DOMDocument();
  libxml_use_internal_errors(true);
  $html->loadHTML($file);
  libxml_clear_errors();
  $xpath = new DOMXPath($html);

  $results = $xpath->query("//form/input[@name='sub_form_token']/@value");
  foreach ($results as $result) {
    return $result->nodeValue;
  }
}

# Check required variables
if (empty($list)  ||
    empty($mail)  ) {
  echo "Missing parameters. Required: list, mail";
  exit(1);
}

# Check whether language is available as newsletter
$nllangs = array("be", "de", "el", "en", "es", "fi", "fr", "it", "nl", "pt", "ro", "ru", "sq", "sv");
if (in_array($lang, $nllangs)) {
  $nllang = $lang;
} else {
  $nllang = "en";
}

if ($list == 'community' ) {  // COMMUNITY
  # "name" is also required for Community Database
  if (empty($name)) {
    echo "Missing parameters. Required: name";
    exit(1);
  }
  $signupdata = array(
    'name' => $name,
    'email1' => $mail,
    'address' => $address,
    'zip' => $zip,
    'city' => $city,
    'country' => $country,
    'wants_info' => '1'
  );
  mail_signup('https://my.fsfe.org/subscribe', $signupdata);
} elseif ($list == 'newsletter') {  // NEWSLETTER
  $token = get_token('https://lists.fsfe.org/mailman/listinfo/newsletter-' . $nllang);
  // Wait a few seconds because mailman requests it in SUBSCRIBE_FORM_MIN_TIME
  sleep(10);
  $signupdata = array(
    'sub_form_token' => $token,
    'fullname' => $name,
    'email' => $mail,
    'digest' => 0,
    'email-button' => 'Subscribe'
  );
  mail_signup('https://lists.fsfe.org/mailman/subscribe/newsletter-' . $nllang, $signupdata);
} else {
  echo "List to sign up email to is unknown. Exiting.";
  exit(1);
}

?>
