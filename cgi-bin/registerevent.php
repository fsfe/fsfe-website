<?php
/* Copyright (C) 2012, Tobias Bengfort <tobias.bengfort@gmx.net> & Marius Jammes for FSFE e.V.
 
	This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>. */

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
	return (!$dt['errors'] && $dt['year'] && preg_match("#^(19|20)\d\d[- /.](0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01])$#", $date) === 1);
}

function send_registration_mail($from, $to) {
	$data = array(
		'name' => $_POST['name'],
		'email' => $_POST['email'],
		'title' => $_POST['title'],
		'groupname' => $_POST['groupname'],
		'groupurl' => $_POST['groupurl'],
		'startdate' => $_POST['startdate'],
		'enddate' => $_POST['enddate'],
		'description' => $_POST['description'],
		'url' => $_POST['url'],
		'location' => $_POST['location'],
		'city' => $_POST['city'],
		'countrycode' => explode('|', $_POST['country'])[0],
		'countryname' => explode('|', $_POST['country'])[1],
		'tags' => $_POST['tags'],
		'lang' => $_POST['lang']
	);

	$data['event'] = eval_template('registerevent/event.php', $data);
	$data['wiki'] = eval_template('registerevent/wiki.php', $data);

	$message = eval_template('registerevent/mail.php', $data);

	$subject = "Event registration: " . $_POST['title'];
	$headers = "From: " . $from . "\n"
		. "MIME-Version: 1.0\n"
                . "X-OTRS-Queue: Events\n"
		. "Content-Type: multipart/mixed; boundary=boundary";

  // uncomment for local debug
  // print_r($message);
  // exit(0);

	mail($to, $subject, $message, $headers);

	return $data['img_error'];
}

if ( isset($_POST['register_event']) AND empty($_POST['spam']) AND eval_date($_POST['startdate']) AND eval_date($_POST['enddate']) || empty($_POST['enddate'])  ) {
	$error = send_registration_mail($_POST['name'] . " <" . $_POST['email'] . ">", "FSFE <contact@fsfe.org>");
	$error = send_registration_mail("FSFE <contact@fsfe.org>", $_POST['name'] . " <" . $_POST['email'] . ">");

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
