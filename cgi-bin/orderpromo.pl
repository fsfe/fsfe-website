#!/usr/bin/perl

use CGI;
use POSIX qw(strftime);

my $query = new CGI;

my $date = strftime "%Y-%m-%d", localtime;
my $time = strftime "%s", localtime;
my $reference = "order.$date." . substr $time, -5;

# technically we only need the last name for shipping
my $firstname = $query->param("firstname");
my $lastname = $query->param("lastname");
my $email = $query->param("email");

my $street = $query->param("street");
my $city = $query->param("city");
my $country = $query->param("country");
#my $address = $query->param("address");

my $specifics = $query->param("specifics");
my $comment = $query->param("comment");
my $lang = $query->param("language");

if (
  # validate input (more or less)
  $lastname
  and $email

  and $street
  and $city
  and $country
#  and $address

  and $specifics
  and not $query->param("url")
) {

  #send mail
  open(MAIL, "|/usr/lib/sendmail -t -f $email");
  print MAIL
"Content-Transfer-Encoding: 8bit
Content-type: text/plain; charset=UTF-8
From: $email
To: assist\@fsfe.org
Subject: [promo order] $reference $firstname $lastname
Precedence: bulk

Hey, someone ordered promotional material:
First Name: $firstname
Last Name:  $lastname
EMail:      $email

Address:
$street
$city
$country

Specifics of the Order:
$specifics

Comments:
$comments

Preferred language was: $lang
";
  close MAIL;

  print "Location: http://fsfe.org/order/orderpromo-thanks.$lang.html\n\n";
} else {

  #something was wrong with the input
  print "Location: http://fsfe.org/order/orderpromo-error.$lang.html\n\n";

}
