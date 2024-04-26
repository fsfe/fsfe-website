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

function send_registration_mail() {
	// do some prior location computation
	$countrycode = explode('|', $_POST['country'])[0];
	$countryname = explode('|', $_POST['country'])[1];

	if($_POST['online'] === "yes") {
		$location = "online";
	} else {
		$location = htmlspecialchars($_POST['city']) . ", " . htmlspecialchars($countryname);
	}

	$data = array(
		'name' => isset($_POST['name'])?$_POST['name']:"",
		'email' => isset($_POST['email'])?$_POST['email']:"",
		'title' => isset($_POST['title'])?$_POST['title']:"",
		'groupname' => isset($_POST['groupname'])?$_POST['groupname']:"",
		'groupurl' => isset($_POST['groupurl'])?$_POST['groupurl']:"",
		'startdate' => isset($_POST['startdate'])?$_POST['startdate']:"",
		'enddate' => isset($_POST['enddate'])?$_POST['enddate']:"",
		'description' => isset($_POST['description'])?$_POST['description']:"",
		'url' => isset($_POST['url'])?$_POST['url']:"",
		'online' => isset($_POST['online'])?$_POST['online']:"",
		'location' => $location,
		'countryname' => $countryname,
		'countrycode' => $countrycode,
		'tags' => isset($_POST['tags'])?$_POST['tags']:"",
		'lang' => isset($_POST['lang'])?$_POST['lang']:""
	);

	$event = eval_template('registerevent/event.php', $data);
	$wiki = eval_template('registerevent/wiki.php', $data);

	$subject = "Event registration: " . $_POST['title'];

  // uncomment for local debug
  // print_r($message);
  // exit(0);

	/**
	 * Create a new ticket in the FreeScout system
	 */
	$url = "https://helpdesk.fsfe.org/api/conversations";
	$apikey = getenv('FREESCOUT_API_KEY');
	$jsondata = [
		"type"      => "email",
		"mailboxId" => 5,         # This is the General Helpdesk
		"subject"   => $subject,
		"customer"  => [
			"email" => $_POST['email'],
			"firstName" => $_POST['name'],
		],
		"threads" => [
			[
				"text"     => eval_template('registerevent/mailstaff.php', $data),
				"type"     => "customer",
				"customer" => [
					"email" => $_POST['email'],
					"firstName" => $_POST['name'],
				],
				"attachments" => [
					[
						"fileName" => "wiki.txt",
						"mimeType" => "plain/text",
						"data"     => base64_encode($wiki)
					],
					[
						"fileName" => "event-" . str_replace("-", "", $data['startdate']) . "-01." . $data['lang'] .".xml",
						"mimeType" => "application/xml",
						"data"     => base64_encode($event)
					]
				]
			],
			[
			  "text"     => eval_template('registerevent/mail.php', $data),
			  "type"     => "message",
			  "user"     => 6530,
			  "attachments" => [
				  [
					  "fileName" => "wiki.txt",
					  "mimeType" => "plain/text",
					  "data"     => base64_encode($wiki)
				  ],
				  [
					  "fileName" => "event-" . str_replace("-", "", $data['startdate']) . "-01." . $data['lang'] .".xml",
					  "mimeType" => "application/xml",
					  "data"     => base64_encode($event)
				  ]
			  ]
			]
		],
		"imported"     => false,
		"status"       => "active",
	];
	$jsonDataEncoded = json_encode($jsondata);

	$curl = curl_init();
	curl_setopt_array($curl, [
	CURLOPT_RETURNTRANSFER => 1,
	CURLOPT_URL => $url,
	CURLOPT_POST => 1,
	CURLOPT_CUSTOMREQUEST => "POST",
	CURLOPT_POSTFIELDS => $jsonDataEncoded,
	CURLOPT_HTTPHEADER => [
		"Content-Type: application/json",
		"Content-Length: " . strlen($jsonDataEncoded),
		"X-FreeScout-API-Key: " . $apikey
	],
	CURLOPT_USERAGENT => 'FSFE registerevent.php'
	]);
	$response = curl_exec($curl);
	curl_close($curl);

	return $response;
}

if ( isset($_POST['register_event']) AND empty($_POST['spam']) AND eval_date($_POST['startdate'])
	AND ( $_POST['startdate']>"2023-01-01") AND ( eval_date($_POST['enddate']) ) || empty($_POST['enddate'])
	AND ( !stripos($_POST['email'], 'example.com')) ) {

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
