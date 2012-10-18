<?php
/**
 * Interface script between the supporter sign-up forms (standalone or AJAX)
 * and CiviCRM instance
 *
 * Uses CiviCRM API to create or update users that want to become FSFE
 * supporters
 */

// CiviCRM API key
//const CIVICRM_API_KEY = '5d7b5ec0c6018bed63fbab4399e7526c'; FSFE
const CIVICRM_API_KEY = 'a7680d4cb8a6e2d68f06a47b1f692c09'; // Léoserveur
const CIVICRM_API_URL = 'http://fsfe.leoserveur.org/civicrm/ajax/rest?';

$statement = 'json=1&sequential=1&debug=1&entity=Contact';

// FIXME: used for debug purposes only - remember to deactivate for production
ini_set( 'display_errors','1' );
ERROR_REPORTING( E_ALL) ;

// Allow XMLHttpRequest from any domain
header( 'Access-Control-Allow-Origin: *' );
header( 'Content-Type: text/plain; charset="utf-8"' );

if ( $_POST['email'] == '' || $_POST['country_code'] == '' )
{
	die( 'Required post data missing (e-mail and country). This page should only be accessed via the sign up form.' );
	/**
	 * If JavaScript is enabled in the form, this should never happen. 
	 * If JS is not enabled, the user can press back, fill the missing fields and repost.
	 * If JS not enabled, the row will be missing language and referrer data, but we can live with that.
	 */
}

// Save time in "YYYY-MM-DD HH:MM:SS"
$_POST['time'] = date('Y-m-d H:i:s');

if ( in_array( $_POST['type'], array( 'page', 'ajax' ) ) )
{
	// Transfer the request to CiviCRM using the API
	
}
?>
