<html>
  <title>Web server status</title>
  <body>
    <h1>Web server status</h1>

    <h2>Last attempted or currently running build</h2>

    <pre>
<?php 
$status=file_get_contents("status.txt");
echo htmlspecialchars($status);
?>
    </pre>

    <h2>Last finished build</h2>

    <pre>
<?php 
$statusfinished=file_get_contents("status-finished.txt");
echo htmlspecialchars($statusfinished);
?>
    </pre>

    <a href="./status-log.txt">Previously finished builds</a>
    <br />
    <br />
    <a href="http://cvs.savannah.gnu.org/viewvc/fsfe/fsfe/?root=Web">CVS web interface</a>
  </body>
</html>
