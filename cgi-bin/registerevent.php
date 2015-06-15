<?php
// Copyright (C) 2012 by Tobias Bengfort <tobias.bengfort@gmx.net>

function eval_xml_template($template, $data) {
	$dir = realpath(dirname(__FILE__) . '/../templates');
	$result = file_get_contents("$dir/$template");
	foreach ($data as $key => $value)
		$result = preg_replace("/<tpl name=\"$key\"><\/tpl>/", $value, $result);
	$result = preg_replace("/<tpl name=\"[^\"]*\"><\/tpl>/", '', $result);
	return $result;
}

function eval_template($template, $data) {
	extract($data);
	$dir = realpath(dirname(__FILE__) . '/../templates');
	ob_start();
	include("$dir/$template");
	$result = ob_get_contents();
	ob_end_clean();
	return $result;
}
// deleted resize image


function get_mime_type($path) {
	if ( function_exists('finfo_open') ) {
		$finfo = finfo_open(FILEINFO_MIME_TYPE);
		$mime = finfo_file($finfo, $path);
		finfo_close($finfo);
		return $mime;
	}
	else
		return mime_content_type($path);
}
//removed partner img function

function eval_date($date) {
	$dt = date_parse($date);
	if ( preg_match([0-9]{4}, $dt['year']) {
		return (!$dt['errors'] && $dt['year']);
	}
}


function send_registration_mail() {
	$data = array(
		'name' => $_POST['name'],
		'email' => $_POST['email'],
		'title' => $_POST['title'],
		'groupname' => $_POST['groupname'],
		'groupurl' => $_POST['groupurl'],
		'startdate' => $_POST['startdate'],
		'enddate' => $_POST['enddate'],
		'description' => $_POST['description'],
		'url' => htmlspecialchars($_POST['url']),
		'location' => $_POST['location'],
		'city' => $_POST['city'],
		'country' => $_POST['country'],
	);

	$data['event'] = eval_template('registerevent/event.php', $data);

	$message = eval_template('registerevent/mail.php', $data);

	$to = $_POST['email'].",eal@fsfe.org";
	$subject = "event registration: " . $_POST['name'];
	$headers = "From: no-reply@fsfe.org\n"
		. "CC: fellowship@fsfeurope.org\n"
		. "MIME-Version: 1.0\n"
		. "Content-Type: multipart/mixed; boundary=boundary";

	mail($to, $subject, $message, $headers);

	return $data['img_error'];
}

if ( isset($_POST['register_event']) && empty($_POST['spam']) && eval_date($_POST['startdate']) ) {
	$error = send_registration_mail();

	echo eval_xml_template('registerevent/success.en.html', array(
		'notice' => '', // TODO display some error code here
	));
}
else {
	echo eval_xml_template('registerevent/error.en.html', array(
		'notice' => '', // TODO display the error here
	));
}

?>
