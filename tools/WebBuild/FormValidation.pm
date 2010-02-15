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

  if (defined $self->{errors}) {
    return 1;
  } else {
    return 0;
  }
}

sub get_errors {
  my $self = shift;

  if (scalar $self->{errors} > 0) {
    my $output = "<p>Errors occurred when attempting to process form.</p>\n\n";
    $output .= "<ul>\n";

    foreach my %error ($self->{errors}) {
      $output .= "\t<li>" . $error{message} . "</li>\n";
    }

    $output .= "</ul>\n\n";
    return $output;
  }
}

sub add_to_error_stack {
  my ($self, $option, $message) = @_;
  #return unless defined $new_error;

  $self->{errors}{$option}{message} = $message;
}

sub validates_presence_of {
  my $option = shift;
  my %attrs = @_;

  my $value = $q->param($option);

  unless ($value) {
    unless ($attrs{"message"}) {
      add_to_error_stack($option, ucfirst($option) . " cannot be blank");
    } else {
      add_to_error_stack($option, attrs{"message"});
    }
  }
}

sub validates_length_of {
  my $option = shift;
  my %attrs = @_;

  my $value = $q->param($option);

  unless ($attrs{"min"} && $attrs{"max"}) {
    die "Missing “min” and “max” attributes for validates_length_of().";
  }

  if (length($value) < $attrs{"min"} || length($value) > $attrs{"max"}) {
    unless ($attrs{"message"}) {
      add_to_error_stack($option, ucfirst($option) . " must be between " . $attrs{"min"} . " and " . $attrs{"max"} . " characters");
    } else {
      add_to_error_stack($option, $attrs{"message"});
    }
  }
}

sub validates_format_of {
  my $option = shift;
  my %attrs = @_;

  my $value = $q->param($option);
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
      add_to_error_stack($option, ucfirst($option) . " is not valid.");
    } else {
      add_to_error_stack($option, $attrs{"message"});
    }
  }
}

1;

