package WebBuild::FormValidation;

use strict;
use warnings;

use utf8;
use CGI;

use base "Exporter";
our @EXPORT = qw(validates_presence_of validates_length_of
  validates_format_of);

my $q = new CGI;

sub new {
  my ($class, %args) = @_;
  my $self = bless({}, $class);

  return $self;
}

sub has_errors {
  my $self = shift;

  #use Data::Dumper;
  #die Dumper($self->{errors});

  if (defined $self->{errors}) {
    return 1;
  } else {
    return 0;
  }
}

sub get_errors {
  my $self = shift;

  if (scalar $self->{errors} > 0) {
    my $output = "<div id='form_validation_errors'>\n" .
      "\t<p>Errors occurred when attempting to process form.</p>\n" .
      "\n" .
      "\t<ul>\n";

    foreach my $option (sort keys %{ $self->{errors} }) {
      $output .= "\t\t<li>" . $self->{errors}{$option} . "</li>\n";
    }

    $output .= "\t</ul>\n" .
      "</div>\n" .
      "\n";
    return $output;
  }
}

sub new_error {
  my ($self, $option, $message) = @_;

#  unless ($q->param($option) eq && defined $message) {
#    return;
#  }

  $self->{"errors"}{$option} = $message;
}

sub validates_presence_of {
  my ($self, $option, %attrs) = @_;

  my $value = ""; #$q->param($option);

  if ($value eq "") {
    unless ($attrs{"message"}) {
      $self->new_error($option, ucfirst($option) . " cannot be blank");
    } else {
      $self->new_error($option, $attrs{"message"});
    }
  }
}

sub validates_length_of {
  my ($self, $option, %attrs) = @_;

  my $value = "a Asdk asdkjahsd "; #$q->param($option);

  unless ($attrs{"min"} && $attrs{"max"}) {
    die "Missing “min” and “max” attributes for validates_length_of().";
  }

  if (length($value) < $attrs{"min"} || length($value) > $attrs{"max"}) {
    unless ($attrs{"message"}) {
      $self->new_error($option, ucfirst($option) . " must be between " . $attrs{"min"} . " and " . $attrs{"max"} . " characters");
    } else {
      $self->new_error($option, $attrs{"message"});
    }
  }
}

sub validates_format_of {
  my ($self, $option, %attrs) = @_;

  my $value = "asd\@asd"; #$q->param($option);
  my @valid_types = ("email");

  if (defined $attrs{"type"}) {
    unless (grep $_ eq $attrs{"type"}, @valid_types) {
      die "Invalid type “" . $attrs{"type"} . "” for validates_format_of().";
    }

    if ($attrs{"type"} eq "email") {
      $attrs{"with"} = "^(\\w¦\\-¦\\_¦\\.)+\\@((\\w¦\\-¦\\_)+\\.)+[a-zA-Z]{2,}\$";
    }
  } else {
    unless ($attrs{"with"}) {
      die "Missing “with” argument for validates_format_of().";
    }
  }

  unless ($value =~ /$attrs{"with"}/) {
    unless ($attrs{"message"}) {
      $self->new_error($option, ucfirst($option) . " is not valid.");
    } else {
      $self->new_error($option, $attrs{"message"});
    }
  }
}

1;

