#!/usr/bin/perl

use CGI;
use POSIX qw(strftime);
use Digest::SHA1 qw(sha1_hex);

# -----------------------------------------------------------------------------
# Get parameters
# -----------------------------------------------------------------------------

my $query = new CGI;

my $amount = $query->param("amount");
if ($amount == "other") {
  $amount = $query->param("amount_other");
}
my $anonymous = $query->param("anonymous");
my $language = $query->param("language");
my $text = $query->param("text");

my $amount100 = $amount * 100;

my $date = strftime("%Y-%m-%d", localtime);
my $time = strftime("%s", localtime);
my $reference = "";
if ($anonymous) {
  $reference = "adonation.$date." . substr($time, -5);
} else {
  $reference = "donation.$date." . substr($time, -5);
}

# -----------------------------------------------------------------------------
# Generate form to forward payment request to PayPal or Concardis
# -----------------------------------------------------------------------------

print "Content-type: text/html\n\n";

open TEMPLATE, "/home/www/html/global/donate/tmpl-donate.$language.html";
while (<TEMPLATE>) {
  if (/:FORM:/) {
    my $passphrase = "Only4TestingPurposes";
    my $shastring = 
        "ACCEPTURL=http://fsfe.org/donate/thankyou.$language.html$passphrase" .
        "AMOUNT=$amount100$passphrase" .
        "CANCELURL=http://fsfe.org/donate/cancel.$language.html$passphrase" .
        "COM=$text$passphrase" .
        "CURRENCY=EUR$passphrase" .
        "LANGUAGE=$language$passphrase" .
        "ORDERID=$reference$passphrase" .
        "PMLISTTYPE=2$passphrase" .
        "PSPID=40F00871$passphrase" .
        "TP=http://fsfe.org/donate/tmpl-concardis.$language.html$passphrase";
    my $shasum = uc(sha1_hex($shastring));
    print "    <form name=\"donate\" action=\"https://secure.payengine.de/ncol/prod/orderstandard.asp\" method=\"post\">\n";
    print "      <!-- payment parameters -->\n";
    print "      <input type=\"hidden\" name=\"PSPID\"        value=\"40F00871\"/>\n";
    print "      <input type=\"hidden\" name=\"orderID\"      value=\"$reference\"/>\n";
    print "      <input type=\"hidden\" name=\"com\"          value=\"$text\"/>\n";
    print "      <input type=\"hidden\" name=\"amount\"       value=\"$amount100\"/>\n";
    print "      <input type=\"hidden\" name=\"currency\"     value=\"EUR\"/>\n";
    print "      <input type=\"hidden\" name=\"language\"     value=\"$language\"/>\n";
    print "      <!-- interface template -->\n";
    print "      <input type=\"hidden\" name=\"TP\"           value=\"http://fsfe.org/donate/tmpl-concardis.$language.html\"/>\n";
    print "      <input type=\"hidden\" name=\"PMListType\"   value=\"2\"/>\n";
    print "      <!-- post-payment redirection -->\n";
    print "      <input type=\"hidden\" name=\"accepturl\"    value=\"http://fsfe.org/donate/thankyou.$language.html\"/>\n";
    print "      <input type=\"hidden\" name=\"cancelurl\"    value=\"http://fsfe.org/donate/cancel.$language.html\"/>\n";
    print "      <!-- SHA1 signature -->\n";
    print "      <input type=\"hidden\" name=\"SHASign\"      value=\"$shasum\"/>\n";
    print "      <!-- Javascript submit() method only works if no submit button is active -->\n";
    print "      <noscript>\n";
    print "        <!-- submit button -->\n";
    print "        <input type=\"submit\" name=\"submit\"       value=\"OK\"/>\n";
    print "      </noscript>\n";
    print "    </form>\n";
    print "    <script type=\"text/javascript\">document.donate.submit()</script>";
  } else {
    print;
  }
}
close TEMPLATE;
