#!/usr/bin/perl

use CGI;
use POSIX qw(strftime);

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

# -----------------------------------------------------------------------------
# Calculate total amount and check for empty orders
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

my $empty = 1;
my $amount = 0;

foreach $item ($query->param) {
  $value = $query->param($item);
  if (not $item =~ /^_/ and $value) {
    my $price = $query->param("_$item");
    $amount += $value * $price;
    if ($item ne "shipping") {
      $empty = 0;
    }
  }
}

if ($empty) {
  print "Content-type: text/html\n\n";
  print "<p>No items selected!</p>\n";
  exit;
}

if ($amount > 999) {
  print "Content-type: text/html\n\n";
  print "<p>Sorry, total amount too large.</p>\n";
  exit;
}

my $amount_f = sprintf("%.2f", $amount);
my $amount100 = $amount * 100;

# -----------------------------------------------------------------------------
# Create payment reference for this order
# -----------------------------------------------------------------------------

my $date = strftime("%y%j", localtime);
my $time = strftime("%s", localtime);
my $reference = "MP" . $date . substr($time, -2) . sprintf("%03u", $amount);

# -----------------------------------------------------------------------------
# Generate mail to office
# -----------------------------------------------------------------------------

open(MAIL, "|/usr/lib/sendmail -t -f office\@fsfe.org");
print MAIL "From: $name <$email>\n";
print MAIL "To: order\@fsfeurope.org\n";
print MAIL "Cc: mueller\@fsfeurope.org\n";
print MAIL "X-OTRS-DynamicField-OrderID: $reference\n";
print MAIL "X-OTRS-DynamicField-OrderAmount: $amount\n";
print MAIL "Content-Transfer-Encoding: 8bit\n";
print MAIL "Content-Type: text/plain; charset=\"UTF-8\"\n";
print MAIL "Subject: $reference\n\n";

print MAIL "$name\n";
print MAIL "$address\n";
print MAIL "Phone: $phone\n\n";

foreach $item ($query->param) {
  $value = $query->param($item);
  if (not $item =~ /^_/ and $value) {
    my $price = $query->param("_$item");
    printf MAIL "%-30s %3u x %5.2f = %6.2f\n", $item, $value, $price, $value * $price;
  }
}

print MAIL "---------------------------------------------------\n";
printf MAIL "Total amount                               € %6.2f\n", $amount;
print MAIL "===================================================\n";
close MAIL;

# -----------------------------------------------------------------------------
# Lead user to "thankyou" page
# -----------------------------------------------------------------------------

print "Content-type: text/html\n\n";
open TEMPLATE, "/home/www/html/global/order/tmpl-thankyou." . $language . ".html";
while (<TEMPLATE>) {
  if (/:FORM:/) {
    my $passphrase = "Only4TestingPurposes";
    my $shastring = 
        "ACCEPTURL=http://fsfe.org/order/thankyou.$language.html$passphrase" .
        "AMOUNT=$amount100$passphrase" .
        "CANCELURL=http://fsfe.org/order/cancel.$language.html$passphrase" .
        "CN=$name$passphrase" .
        "CURRENCY=EUR$passphrase" .
        "EMAIL=$email$passphrase" .
        "LANGUAGE=$language$passphrase" .
        "ORDERID=$reference$passphrase" .
        "PMLISTTYPE=2$passphrase" .
        "PSPID=40F00871$passphrase" .
        "TP=https://fsfe.org/order/tmpl-thankyou.$language.html$passphrase";
    my $shasum = uc(sha1_hex($shastring));
    print "      <!-- payment parameters -->\n";
    print "      <input type=\"hidden\" name=\"PSPID\"        value=\"40F00871\"/>\n";
    print "      <input type=\"hidden\" name=\"orderID\"      value=\"$reference\"/>\n";
    print "      <input type=\"hidden\" name=\"amount\"       value=\"$amount100\"/>\n";
    print "      <input type=\"hidden\" name=\"currency\"     value=\"EUR\"/>\n";
    print "      <input type=\"hidden\" name=\"language\"     value=\"$language\"/>\n";
    print "      <input type=\"hidden\" name=\"CN\"           value=\"$name\"/>\n";
    print "      <input type=\"hidden\" name=\"EMAIL\"        value=\"$email\"/>\n";
    print "      <!-- interface template -->\n";
    print "      <input type=\"hidden\" name=\"TP\"           value=\"https://fsfe.org/order/tmpl-thankyou.$language.html\"/>\n";
    print "      <input type=\"hidden\" name=\"PMListType\"   value=\"2\"/>\n";
    print "      <!-- post-payment redirection -->\n";
    print "      <input type=\"hidden\" name=\"accepturl\"    value=\"http://fsfe.org/order/thankyou.$language.html\"/>\n";
    print "      <input type=\"hidden\" name=\"cancelurl\"    value=\"http://fsfe.org/order/cancel.$language.html\"/>\n";
    print "      <!-- SHA1 signature -->\n";
    print "      <input type=\"hidden\" name=\"SHASign\"      value=\"$shasum\"/>\n";
  } else {
    s/:AMOUNT:/$amount_f/g;
    s/:REFERENCE:/$reference/g;
    print;
  }
}
close TEMPLATE;
