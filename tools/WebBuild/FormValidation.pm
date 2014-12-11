package WebBuild::FormValidation;

=head1 DESCRIPTION

Please document me >:(

=cut

use strict;
use warnings;

use utf8;
use CGI;
use URI;

use base "Exporter";
our @EXPORT = qw(validates_presence_of validates_length_of
  validates_format_of);

use constant TYPES => ('ur;', 'email');

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

  if ($self->{errors} && (scalar($self->{errors}) > 0)) {
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

  my $value = $q->param($option) || '';

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

  my $value = $q->param($option);

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

  #unless ($value =~ /$attrs{"with"}/) {

  # WTF if this? Always check for email?
  unless ($value =~ /^[_a-zA-Z0-9-]+(\.[_a-zA-Z0-9-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*\.(([0-9]{1,3})|([a-zA-Z]{2,3})|(aero|coop|info|museum|name))$/) {
    unless ($attrs{"message"}) {
      $self->new_error($option, ucfirst($option) . " is not valid.");
    } else {
      $self->new_error($option, $attrs{"message"});
    }
  }
}

sub validate_format
  {
    my ($self, $option, %attrs) = @_;

    my $value = $q->param ($option) || '';
    my $type = delete $attrs{'type'};
    my $with = delete $attrs{'with'};

    die 'at least one of [type] or [with] must be set'
      unless $type || $with;

    die sprintf ('unhandled attributes [%s]', join (', ', keys %attrs))
      if values %attrs;

    die sprintf ('type [%s] is not one of [%s]', $type, join (', ', TYPES))
      unless grep $type, TYPES;

    warn '[type] is set, overrides [with]'
      if $type && $with;

    if (not defined $type)
      {
        $self->new_error ($option, ucfirst ($option) . ' is invalid')
          unless $value =~ $with;
      }
    elsif ($type eq 'url')
      {
        my $uri = URI->new ($value);
        my $scheme = $uri->scheme || '';
        my $host = eval { $uri->host };

        $self->new_error ($option, ucfirst ($option) . ' needs to be a valid URL')
          unless grep ($scheme, ('http', 'https')) && defined $host;
      }
    elsif ($type eq 'email')
      {
        my $user_part = qr/[a-z0-9!#$%&'*+\/=?^_`{|}~-]/;
        $self->new_error ($option, ucfirst ($option) . ' needs to be a valid E-Mail address')
          unless $value =~ /$user_part+(?:\.$user_part+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+
                            (?:[A-Z]{2}|com|org|net|edu|gov|mil|biz|info|mobi|name|aero|asia|jobs|museum|coop)\b/xi
      }
  }

1
