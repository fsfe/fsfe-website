#! /usr/bin/perl
# This was taken from http://www.stopforumspam.com/forum/viewtopic.php?id=210
# 
# ----------------------------------------------------------------------
#
#   SpammerChk -- A PERL module for querying the StopForumSpam API
#   KEG -- 21 August 2008 -- Version 1.0.0
#
#  Usage:
#     use SpammerChk;
#     $result = isSpammerIP(<IP address>);
#     $result = isSpammerEmail(<email address>);
#     $result = isSpammerUser(<username>);
#
#     $result is either true or false
#
#  Purpose:
#     This was written to allow dynamic checking of attempted YABB
#     Bulletin Board registrations against spammer reports in the
#     StopForumSpam database. The YABB software includes separate
#     sections for checking against the local ban lists for IP, email,
#     and username. This module was written to allow a final remote
#     check against reported spammers for each section.
#
# ----------------------------------------------------------------------

package   SpammerChk;
require   Exporter;
@ISA    = qw(Exporter);
@EXPORT = qw(isSpammerIP isSpammerEmail isSpammerUser);

use strict;
use LWP::UserAgent;
use XML::Simple;

my $url = 'http://www.stopforumspam.com/api';

sub isSpammerIP {
   my $ip = shift;
   return querySpammer($url . '?ip=' . $ip);
}

sub isSpammerUser {
   my $user = shift;
   return querySpammer($url . '?username=' . $user);
}

sub isSpammerEmail {
   my $address = shift;
   return querySpammer($url . '?email=' . $address);
}

sub querySpammer {

   my $reqURL = shift;
   my $response;

   my $ua  = LWP::UserAgent->new;

   $ua->agent("SpammerChk/1.0.0");
   $ua->from('webmaster@fsfe.org');
   $ua->max_size(8192);

   $response = $ua->get($reqURL);

   if ($response->is_success) {

      my $xml = new XML::Simple;
      my $data = $xml->XMLin($response->content);
      return $data->{'appears'} eq 'yes';

   } else { return ""; }
}
1; # ??
