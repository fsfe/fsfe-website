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
/*
function json2xml($json) {
	// a quick hack for converting the nominatim data. 
	// this will probably not work elsewhere

	if ( !$json )
		return '';

	$result = '';
	$place = json_decode($json);

	$result .= "<place>\n";
	foreach ( $place as $key => $value ) {
		$result .= "\t<$key>";
		if ( is_string($value) )
			$result .= "$value";
		elseif ( is_array($value) )
			$result .= implode(',', $value);
		else {
			$result .= "\n";
			foreach ( $value as $k => $v )
				$result .= "\t\t<$k>$v</$k>\n";
			$result .= "\t";
		}
		$result .= "</$key>\n";
	}
	$result .= "</place>";
	return $result;
}
*/
//removed partner img function

function eval_date($date) {
	$dt = date_parse($date);
	return (!$dt['errors'] && $dt['year']);
}


function send_registration_mail() {
	$data = array(
		'name' => $_POST['name'],
		'email' => $_POST['email'],
		'title' => $_POST['title'],
		'groupname' => $_POST['groupname'],
		'groupurl' => $_POST['groupurl'],
		'date' => $_POST['date'],
		'description' => $_POST['description'],
		'url' => htmlspecialchars($_POST['url']),
		'location' => $_POST['location'],
		'cityandcountry' => $_POST['cityandcountry'],
		'register_partner' => isset($_POST['register_partner']),
	);

//	$data = array_merge($data, partner_img());
/*
	$geodata_json = rawurldecode($_POST['geodata']);
	if ( $geodata_json ) {
		$geodata = json_decode($geodata_json);

		foreach ( $geodata->address as $k => $v )
			$data["geo_$k"] = $v;

		$data['geodata'] = preg_replace("/\n/", "\n\t\t", json2xml($geodata_json));

		$data['location'] = $geodata->address->city . ", " . $geodata->address->country; // overwriting the value given by the user
	}
*/
//	$data['event'] = eval_template('registerevent/event.php', $data);

	$message = eval_template('registerevent/mail.php', $data);

	$to = "pavi@fsfe.org";
	$subject = "event registration: " . $_POST['groupname'];
	$headers = "From: pavi@fsfe.org\n"
		. "MIME-Version: 1.0\n"
		. "Content-Type: multipart/mixed; boundary=boundary";

	mail($to, $subject, $message, $headers);

	return $data['img_error'];
}

if ( isset($_POST['register_event']) && empty($_POST['spam']) && eval_date($_POST['date']) ) {
	$error = send_registration_mail();

	echo eval_xml_template('registerevent/success.en.html', array(
		'notice' => '', // TODO display some error code here
	));
}
else {
	echo eval_xml_template('blank.en.html', array(
		'head' => '<title>Error!</title>',
		'body' => '<h1>Oops!</h1>
			<p>You probably shouldn\'t be here.</p>',
	));
}

?>
