#!/usr/bin/perl

use CGI;
use POSIX qw(strftime);
use Date::Calc qw(Add_Delta_YM);
use Digest::SHA1 qw(sha1_hex);

# -----------------------------------------------------------------------------
# Get parameters
# -----------------------------------------------------------------------------

my $query = new CGI;

my $amount = $query->param("amount");
my $period = substr($amount, 0, 1);
my $amount = substr($amount, 1);
if ($amount eq "other") {
  $amount = $query->param($period . "amount_other");
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
if ($period ne "o") {
  $reference .= ".$period";
}

($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime;

my $months = 0;
if ($period eq "m") {
  ($year, $mon, $mday) = Add_Delta_YM($year, $mon, $mday, 0, 1);
  $months = 1;
}
if ($period eq "y") {
  ($year, $mon, $mday) = Add_Delta_YM($year, $mon, $mday, 1, 0);
  $months = 12;
}
my $start = strftime("%Y-%m-%d", ($sec, $min, $hour, $mday, $mon, $year, 0, 0, $isdst));
my $day = substr($date, -2);

my $lang = substr($language, 0, 2);

# -----------------------------------------------------------------------------
# Generate form to forward payment request to PayPal or Concardis
# -----------------------------------------------------------------------------

print "Content-type: text/html\n\n";

open TEMPLATE, "/home/www/html/global/donate/tmpl-donate.$lang.html";
while (<TEMPLATE>) {
  if (/:FORM:/) {
    my $passphrase = "Only4TestingPurposes";
    my $shastring = 
        "ACCEPTURL=http://fsfe.org/donate/thankyou.$lang.html$passphrase" .
        "AMOUNT=$amount100$passphrase" .
        "CANCELURL=http://fsfe.org/donate/cancel.$lang.html$passphrase" .
        "COM=$text$passphrase" .
        "CURRENCY=EUR$passphrase" .
        "LANGUAGE=$language$passphrase" .
        "ORDERID=$reference$passphrase" .
        "PMLISTTYPE=2$passphrase" .
        "PSPID=40F00871$passphrase";
    if ($period ne "o") {
      $shastring .=
        "SUBSCRIPTION_ID=$reference$passphrase" .
        "SUB_AMOUNT=$amount100$passphrase" .
        "SUB_COM=$text$passphrase" .
        "SUB_ORDERID=$reference$passphrase" .
        "SUB_PERIOD_MOMENT=$day$passphrase" .
        "SUB_PERIOD_NUMBER=$months$passphrase" .
        "SUB_PERIOD_UNIT=m$passphrase" .
        "SUB_STARTDATE=$start$passphrase" .
        "SUB_STATUS=1$passphrase";
    }
    $shastring .= 
        "TP=http://fsfe.org/donate/tmpl-concardis.$lang.html$passphrase";
    my $shasum = uc(sha1_hex($shastring));
    print "    <form name=\"donate\" action=\"https://secure.payengine.de/ncol/prod/orderstandard.asp\" method=\"post\">\n";
    print "      <!-- payment parameters -->\n";
    print "      <input type=\"hidden\" name=\"PSPID\"        value=\"40F00871\"/>\n";
    print "      <input type=\"hidden\" name=\"orderID\"      value=\"$reference\"/>\n";
    print "      <input type=\"hidden\" name=\"com\"          value=\"$text\"/>\n";
    print "      <input type=\"hidden\" name=\"amount\"       value=\"$amount100\"/>\n";
    print "      <input type=\"hidden\" name=\"currency\"     value=\"EUR\"/>\n";
    print "      <input type=\"hidden\" name=\"language\"     value=\"$language\"/>\n";
    if ($period ne "o") {
      print "      <!-- subscription parameters -->\n";
      print "      <input type=\"hidden\" name=\"SUBSCRIPTION_ID\"   value=\"$reference\"/>\n";
      print "      <input type=\"hidden\" name=\"SUB_ORDERID\"       value=\"$reference\"/>\n";
      print "      <input type=\"hidden\" name=\"SUB_COM\"           value=\"$text\"/>\n";
      print "      <input type=\"hidden\" name=\"SUB_AMOUNT\"        value=\"$amount100\"/>\n";
      print "      <input type=\"hidden\" name=\"SUB_PERIOD_UNIT\"   value=\"m\"/>\n";
      print "      <input type=\"hidden\" name=\"SUB_PERIOD_NUMBER\" value=\"$months\"/>\n";
      print "      <input type=\"hidden\" name=\"SUB_PERIOD_MOMENT\" value=\"$day\"/>\n";
      print "      <input type=\"hidden\" name=\"SUB_STARTDATE\"     value=\"$start\"/>\n";
      print "      <input type=\"hidden\" name=\"SUB_STATUS\"        value=\"1\"/>\n";
    }
    print "      <!-- interface template -->\n";
    print "      <input type=\"hidden\" name=\"TP\"           value=\"http://fsfe.org/donate/tmpl-concardis.$lang.html\"/>\n";
    print "      <input type=\"hidden\" name=\"PMListType\"   value=\"2\"/>\n";
    print "      <!-- post-payment redirection -->\n";
    print "      <input type=\"hidden\" name=\"accepturl\"    value=\"http://fsfe.org/donate/thankyou.$lang.html\"/>\n";
    print "      <input type=\"hidden\" name=\"cancelurl\"    value=\"http://fsfe.org/donate/cancel.$lang.html\"/>\n";
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
