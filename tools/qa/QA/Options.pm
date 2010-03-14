
use strict;
use warnings;

use Getopt::Long;
use Data::Dumper;

# Options
$QA::Options = {};
my $options_parser = new Getopt::Long::Parser("config" => ["gnu_compat",
  "bundling", "permute", "no_getopt_compat"]);

$options_parser->getoptions($QA::Options, #$QA::Options,
  "config|c=s",
  "debug|d",
  "help|h",
  "version|v"
) or exit;

1;

