use Cwd qw (abs_path);
use File::Basename qw (dirname);

my $root;
BEGIN { $root = abs_path (dirname (__FILE__)) };
use lib "$root/tools";

use ExtUtils::MakeMaker;

use strict;
use warnings;

my %att = (
  NAME => 'FSFE Website', # Shut up MM warning only
# The version of MakeMaker is sadly too old for MIN_PERL_VERSION
#  MIN_PERL_VERSION => 5.008,
  PREREQ_FATAL => 1,
  PREREQ_PM => {
    'Exporter' => 0,
    'Carp' => 0,
    'CGI' => 0,
    'Cwd' => 0,
    'DateTime' => 0, # Tested with 0.53
    'Encode' => 0, # Tested with 2.35
    'Fcntl' => 0,
    'File::Basename' => 0,
    'File::Copy' => 0,
    'File::Find::Rule' => 0,
    'File::Path' => 0,
    'Getopt::Std' => 0,
    'IO::Handle' => 0,
    'IO::Select' => 0,
    'HTML::TreeBuilder::XPath' => 0,
    'POSIX' => 0,
    'Socket' => 0,
    'Template' => 2.0, # Tested with 2.22
    'Text::Format' => 0,
    'URI' => 0, # tested with 1.54
    'XML::LibXSLT' => 0,
    'XML::LibXML' => 0
});

MM->new (\%att) and print "All OK!\n";

# NO WriteMakefile! We do PREREQ checking only
