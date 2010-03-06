<!doctype html>
<html>
	<head>
		<meta charset="utf-8" />
	  <title>Build script output</title>
	</head>
	<body>

		<h1>Build script output</h1>

		<p>
			<a href="http://status.fsfe.org/">« Back to <em>Web server 
				status</em></a>
		</p>


		<h2>Last attempted or currently running build</h2>

		<p>
			<pre>
<?php 
$status = file_get_contents("status.txt");
echo htmlspecialchars($status);
?>
			</pre>
		</p>


		<h2>Last finished build</h2>

		<p>
			<pre>
<?php 
$statusfinished = file_get_contents("status-finished.txt");
echo htmlspecialchars($statusfinished);
?>
			</pre>
		</p>


		<h2>Other tools</h2>

		<ul>
			<li><a href="./status-log.txt">Previously finished builds</a></li>
			<li><a href="https://trac.fsfe.org/fsfe-web/browser/trunk">SVN web browser</a></li>
		</ul>
	</body>
</html>

