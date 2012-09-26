#!/usr/bin/perl

use CGI;
use POSIX qw(strftime);

my $query = new CGI;

my $date = strftime "%Y-%m-%d", localtime;
my $time = strftime "%s", localtime;
my $reference = "nomination.$date." . substr $time, -5;

# technically we only need the last name for shipping
my $firstname = $query->param("firstname");
my $lastname = $query->param("lastname");
my $email = $query->param("email");
my $phone = $query->param("phone");
my $website = $query->param("website");

my $street = $query->param("street");
my $city = $query->param("city");
my $country = $query->param("country");
#my $address = $query->param("address");

my $biography = $query->param("biography");
my $motivation = $query->param("motivation");
my $lang = $query->param("language");

if (
  # validate input (more or less)
  $firstname and $lastname and
  (  $email
  or $phone
  or ($street
  and $city
  and $country)
  )
  and $website
  and $biography and $motivation
  and not $query->param("url")
) {

  #send mail
  open(MAIL, "|/usr/lib/sendmail -t -f noreply\@fsfe.org");
  print MAIL
"Content-Transfer-Encoding: 8bit
Content-type: text/plain; charset=UTF-8
From: noreply\@fsfe.org
To: award\@fscons.org
Subject: [NFSA Nomination] $reference $firstname $lastname

This person was just nominated for a Nordic Free Software Award:
First Name: $firstname
Last Name:  $lastname
EMail:      $email
Phone:      $phone
Website:    $website

Address:
$street
$city
$country

Biography:
$biography

Motivation:
$motivation

Preferred language was: $lang
";
  close MAIL;

  print "Location: http://fsfe.org/activities/nordic-free-software-award/nfsa-nominate-thanks.$lang.html\n\n";
} else {

  #something was wrong with the input
  print "Location: http://fsfe.org/activities/nordic-free-software-award/nfsa-nominate-error.$lang.html\n\n";
}
