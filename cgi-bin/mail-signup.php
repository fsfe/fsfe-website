<?php
// This script signs up an email address with other (partly optional) data
// to the community database (occasional emails and the newsletter)

// parse data from POST or cli arg
if (php_sapi_name() === 'cli') {
  $data = json_decode($argv[1], true);
} else {
  $data = $_POST;
}

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

# Check expected/required variables are set
if (empty($data['email1']) ||
    empty($data['name']) ||
    empty($data['address']) ||
    empty($data['zip']) ||
    empty($data['city'])) {
  echo "Missing parameters. Some required parameters are missing (name, address, mail)";
  exit(1);
}

if ($data['wants_info'] or $data['wants_newsletter_info']) {
  mail_signup('https://my.fsfe.org/subscribe-api', $signupdata);
} else {
  echo "List to sign up email to is unknown. Exiting.";
  exit(1);
}

?>
