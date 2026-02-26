<?php

$acc_request = strtolower($_GET['resource'] ?? '');
$people = simplexml_load_file($_SERVER['DOCUMENT_ROOT'].'about/people/people.en.xml');
foreach ($people->xpath('//fediverse') as $fedi_elem) {
    if ('acct:'.strval($fedi_elem) == $acc_request) {
        // if we have a location, return it and exit
        if (isset($fedi_elem['location'])) {
            header('Location: '.strval($fedi_elem['location']));

            exit;
        }
        http_response_code(500);
        echo 'ERROR: fediverse element has no location attribute!';

        exit;
    }
}
// No matches
http_response_code(404);
echo '404 matching person not found';
