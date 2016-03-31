#!/usr/bin/perl

use CGI;
use POSIX qw(strftime);

my $query = new CGI;

if ($query->param("url")) {
  die("<p>Invalid input!</p>");
}

my $name = $query->param("name");
my $address = $query->param("address");
my $email = $query->param("email");
my $language = $query->param("language");

# Remove all parameters except for items and prices.
$query->delete("name", "address", "email", "language", "url");

# -----------------------------------------------------------------------------
# Calculate total amount and check for empty orders
# -----------------------------------------------------------------------------

my $empty = true;
my $amount = 0;

foreach $item ($query->param) {
  $value = $query->param($item);
  if (not $item =~ /^_/ and $value) {
    my $price = $query->param("_$item");
    $amount += $value * $price;
    if ($item != "shipping") {
      $empty = false;
    }
  }
}

if ($empty) {
  die("<p>No items selected!</p>");
}

if ($amount > 999) {
  die "<p>Sorry, total amount too large.</p>";
}

my $amount_f = sprintf("%.2f", $amount);

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
print MAIL "X-OTRS-DynamicField-OrderID: $reference\n";
print MAIL "X-OTRS-DynamicField-OrderAmount: $amount\n";
print MAIL "Content-Transfer-Encoding: 8bit\n";
print MAIL "Content-Type: text/plain; charset=\"UTF-8\"\n";
print MAIL "Subject: $reference\n\n";

print MAIL "$name\n";
print MAIL "$address\n\n";

foreach $item ($query->param) {
  $value = $query->param($item);
  if (not $item =~ /^_/ and $value) {
    my $price = $query->param("_$item");
    printf MAIL "%-20s %3u x %2.2f = %3.2f\n", $item, $value, $price, $value * $price;
  }
}

printf MAIL "Total amount: € %.2f\n", $amount;
close MAIL;

# -----------------------------------------------------------------------------
# Lead user to "thankyou" page
# -----------------------------------------------------------------------------

print "Content-type: text/html\n\n";
open TEMPLATE, "/home/www/html/global/order/tmpl-thankyou." . $language . ".html";
while (<TEMPLATE>) {
  s/:AMOUNT:/$amount_f/g;
  s/:REFERENCE:/$reference/g;
  print;
}
