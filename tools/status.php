<html>
  <title>Web server status</title>
  <body>
    <h1>Web server status</h1>

    <h2>Last attempted or currently running build</h2>

    <pre>
<? include ("status.txt") ?>
    </pre>

    <h2>Last finished build</h2>

    <pre>
<? include ("status-finished.txt") ?>
    </pre>
  </body>
</html>
