#!/usr/bin/perl

use strict;
use warnings;

use CGI;
use POSIX qw(strftime);

my $query = new CGI;
my %errors;

unless ($query->param("name"))    { $errors{"name"}    = "You must give us your name.";           }
unless ($query->param("email"))   { $errors{"email"}   = "You must give us your e-mail address."; }
unless ($query->param("message")) { $errors{"message"} = "You must specify a message.";           }

unless ($query->param("email") =~ /^(\w¦\-¦\_¦\.)+\@((\w¦\-¦\_)+\.)+[a-zA-Z]{2,}$/) {
  $errors{"email"} = "This e-mail address is not valid.";
}

unless (length($query->param("message")) > 5) {
  $errors{"message"} = "This message is too short.";
}

if (%errors) {
  die "Errors!";
}
  
my $date = strftime "%Y-%m-%d", localtime;
my $time = strftime "%s", localtime;

open(MAIL, "|/usr/lib/sendmail -t -f ato\@fsfe.org");
print MAIL "From: web\@fsfeurope.org\n";
print MAIL "To: ato\@fsfe.org\n";
#print MAIL "Cc: mueller\@fsfeurope.org\n";
print MAIL "Subject: New message from website from " . $query->param("name") . "\n\n";
print MAIL "We have received a new message from our website contact form.\n\n";
print MAIL "Name:   " . $query->param("name") . "\n";
print MAIL "E-mail: " . $query->param("email") . "\n\n";
print MAIL "---\n";
print MAIL $query->param("message") . "\n";
print MAIL "---\n$\n\n";

die "Sent e-mail!";

#print "Content-type: text/html\n\n";
#open TEMPLATE, "/home/www/html/global/order/tmpl-thankyou." . $query->param("language") . ".html";
#while (<TEMPLATE>) {
#  s/:AMOUNT:/$amount/g;
#  s/:REFERENCE:/$reference/g;
#  print;
#}

