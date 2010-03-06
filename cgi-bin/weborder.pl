#!/usr/bin/perl

# NOTE:
# If the format of the generated mail changes, please notify Penny in the DUS
# office, since the emails are processed automatically.

use CGI;
use POSIX qw(strftime);

my $query = new CGI;

# Search robots sometimes don't fill in the _shipping field
if (!$query->param("_shipping")) {
  die "Invalid order, possibly a search engine robot.";
}

my $date = strftime "%Y-%m-%d", localtime;
my $time = strftime "%s", localtime;
my $reference = "order.$date." . substr $time, -5;
my $buyer = $query->param("name");
my $amount = 0;

# -----------------------------------------------------------------------------
# Calculate amount and generate mail to office
# -----------------------------------------------------------------------------

# Spam bots will be tempted to fill in this actually invisible field
if (not $query->param("url")) {
  open(MAIL, "|/usr/lib/sendmail -t -f mueller\@fsfeurope.org");
  print MAIL "From: web\@fsfeurope.org\n";
  print MAIL "To: order\@fsfeurope.org\n";
  print MAIL "Subject: Web order $reference $buyer\n\n";
  print MAIL "$reference\n\n";
  foreach $name ($query->param) {
    $value = $query->param($name);
    if (not $name =~ /^_/ and $value) {
      print MAIL "$name: $value\n";
      my $price = $query->param("_$name");
      # if ($name ne "shipping") {
      #   $price = $price * 0.75;
      #  }
      $amount += $value * $price;
    }
  }
  # print MAIL "discount: 25\n";
  $amount = sprintf "%.2f", $amount;
  print MAIL "Total amount: $amount\n";
  close MAIL;
}

# -----------------------------------------------------------------------------
# Lead user to "thankyou" page
# -----------------------------------------------------------------------------

print "Content-type: text/html\n\n";
open TEMPLATE, "/home/www/html/global/order/tmpl-thankyou." . $query->param("language") . ".html";
while (<TEMPLATE>) {
  s/:AMOUNT:/$amount/g;
  s/:REFERENCE:/$reference/g;
  print;
}
