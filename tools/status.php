<!doctype html>
<html>
<head>
	<meta charset="utf-8" />
  <title>Build script output / Web server status</title>
	<style>

		body {
			background-color: white;
			font-family: sans-serif;
		}

	</style>
</head>
 <body>

	<h1>Build script output</h1>

	<p><a href="http://status.fsfe.org/">« Back to <em>Web server status</em></a></p>


	<h2>Last attempted or currently running build</h2>

	<pre>
<?php 
$status = file_get_contents("status.txt");
echo htmlspecialchars($status);
?>
	</pre>


	<h2>Last finished build</h2>

	<pre>
<?php 
$statusfinished = file_get_contents("status-finished.txt");
echo htmlspecialchars($statusfinished);
?>
	</pre>

	<p><a href="./status-log.txt">Previously finished builds</a></p>
	<p><a href="http://cvs.savannah.gnu.org/viewvc/fsfe/fsfe/?root=Web">CVS web interface</a></p>

</body>
</html>

