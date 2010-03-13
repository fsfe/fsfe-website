# QA::Config -- Loads configuration for QA tools.
#
# Copyright (C) 2010 Andreas Tolf Tolfsen <ato@fsfe.org>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or (at
# your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

package Config;

use strict;
use warnings;

use Log::Log4perl qw(get_logger);
use Cwd "abs_path";
use File::Basename;
use File::Spec;
use XML::Simple;

my $log = get_logger();

my $current_directory = dirname(abs_path(__FILE__));
chdir $current_directory;
my $base_directory = Cwd::realpath(File::Spec->updir);
chdir $base_directory;

#die $QA::Options->{config};

use Data::Dumper;
die Dumper($QA::Options);

unless (defined $QA::Options->{config}) {
  $QA::Options->{config} = "config.xml";
}

my $xml_parser = XML::Simple->new;
$QA::Config = $xml_parser->XMLin($QA::Options->{config}) or die "Cannot find configuration file";

$QA::Config->{report}->{output} = abs_path($QA::Config->{report}->{output});

1;

