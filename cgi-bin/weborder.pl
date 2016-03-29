#!/usr/bin/perl

# NOTE: 
# If the format of the generated mail changes, please notify Penny in the DUS
# office, since the emails are processed automatically.

use CGI;
use POSIX qw(strftime);

my $query = new CGI;

my $date = strftime "%Y-%m-%d", localtime;
my $time = strftime "%s", localtime;
my $reference = "order.$date." . substr $time, -5;
my $buyer = $query->param("name");
my $email = $query->param("email");
my $amount = 0;
my $discount = 0;

# -----------------------------------------------------------------------------
# Check for empty messages (Penny & Rainer, 2011-12-20)
# -----------------------------------------------------------------------------

my $check_empty = true;

foreach $name ($query->param) {
  $value = $query->param($name);
  if ($value ne "" && $name ne "shipping" && $name ne "language") {
    $check_empty = false;
    break; 
  }
}


# -----------------------------------------------------------------------------
# Calculate amount and generate mail to office
# -----------------------------------------------------------------------------

# Spam bots will be tempted to fill in this actually invisible field
if (not $query->param("url") && $check_empty == false) {
  open(MAIL, "|/usr/lib/sendmail -t -f mueller\@fsfeurope.org");
  print MAIL "From: $buyer <$email>\n";
  print MAIL "To: order\@fsfeurope.org\n";
  print MAIL "Content-Transfer-Encoding: 8bit\n";
  print MAIL "Content-Type: text/plain; charset=\"UTF-8\"\n";
  print MAIL "Subject: $reference\n\n";


  print MAIL "$reference\n\n";
  foreach $name ($query->param) {
    $value = $query->param($name);
    if (not $name =~ /^_/ and $value) {
      my $price = $query->param("_$name");

      # EDIT 2010-09-19 (Penny) Change the "shipping"-value to it's price so it can be
      # autodetected (otherwise "value" would always be "1" regardless of users choice)
      if ($name ne "shipping") {
        print MAIL "$name: $value\n";
      } else {
        print MAIL "$name: $price\n";
      }

      if ($discount > 0 && $name ne "shipping") {
        $price *= (1 - ($discount / 100));
      }

      $amount += $value * $price;
    }
  }

  print MAIL "discount: $discount\n";
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
