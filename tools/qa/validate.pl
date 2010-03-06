# validate.pl -- Initializes validation testing on all files on
# fsfe.org.

use strict;
use warnings;

use QA::Validation;

# Create list of all HTML files.
my @files = <../../*.html>;

#use Data::Dumper;
#die Dumper(@files);

my $validation = QA::Validation->new(@files)
$validation->test;

