#! /usr/bin/perl
#
# This is a simple wrapper to XML::LibXML. It will validate (more or less)
# an XML file. Use this before committing something to CVS to make sure that
# the file is at least parseable as XML.
#
use CGI::Carp qw(fatalsToBrowser);
use lib '/projects/home/potkal/perllib';
use XML::LibXML;

my $parser = XML::LibXML->new;

foreach (@ARGV) {
  my $doc = $parser->parse_file($_);
}
