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
$wants_info = $data['wants_info'] ?? false;
$wants_newsletter_info = ['wants_newsletter_info'] ?? false;

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

# Check required variables
if (empty($list)  ||
    empty($mail)  ) {
  echo "Missing parameters. Required: list, mail";
  exit(1);
}

if ($wans_info or $wants_newsletter_info) {
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
    'language' => $lang,
    'wants_info' => $wants_info,
    'wants_newsletter_info' => $wants_newsletter_info,
  );
  mail_signup('https://my.fsfe.org/subscribe-api', $signupdata);
} else {
  echo "List to sign up email to is unknown. Exiting.";
  exit(1);
}

?>
