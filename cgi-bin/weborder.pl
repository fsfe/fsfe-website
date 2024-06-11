#!/usr/bin/perl
# -----------------------------------------------------------------------------
# Process merchandise order
# -----------------------------------------------------------------------------
# Copyright (C) 2008-2022 Free Software Foundation Europe <contact@fsfe.org>
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU Affero General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option) any
# later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more
# details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>
# -----------------------------------------------------------------------------

use CGI;
use CGI::Carp 'fatalsToBrowser';
use Encode qw(decode encode);
use POSIX qw(strftime);
use Digest::SHA qw(sha1_hex);
use MIME::Lite;
use MIME::Base64;
use utf8;
use LWP::UserAgent;
use HTTP::Request::Common qw(POST);
use JSON;
use warnings;
use diagnostics;

# -----------------------------------------------------------------------------
# Get parameters
# -----------------------------------------------------------------------------

my $query = new CGI;

if ( $query->param("url") ) {
    print "Content-type: text/html\n\n";
    print "<p>Invalid input!</p>\n";
    exit;
}

my $name    = decode( "utf-8", $query->param("name") );
my $address = decode( "utf-8", $query->param("address") );
my $zip     = decode( "utf-8", $query->param("zip") );
my $city    = decode( "utf-8", $query->param("city") );
my $country = decode( "utf-8", $query->param("country") );
my ( $country_code, $country_name ) = split( /\|/, $country );
my $email    = decode( "utf-8", $query->param("email") );
my $phone    = decode( "utf-8", $query->param("phone") );
my $language = $query->param("language");

# Remove all parameters except for items and prices.
$query->delete(
    "url",   "name",  "address", "zip", "city", "country",
    "email", "phone", "language"
);

my $lang = substr $language, 0, 2;

# -----------------------------------------------------------------------------
# Calculate total amount and do some sanity checks
# -----------------------------------------------------------------------------

if ( !$name ) {
    print "Content-type: text/html\n\n";
    print "<p>Please enter your name!</p>\n";
    exit;
}

if ( !$address or !$zip or !$city or !$country ) {
    print "Content-type: text/html\n\n";
    print "<p>Please enter your complete address!</p>\n";
    exit;
}

if ( !$email ) {
    print "Content-type: text/html\n\n";
    print "<p>Please enter your email address!</p>\n";
    exit;
}

my $count  = 0;
my $amount = 0;

foreach $item ( $query->param ) {
    $value = $query->param($item);
    if ( not $item =~ /^_/ and $value ) {
        my $price = $query->param("_$item");
        $count  += 1;
        $amount += $value * $price;
    }
}

# Determine shipping fees based on country code from drop-down list
my $shipping;

if ( $amount >= 6 ) {
    $shipping = 0;
} elsif ( $country_code eq 'DE' ) {
    $shipping = 5;
} else {
    $shipping = 8;
}

$amount += $shipping;

if ( $count < 1 ) {
    print "Content-type: text/html\n\n";
    print "<p>No items selected!</p>\n";
    exit;
}

if ( $amount > 999 ) {
    print "Content-type: text/html\n\n";
    print "<p>Sorry, total amount too large.</p>\n";
    exit;
}

my $amount_f  = sprintf "%.2f", $amount;
my $amount100 = $amount * 100;

my $vat = sprintf "%.2f", ( $amount_f / 1.19 ) * 0.19;
my $net = sprintf "%.2f", $amount_f - $vat;

# -----------------------------------------------------------------------------
# Create payment reference for this order
# -----------------------------------------------------------------------------

my $date = strftime( "%j", localtime );
my $time = strftime( "%s", localtime );
my $reference =
  "MP" . $date . ( substr $time, -4 ) . ( sprintf "%03u", $amount );

# -----------------------------------------------------------------------------
# Compile ticket body
# -----------------------------------------------------------------------------

my $body = <<"HTML";
<html>
<body>
    <p>
        Dear $name,
    </p>
    <p>
        thank you so much for your recent order to the Free Software Foundation
        Europe. This is an automated email to confirm your order and give you
        some additional information about it.
    </p>
    <p>
        Once we receive payment for your order, you will get a second mail
        notifying you that the payment has been received. If you have paid
        online this will be slightly quicker than if you pay by bank
        transfer.
    </p>
    <p>
        If you have yet to pay your order, you may now do so by following this
        link:

        <a href=https://fsfe.org/order/payonline.$language/$reference>
            https://fsfe.org/order/payonline.$language/$reference
        </a>
    </p>
    <p>
        In case you prefer to pay by bank transfer, please use the following data:
    </p>
        Recipient: Free Software Foundation Europe e.V.<br>
        Address: Schoenhauser Allee 6/7, 10119 Berlin, Germany<br>
        IBAN: DE47 4306 0967 2059 7908 01<br>
        Bank: GLS Gemeinschaftsbank eG, 44774 Bochum, Germany<br>
        BIC: GENODEM1GLS<br>
        Payment reference: $reference<br>
        Payment amount: $amount Euro
    </p>
    <p>
        The following order was just received by our merchandise team. We will
        ship the order as soon as we have received your payment. The invoice
        will be included in the delivery of your order.
    </p>
    <h2>Address</h2>
    <p>
        $name<br>
        $address<br>
        $zip $city<br>
        $country_name<br>
        Phone: $phone
    </p>
    <h2>Order Details</h2>
    <pre>
HTML

foreach $item ( $query->param ) {
    $value = $query->param($item);
    if ( not $item =~ /^_/ and $value ) {
        my $price    = $query->param("_$item");
        my $subtotal = $value * $price;
        $body .= <<"HTML";
$value x $item: € $subtotal
HTML
    }
}

$body .= <<"HTML";
Shipping to $country_name: € $shipping<br>
<strong>Total amount: € $amount</strong>
</pre>
<p>
    Best regards,
</p>
</body>
</html>
HTML

# -----------------------------------------------------------------------------
# Generate invoice
# -----------------------------------------------------------------------------

my @odtfill = qw();

# odtfill script
push @odtfill, $ENV{"DOCUMENT_ROOT"} . "/cgi-bin/odtfill";

# template file
push @odtfill, $ENV{"DOCUMENT_ROOT"} . "/templates/invoice.odt";

# output file
push @odtfill, "/tmp/invoice.odt";

# placeholder replacements
push @odtfill, "repeat=" . $count;
push @odtfill, "Name=" . $name;
push @odtfill, "Address=" . $address =~ s/\n/\\n/gr;
push @odtfill, "ZipCity=" . $zip . " " . $city;
push @odtfill, "Country=" . $country_name;
foreach $item ( $query->param ) {
    $value = $query->param($item);
    if ( not $item =~ /^_/ and $value ) {
        my $price = $query->param("_$item");
        push @odtfill, "Count=" . $value;
        push @odtfill, "Item=" . $item;
        push @odtfill, "Amount=" . sprintf "%.2f", $value * $price;
    }
}
push @odtfill, "Country=" . $country_name;    # 2nd Country placeholder
push @odtfill, "Shipping=" . sprintf "%.2f", $shipping;
push @odtfill, "Total=" . $amount_f;
push @odtfill, "Net=" . $net;
push @odtfill, "Vat=" . $vat;
push @odtfill, "Code=" . $reference;

# run the script
system @odtfill;

# Transform invoice.odt to base64 encoded string
my $invoice_path = "/tmp/invoice.odt";
open( my $fh, '<', $invoice_path ) or die "Cannot open file: $!";
binmode($fh);
my $file_contents = do { local $/; <$fh> };
close($fh);

my $base64_encoded_invoice = encode_base64($file_contents);

# -----------------------------------------------------------------------------
# Send API request to Helpdesk to create a new conversation
# -----------------------------------------------------------------------------

my $api_key = $ENV{'FREESCOUT_API_KEY'};
my $api_url = 'https://helpdesk.fsfe.org/api/conversations';

my $data = {
    "type"      => "email",
    "mailboxId" => 7,         # This is the Merchandise Mailbox
    "subject"   => "New merchandise order: $reference",   # This is the Order ID
    "customer"  => {
        "email" => "$email"
    },
    "threads" => [
        {
            "text"     => "A new order came in.",
            "type"     => "customer",
            "customer" => {
                "email" => "$email",
            },
            "attachments" => [
                {
                    "fileName" => "invoice.odt",
                    "mimeType" => "application/vnd.oasis.opendocument.text",
                    "data"     => "$base64_encoded_invoice"
                }
            ]
        },
        {
            "text" => "$body",
            "type" => "message",
            "user" => 6530,
        }
    ],
    "imported"     => JSON::false,
    "assignTo"     => 6584,
    "status"       => "pending",
    "customFields" => [
        {
            "id"    => 4,              # Order ID Custom Field
            "value" => "$reference"    # Actual Order ID
        }
    ],
};

# Encode the JSON
my $json_data = encode_json($data);

# Create a new HTTP::Request object
my $request = HTTP::Request->new( POST => $api_url );
$request->header( 'Content-Type'        => 'application/json' );
$request->header( 'X-FreeScout-API-Key' => $api_key );
$request->content($json_data);

# Send the request using LWP::UserAgent
my $ua       = LWP::UserAgent->new;
my $response = $ua->request($request);

# -----------------------------------------------------------------------------
# Generate form for ConCardis payment
# -----------------------------------------------------------------------------

my $passphrase = "Only4TestingPurposes";
my $shastring =
    "ACCEPTURL=https://fsfe.org/order/thankyou.$lang.html$passphrase"
  . "AMOUNT=$amount100$passphrase"
  . "CANCELURL=https://fsfe.org/order/cancel.$lang.html$passphrase"
  . "CN=$name$passphrase"
  . "CURRENCY=EUR$passphrase"
  . "EMAIL=$email$passphrase"
  . "LANGUAGE=$language$passphrase"
  . "ORDERID=$reference$passphrase"
  . "PMLISTTYPE=2$passphrase"
  . "PSPID=40F00871$passphrase"
  . "TP=https://fsfe.org/order/tmpl-concardis.$lang.html$passphrase";
my $shasum = uc sha1_hex($shastring);
my $form =
    "      <!-- payment parameters -->\n"
  . "      <input type=\"hidden\" name=\"PSPID\"        value=\"40F00871\"/>\n"
  . "      <input type=\"hidden\" name=\"orderID\"      value=\"$reference\"/>\n"
  . "      <input type=\"hidden\" name=\"amount\"       value=\"$amount100\"/>\n"
  . "      <input type=\"hidden\" name=\"currency\"     value=\"EUR\"/>\n"
  . "      <input type=\"hidden\" name=\"language\"     value=\"$language\"/>\n"
  . "      <input type=\"hidden\" name=\"CN\"           value=\"$name\"/>\n"
  . "      <input type=\"hidden\" name=\"EMAIL\"        value=\"$email\"/>\n"
  . "      <!-- interface template -->\n"
  . "      <input type=\"hidden\" name=\"TP\"           value=\"https://fsfe.org/order/tmpl-concardis.$lang.html\"/>\n"
  . "      <input type=\"hidden\" name=\"PMListType\"   value=\"2\"/>\n"
  . "      <!-- post-payment redirection -->\n"
  . "      <input type=\"hidden\" name=\"accepturl\"    value=\"https://fsfe.org/order/thankyou.$lang.html\"/>\n"
  . "      <input type=\"hidden\" name=\"cancelurl\"    value=\"https://fsfe.org/order/cancel.$lang.html\"/>\n"
  . "      <!-- SHA1 signature -->\n"
  . "      <input type=\"hidden\" name=\"SHASign\"      value=\"$shasum\"/>";

# -----------------------------------------------------------------------------
# Lead user to "thankyou" page
# -----------------------------------------------------------------------------

print "Content-type: text/html\n\n";
open TEMPLATE,
  $ENV{"DOCUMENT_ROOT"} . "/order/tmpl-thankyou." . $lang . ".html";
while (<TEMPLATE>) {
    s/:AMOUNT:/$amount_f/g;
    s/:REFERENCE:/$reference/g;
    s/:FORM:/$form/g;
    print;
}
close TEMPLATE;
