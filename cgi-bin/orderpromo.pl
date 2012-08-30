#!/usr/bin/perl

use CGI;
use POSIX qw(strftime);

my $query = new CGI;

my $date = strftime "%Y-%m-%d", localtime;
my $time = strftime "%s", localtime;
my $reference = "order.$date." . substr $time, -5;

my $firstname = $query->param("firstname");
my $lastname = $query->param("lastname");
my $email = $query->param("email");
my $address = $query->param("address");
my $specifics = $query->param("specifics");
my $comment = $query->param("comment");

if (
  # validate input (more or less)
  ($firstname or $lastname)
  and $email
  and $address
  and $specifics
  and not $query->param("url");
) {

  #send mail
  open(MAIL, "|/usr/lib/sendmail -t -f paul\@fsfeurope.org");
  print MAIL
"From: paul\@fsfeurope.org
To: paul\@fsfeurope.org
Subject: $reference $firstname $lastname

Hey, someone ordered promotional material:
First Name: $firstname
Last Name:  $lastname
EMail:      $email

Address:
$address

Specifics of the Order:
$specifics

Comments:
$comments

KTHXBYE
Your friendly automatic web order program.
";
  close MAIL;

  print "Location: /order/orderpromo-thanks.en.html\n\n"
} else {

  #something was wrong with the input
  print "Location: /order/orderpromo-error.en.html\n\n"

}
