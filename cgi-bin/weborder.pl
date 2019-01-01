#!/usr/bin/perl
# -----------------------------------------------------------------------------
# Process merchandise order
# -----------------------------------------------------------------------------
# Copyright (C) 2008-2019 Free Software Foundation Europe <contact@fsfe.org>
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
use Encode qw(decode encode);
use POSIX qw(strftime);
use Digest::SHA qw(sha1_hex);
use MIME::Lite;

# -----------------------------------------------------------------------------
# Get parameters
# -----------------------------------------------------------------------------

my $query = new CGI;

if ($query->param("url")) {
  print "Content-type: text/html\n\n";
  print "<p>Invalid input!</p>\n";
  exit;
}

my $name = $query->param("name");
my $address = $query->param("address");
my $email = $query->param("email");
my $phone = $query->param("phone");
my $language = $query->param("language");

# Remove all parameters except for items and prices.
$query->delete("url", "name", "address", "email", "phone", "language");

my $lang = substr $language, 0, 2;

# -----------------------------------------------------------------------------
# Calculate total amount and do some sanity checks
# -----------------------------------------------------------------------------

if (!$name) {
  print "Content-type: text/html\n\n";
  print "<p>Please enter your name!</p>\n";
  exit;
}

if (!$email) {
  print "Content-type: text/html\n\n";
  print "<p>Please enter your email address!</p>\n";
  exit;
}

my $count = 0;
my $amount = 0;

foreach $item ($query->param) {
  $value = $query->param($item);
  if (not $item =~ /^_/ and $value) {
    my $price = $query->param("_$item");
    $count += 1;
    $amount += $value * $price;
  }
}

if ($count < 2) {
  print "Content-type: text/html\n\n";
  print "<p>No items selected!</p>\n";
  exit;
}

if ($amount > 999) {
  print "Content-type: text/html\n\n";
  print "<p>Sorry, total amount too large.</p>\n";
  exit;
}

my $amount_f = sprintf "%.2f", $amount ;
my $amount100 = $amount * 100;

my $vat = sprintf "%.2f", ($amount_f / 1.19) * 0.19;
my $net = sprintf "%.2f", $amount_f - $vat;

# -----------------------------------------------------------------------------
# Create payment reference for this order
# -----------------------------------------------------------------------------

my $date = strftime("%j", localtime);
my $time = strftime("%s", localtime);
my $reference = "MP" . $date . (substr $time, -4) . (sprintf "%03u", $amount);

# -----------------------------------------------------------------------------
# Compile email text
# -----------------------------------------------------------------------------

my $body = "$name\n$address\nPhone: $phone\n\n";

foreach $item ($query->param) {
  $value = $query->param($item);
  if (not $item =~ /^_/ and $value) {
    my $price = $query->param("_$item");
    $body .= sprintf "%-30s %3u x %5.2f = %6.2f\n", $item, $value, $price, $value * $price;
  }
}

$body .= "---------------------------------------------------\n";
$body .= sprintf("Total amount                               € %6.2f\n", $amount);
$body .= "===================================================\n";

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
push @odtfill, "Address=" . $address =~ s/\n/\\n/r;
foreach $item ($query->param) {
  $value = $query->param($item);
  if (not $item =~ /^_/ and $value) {
    my $price = $query->param("_$item");
    push @odtfill, "Count=" . $value;
    push @odtfill, "Item=" . $item;
    push @odtfill, "Amount=" . sprintf "%.2f", $value * $price;
  }
}
push @odtfill, "Total=" . $amount_f;
push @odtfill, "Net=" . $net;
push @odtfill, "Vat=" . $vat;
push @odtfill, "Code=" . $reference;

# run the script
system @odtfill;

# -----------------------------------------------------------------------------
# Send email to OTRS
# -----------------------------------------------------------------------------

$msg = MIME::Lite->new(
  "From:" => encode("MIME-Header", decode("utf8", $name)) . " <$email>",
  "To:" => "contact\@fsfe.org",
  "Subject:" => "$reference",
  "X-OTRS-Queue:" => "Finance::Merchandise Orders",
  "X-OTRS-DynamicField-OrderID:" => "$reference",
  "X-OTRS-DynamicField-OrderAmount:" => "$amount",
  "X-OTRS-DynamicField-OrderLanguage:" => "$language",
  "X-OTRS-DynamicField-OrderState:" => "order",
  Type => "multipart/mixed");

$msg->attach(
  Type => "text/plain",
  Charset => "UTF-8",
  Data => $body);

$msg->attach(
  Type => "application/vnd.oasis.opendocument.text",
  Path => "/tmp/invoice.odt");

$msg->send("sendmail", FromSender => $email);

# -----------------------------------------------------------------------------
# Generate form for ConCardis payment
# -----------------------------------------------------------------------------

my $passphrase = "Only4TestingPurposes";
my $shastring = 
    "ACCEPTURL=http://fsfe.org/order/thankyou.$lang.html$passphrase" .
    "AMOUNT=$amount100$passphrase" .
    "CANCELURL=http://fsfe.org/order/cancel.$lang.html$passphrase" .
    "CN=$name$passphrase" .
    "CURRENCY=EUR$passphrase" .
    "EMAIL=$email$passphrase" .
    "LANGUAGE=$language$passphrase" .
    "ORDERID=$reference$passphrase" .
    "PMLISTTYPE=2$passphrase" .
    "PSPID=40F00871$passphrase" .
    "TP=https://fsfe.org/order/tmpl-concardis.$lang.html$passphrase";
my $shasum = uc sha1_hex($shastring);
my $form = "      <!-- payment parameters -->\n" .
    "      <input type=\"hidden\" name=\"PSPID\"        value=\"40F00871\"/>\n" .
    "      <input type=\"hidden\" name=\"orderID\"      value=\"$reference\"/>\n" .
    "      <input type=\"hidden\" name=\"amount\"       value=\"$amount100\"/>\n" .
    "      <input type=\"hidden\" name=\"currency\"     value=\"EUR\"/>\n" .
    "      <input type=\"hidden\" name=\"language\"     value=\"$language\"/>\n" .
    "      <input type=\"hidden\" name=\"CN\"           value=\"$name\"/>\n" .
    "      <input type=\"hidden\" name=\"EMAIL\"        value=\"$email\"/>\n" .
    "      <!-- interface template -->\n" .
    "      <input type=\"hidden\" name=\"TP\"           value=\"https://fsfe.org/order/tmpl-concardis.$lang.html\"/>\n" .
    "      <input type=\"hidden\" name=\"PMListType\"   value=\"2\"/>\n" .
    "      <!-- post-payment redirection -->\n" .
    "      <input type=\"hidden\" name=\"accepturl\"    value=\"http://fsfe.org/order/thankyou.$lang.html\"/>\n" .
    "      <input type=\"hidden\" name=\"cancelurl\"    value=\"http://fsfe.org/order/cancel.$lang.html\"/>\n" .
    "      <!-- SHA1 signature -->\n" .
    "      <input type=\"hidden\" name=\"SHASign\"      value=\"$shasum\"/>";

# -----------------------------------------------------------------------------
# Lead user to "thankyou" page
# -----------------------------------------------------------------------------

print "Content-type: text/html\n\n";
open TEMPLATE, $ENV{"DOCUMENT_ROOT"} . "/order/tmpl-thankyou." . $lang . ".html";
while (<TEMPLATE>) {
  s/:AMOUNT:/$amount_f/g;
  s/:REFERENCE:/$reference/g;
  s/:FORM:/$form/g;
  print;
}
close TEMPLATE;
