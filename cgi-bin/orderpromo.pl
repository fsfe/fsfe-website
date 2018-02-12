#!/usr/bin/perl

use CGI;

my $query = new CGI;

# technically we only need the last name for shipping
my $firstname = $query->param("firstname");
my $lastname = $query->param("lastname");
my $email = $query->param("email");

my $street = $query->param("street");
my $city = $query->param("city");
my $country = $query->param("country");
#my $address = $query->param("address");

my $specifics = $query->param("specifics");
my $usage = $query->param("usage");
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
To: contact\@fsfe.org
Subject: [promo order] $firstname $lastname
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

The material is going to be used for:
$usage

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
