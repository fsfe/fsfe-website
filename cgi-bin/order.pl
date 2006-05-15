#!/usr/bin/perl

use CGI;

$query = new CGI;
@names = $query->param;

open(MAIL,"|/usr/lib/sendmail -t")
print MAIL "From: mueller\@fsfeurope.org\n";
print MAIL "To: mueller\@fsfeurope.org\n";
print MAIL "Subject: Web order\n\n";
foreach(@names) {
  $name = $_;
  @values = $query->param($name);
  foreach $value (@values) {
    print MAIL $name.": ".$value."\n";
  }
}
close(MAIL);

print "Location: /order/thankyou.en.html\n\n";
