<?php

/*
* SPDX-FileCopyrightText: 2019 Free Software Foundation Europe e.V. <https://fsfe.org>
* SPDX-FileCopyrightText: 2018 Daniel Martin Gomez
* SPDX-License-Identifier: AGPL-3.0-or-later
*
* share-buttons: Share buttons for many social networks and services
* Upstream: https://git.fsfe.org/FSFE/share-buttons
*/

// load config. You normally don't want to edit something here
require_once 'share-config.php';
$fediverseuser = $config['fediverseuser'];
$diasporauser = $config['diasporauser'];
$twitteruser = $config['twitteruser'];
$flattruser = $config['flattruser'];
$supporturl = $config['supporturl'];
$sharepic = $config['sharepic'];

$service = isset($_GET['service']) ? $_GET['service'] : false;
$url = isset($_GET['url']) ? $_GET['url'] : false;
$title = isset($_GET['title']) ? $_GET['title'] : false;
$ref = isset($_GET['ref']) ? $_GET['ref'] : false;
$fediversepod = isset($_GET['fediversepod']) ? $_GET['fediversepod'] : false;

if (empty($service) || empty($url)) {
    echo 'At least one required variable is empty. You have to define at least service and url';
} else {
    $service = htmlspecialchars($service);
    $fediversepod = htmlspecialchars($fediversepod);
    $url = urlencode($url);
    $title = urlencode($title);

    // Special referrers for FSFE campaigns
    if ('pmpc-side' == $ref || 'pmpc-spread' == $ref) {
        $via_fed = '';
        $via_tw = '';
        $via_dia = '';
        $sharepic = 'https://sharepic.fsfe.org/pmpc';
        $supporturl = 'https://my.fsfe.org/donate?referrer=pmpc';
    } else {
        $via_fed = ' via '.$fediverseuser;
        $via_tw = '&via='.$twitteruser;
        $via_dia = ' via '.$diasporauser;
    }

    if ('fediverse' === $service) {
        $fediversepod = validateurl($fediversepod);
        $fediverse = which_fediverse($fediversepod);
        if ('mastodon' === $fediverse) {
            // Mastodon
            header('Location: '.$fediversepod.'/share?text='.$title.' '.$url.$via_fed);
        } elseif ('diaspora' === $fediverse) {
            // Diaspora
            header('Location: '.$fediversepod.'/bookmarklet?url='.$url.'&title='.$title.$via_dia);
        } elseif ('gnusocial' === $fediverse) {
            // GNU Social
            header('Location: '.$fediversepod.'/notice/new?status_textarea='.$title.' '.$url.$via_fed);
        } else {
            echo 'Your Fediverse instance is unknown. We cannot find out which service it belongs to, sorry.';
        }

        exit;
    }
    if ('reddit' === $service) {
        header('Location: https://reddit.com/submit?url='.$url.'&title='.$title);

        exit;
    }
    if ('flattr' === $service) {
        header('Location: https://flattr.com/submit/auto?user_id='.$flattruser.'&url='.$url.'&title='.$title);

        exit;
    }
    if ('hnews' === $service) {
        header('Location: https://news.ycombinator.com/submitlink?u='.$url.'&t='.$title);

        exit;
    }
    if ('twitter' === $service) {
        header('Location: https://twitter.com/share?url='.$url.'&text='.$title.$via_tw);

        exit;
    }
    if ('facebook' === $service) {
        header('Location: https://www.facebook.com/sharer/sharer.php?u='.$url);

        exit;
    }
    if ('gplus' === $service) {
        header('Location: https://plus.google.com/share?url='.$url);

        exit;
    }
    if ('sharepic' === $service) {
        header('Location: '.$sharepic);

        exit;
    }
    if ('support' === $service) {
        header('Location: '.$supporturl);

        exit;
    }
    echo 'Social network unknown.';
}

// Sanitise URLs
function validateurl($url)
{
    // If Fediverse pod has been typed without http(s):// prefix, add it
    if (0 === preg_match('#^https?://#i', $url)) {
        $url = 'https://'.$url;
    }

    // remove trailing spaces and slashes
    return trim($url, ' /');
}

// Is $pod a Mastodon instance or a GNU Social server?
function getFediverseNetwork($pod)
{
    $curl = curl_init($pod.'/api/statusnet/version.xml');
    curl_exec($curl);
    $code = curl_getinfo($curl, CURLINFO_HTTP_CODE);
    curl_close($curl);
    if (200 == $code) {
        // GNU social server
        return 0;
    }

    // Mastodon server
    return 1;
}

function which_fediverse($pod)
{
    if (check_httpstatus($pod.'/api/v1/instance')) {
        // Mastodon
        return 'mastodon';
    }
    if (check_httpstatus($pod.'/api/statusnet/version.xml')) {
        // GNU social
        return 'gnusocial';
    }
    if (check_httpstatus($pod.'/users/sign_in')) {
        // Diaspora
        return 'diaspora';
    }

    return 'none';
}

function check_httpstatus($url)
{
    $headers = get_headers($url, 1);
    // check up to 2 redirections
    if (array_key_exists('2', $headers)) {
        $httpstatus = $headers[2];
    } elseif (array_key_exists('1', $headers)) {
        $httpstatus = $headers[1];
    } else {
        $httpstatus = $headers[0];
    }
    // check if HTTP status is 200
    if (false !== strpos($httpstatus, '200 OK')) {
        return true;
    }

    return false;
}
