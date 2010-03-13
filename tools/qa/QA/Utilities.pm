# QA::Utilities -- Utilities for using QA program.
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

package QA::Utilities;

use strict;
use warnings;

use vars qw($VERSION @ISA);
my $VERSION = 1;

use Log::Log4perl qw(get_logger);
my $log = get_logger();

sub vcs_last_revision {
  my @supported_vcs = (
    "svn"
  );

  unless (grep $_ eq $QA::Config->{vcs}, @supported_vcs) {
    $log->error("Unsupported VCS '$_'");
  }

  my $last_revision = `svn info | grep Revision: | cut -c11-`;
  chomp($last_revision);

  return $last_revision;
}

1;

__END__

