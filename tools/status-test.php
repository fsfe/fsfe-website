<?php

/*
 * Implement the page http://status.fsfe.org/web-test/
 */

echo '
<!doctype html>
<html>
<head>
  <meta charset="utf-8" />
  <title>Build script output - test instance</title>
</head>
<body>

<h1>Build script output - test instance</h1>
<p><a href="http://status.fsfe.org/">« Back to <em>Web server status</em></a></p>
';

# If there is a currently running build, show its log
if ( file_exists('status.txt') ) {
  echo '
  <h2>Currently running build</h2>
  <p><pre>
  ';
  $status = file_get_contents("status.txt");
  echo htmlspecialchars($status);
  echo '
  </pre></p>
  ';
}

# If the last build failed or there were no changes to SVN, show its log
if ( file_exists('status-attempted.txt') ) {
  echo '
  <h2>Last attempted build</h2>
  <p><pre>
  ';
  $status = file_get_contents("status-attempted.txt");
  echo htmlspecialchars($status);
  echo '
  </pre></p>
  ';
}

# Always show the log of last finished build
echo '
<h2>Last finished build</h2>
<p><pre>
';
$statusfinished = file_get_contents("status-finished.txt");
echo htmlspecialchars($statusfinished);
echo '
</pre></p>

<h2>Other tools</h2>

<ul>
  <li><a href="./status-log.txt">Previously finished builds</a></li>
  <li><a href="https://trac.fsfe.org/fsfe-web/browser/branches/test">SVN web browser</a></li>
</ul>

</body>
</html>';
?>
