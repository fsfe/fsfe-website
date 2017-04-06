<?php
    /**
     * LICENSE: Mozilla Public License 2.0
     * Programmed by chimo on https://github.com/chimo/gs-share
     * Git commit 1730d30
     * /
    
    
    /**
     * Script to share a page on a GNU social instance
     *
     * I should make this OO and fix the mess eventually.
     * The error message logic is especially bad.
     */

    // Make sure warnings aren't printed and interfere with header()
    error_reporting(E_ALL ^ E_WARNING);

    // Error message
    global $err;
    $err = '';

    // GET parameters
    $action   = m_get('action');
    $userid   = m_get('userid');
    $url      = m_get('url');
    $title    = m_get('title');

    // Split userid into username and domain
    $parts = explode('@', $userid);

    if ($userid && count($parts) !== 2) {
        $err = 'Invalid User ID';
    } else if ($userid) {
        $username = $parts[0];
        $domain = 'http://' . $parts[1];

        switch ($action) {
            // Return instance info in JSON format
            case 'poke':
                returnJSON($username, $domain);
                break;
            // Redirect to the instance's posting page
            case 'share':
                share($username, $domain, $title, $url);
                break;
        }
    }

    /**
     * $_GET wrapper
     *
     * Just to get rid of warnings when value isn't in array
     */
    function m_get($param) {
        return isset($_GET[$param]) ? $_GET[$param] : null;
    }

    /**
     * curl wrapper
     */
    function m_curl($url, $nobody = false) {
        global $err;

        $ch = curl_init($url);

        $ch_options =  array(
            CURLOPT_RETURNTRANSFER => true, // Return the content instead of displaying it
            CURLOPT_NOBODY => $nobody,      // HTTP HEAD request (true for bookmark check)
            CURLOPT_HEADER => false,        // Don't want HTTP headers
            CURLOPT_FOLLOWLOCATION => true, // It's possible we need to switch to https
            CURLOPT_MAXREDIRS => 3          // Don't follow redirects to infinity and beyond
        );

        curl_setopt_array(
            $ch,
            $ch_options
        );

        $data = curl_exec($ch);

        if (curl_errno($ch)) {
            $err = curl_error($ch);
        }

        curl_close($ch);

        return $data;
    }

    /**
     * Get some information about the instance
     *
     * fancy urls, bookmark plugin, api root
     */
    function poke($username, $domain) {
        global $err;

        $instanceInfo = array();

        // Get HTML
        $html = m_curl($domain);
        if ($html === false) {
            // $err set by m_curl
            return false;
        }

        // Build DOM
        $doc = new DOMDocument();
        $doc->loadHTML($html, LIBXML_NOWARNING);

        // Get RSD uri
        $xpath = new DOMXpath($doc);
        $nodes = $xpath->query('//html/head/link[@rel="EditURI"]/@href');
        if ($nodes === false || $nodes->length === 0) {
            $err = 'Unable to find EditURI value for RSD';
            return false;
        }
        $editURI = $nodes->item(0)->nodeValue;

        // Fetch RSD xml
        $rsd = m_curl($editURI);
        if ($rsd === false) {
            // $err set by m_curl
            return false;
        }

        // Get API root
        $xml = simplexml_load_string($rsd);
        $xml->registerXPathNamespace('rsd', 'http://archipelago.phrasewise.com/rsd');
        $elems = $xml->xpath('//rsd:apis/rsd:api[@name="Twitter"]/@apiLink');
        if ($elems === false || count($elems) === 0) {
            $err = 'Unable to find API root';
            return false;
        }
        $apiRoot = (string)$elems[0];
        $instanceInfo['apiRoot'] = $apiRoot;

        // Get instance configs
        $json = m_curl($apiRoot . 'statusnet/config.json');
        if ($json === false) {
            // $err set by m_curl
            return false;
        }
        $json = json_decode($json);

        // Are fancy URLs enabled?
        if ($json->site->fancy === null) {
            // Assume they're enabled if we couldn't verify
            $instanceInfo['fancy'] = true;
        } else {
            $instanceInfo['fancy'] = (bool)$json->site->fancy;
        }

        // TODO: don't check this if m_get('bookmark') is null
        //       this means the JS will need to include 'bookmark' param when querying

        // Is the bookmark plugin enabled?
        $json = m_curl($apiRoot . 'bookmarks/' . $username . '.json', true);
        if ($json === false) {
            // Assume it's not enabled if we couldn't verify
            $instanceInfo['bookmarks'] = false;
        } else {
            $instanceInfo['bookmarks'] = true;
        }

        return $instanceInfo;
    }

    /**
     * Returns information about the instance collected by poke() in JSON format
     */
    function returnJSON($username, $domain) {
        global $err;
        $instanceInfo = poke($username, $domain);

        if ($instanceInfo === false) {
            $instanceInfo = array('error' => $err);
        }

        header('Content-Type: application/json');
        echo json_encode($instanceInfo);
        exit(0);
    }

    function share($username, $domain, $title, $url) {
        $instanceInfo = poke($username, $domain);
        $bookmark = m_get('bookmark');

        if ($instanceInfo !== false && $instanceInfo['fancy'] === false) {
            $domain = $domain . '/index.php';
        }

        if ($instanceInfo === false || $instanceInfo['bookmarks'] === false || $bookmark === null) {
            shareAsNotice($domain, $title, $url);
        } else {
            shareAsBookmark($domain, $title, $url);
        }
    }

    function shareAsNotice($domain, $title, $url) {
        header('Location: ' . $domain . '/notice/new?status_textarea=' . urlencode($title) . ' ' . urlencode($url));
    }

    function shareAsBookmark($domain, $title, $url) {
        header('Location: ' . $domain . '/main/bookmark/new?title=' . urlencode($title) . '&url=' . urlencode($url));
    }

?>

<!DOCTYPE html>
<html>
<head>
    <title>Share on GNU social</title>
    <style>
        input[type="text"], input[type="submit"], input[type="url"] {
            display: block;
            margin-bottom: 8px;
        }

        input[type="submit"] {
            margin-top: 8px;
        }
    </style>
</head>
<body>
    <div class="err"><?php echo htmlspecialchars($err, ENT_QUOTES | ENT_HTML5); ?></div>

    <form action="">
        <fieldset>
            <legend>Share on GNU social</legend>

            <label for="userid">User ID:</label>
            <input id="userid" type="text" name="userid" placeholder="username@example.org" value="<?php echo htmlspecialchars($userid, ENT_QUOTES | ENT_HTML5); ?>" />

            <label for="title">Title:</label>
            <input id="title" type="text" name="title" value="<?php echo htmlspecialchars($title, ENT_QUOTES | ENT_HTML5); ?>" />

            <label for="url">URL:</label>
            <input id="url" type="url" name="url" value="<?php echo htmlspecialchars($url, ENT_QUOTES | ENT_HTML5); ?>" />

            <input id="bookmark" type="checkbox" name="bookmark" value="bookmark" checked /> <label for="bookmark">Share as a bookmark</label>

            <input type="hidden" name="action" value="share" />

            <input type="submit" />
        </fieldset>
    </form>
</body>
</html>

