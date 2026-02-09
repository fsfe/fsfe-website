<?php
$acc_request = strtolower($_GET["resource"] ?? '')
$people = simplexml_load_file($_SERVER['DOCUMENT_ROOT'] . "about/people/people.en.xml")
foreach ($people->xpath("//fediverse")as $fedi_elem) {
  if ("acct:".strval($fedi_elem) == $acc_request) {
      foreach ($fedi_elem->attributes() as $key => $value) {
        if ($key == "location"){
      	  header("Location: ".$value);
      	}
	  }
	    // We will only ever match successfully once,
	    // so exit early if we match
	  exit;
  }
}
// No matches
http_response_code(404);
echo "404";
>
