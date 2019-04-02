<?php
// This script signs up an email address with other (partly optional) data
// to the community database (occasional emails) and the newsletter

// Available POST params: list, mail, name, language, address, zip, city, country

$list = isset($_POST['list']) ? $_POST['list'] : false;
$mail = isset($_POST['mail']) ? $_POST['mail'] : false;
$name = isset($_POST['name']) ? $_POST['name'] : false;
$language = isset($_POST['language']) ? $_POST['language'] : false;
$address = isset($_POST['address']) ? $_POST['address'] : false;
$zip = isset($_POST['zip']) ? $_POST['zip'] : false;
$city = isset($_POST['city']) ? $_POST['city'] : false;
$country = isset($_POST['country']) ? $_POST['country'] : false;

# Check required variables
if (empty($list)  ||
    empty($mail)  ) {
  echo "Missing parameters. Required: list, mail";
  exit(1);
}

if ($list == 'community' ) {
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
    'country' => $country
  );
  print_r($signupdata);
  mail_signup('https://my.fsfe.org/subscribe', $signupdata);
} elseif ($list == 'newsletter') {
  echo "";
} else {
  echo "List to sign up email to is unknown. Exiting.";
  exit(1);
}

function mail_signup($url, $data) {
  $context = stream_context_create(
    array( 
      'http' => array( 
        'method' => 'POST', 
        'header' => 'Content-type: application/x-www-form-urlencoded', 
        'content' => http_build_query($data), 
        'timeout' => 10
      )
    )
  );
  file_get_contents($url, FALSE, $context);
}

?>
