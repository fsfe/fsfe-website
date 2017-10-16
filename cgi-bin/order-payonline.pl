#!/usr/bin/perl

use CGI;
use Digest::SHA1 qw(sha1_hex);

my $query = new CGI;

my $reference = $query->param("reference") ~ "s/\W//g";         # Only numbers and characters to aviod cross site scripting
my $language = $query->param("language") ~ "s/\W//g";

my $lang = substr($language, 0, 2);
my $amount = substr($reference, 9, 3);
my $amount_f = sprintf("%.2f", $amount);
my $amount100 = $amount * 100;

# -----------------------------------------------------------------------------
# Generate form for ConCardis payment
# -----------------------------------------------------------------------------

my $passphrase = "Only4TestingPurposes";
my $shastring = 
    "ACCEPTURL=http://fsfe.org/order/thankyou.$lang.html$passphrase" .
    "AMOUNT=$amount100$passphrase" .
    "CANCELURL=http://fsfe.org/order/cancel.$lang.html$passphrase" .
    "CURRENCY=EUR$passphrase" .
    "LANGUAGE=$language$passphrase" .
    "ORDERID=$reference$passphrase" .
    "PMLISTTYPE=2$passphrase" .
    "PSPID=40F00871$passphrase" .
    "TP=https://fsfe.org/order/tmpl-concardis.$lang.html$passphrase";
my $shasum = uc(sha1_hex($shastring));
my $form = "      <!-- payment parameters -->\n" .
    "      <input type=\"hidden\" name=\"PSPID\"        value=\"40F00871\"/>\n" .
    "      <input type=\"hidden\" name=\"orderID\"      value=\"$reference\"/>\n" .
    "      <input type=\"hidden\" name=\"amount\"       value=\"$amount100\"/>\n" .
    "      <input type=\"hidden\" name=\"currency\"     value=\"EUR\"/>\n" .
    "      <input type=\"hidden\" name=\"language\"     value=\"$language\"/>\n" .
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
open TEMPLATE, "/home/www/html/global/order/tmpl-thankyou." . $lang . ".html";
while (<TEMPLATE>) {
  s/:AMOUNT:/$amount_f/g;
  s/:REFERENCE:/$reference/g;
  s/:FORM:/$form/g;
  print;
}
close TEMPLATE;
