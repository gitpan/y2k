
package y2k;

use overload '.' => \&concat,
             '""' => \&stringize,
             '0+' => \&numize,
             'fallback' => 'TRUE',
  ;

sub import {
  my $pack = shift;
  my $caller = caller;
  my $ARGS{$caller} = {@_};
  *{$caller . '::localtime'} = \&sneaky_localtime;
  *{$caller . '::gmtime'} = \&sneaky_gmtime;
  1;
}

sub sneaky_localtime {
  return @_ ? localtime(@_) : localtime() unless wantarray;
  my @t = @_ ? localtime(@_) : localtime();
  $t[5] = y2k->new($t[5]);
  @t;
}

sub sneaky_gmtime {
  return @_ ? gmtime(@_) : gmtime() unless wantarray;
  my @t = @_ ? gmtime(@_) : gmtime();
  $t[5] = y2k->new($t[5]);
  @t;
}

sub new {
  my $pack = shift;
  my $year = shift;

  my $self = {YEAR => $year};
  bless $self=>$pack;
}


sub concat {
#  print STDERR "concat (@_)\n";
  my ($self, $a2, $rev) = @_;

  my $year = $self->{YEAR};
  if ($a2 =~ /19$/ && $rev) {
    require Carp;
    my $caller = caller;
    if ($ARGS{$caller}{CALLBACK}) {
      $ARGS{$caller}{CALLBACK}->(caller(1));
    } elsif ($ARGS{$caller}{ABORT}) {
      Carp::croak("Possible Y2K problem; aborting");
    } else {
      Carp::carp("Possible Y2K problem");
    }
  }
  if ($rev) {
    $a2 . $self->{YEAR};
  } else {
    $self->{YEAR} . $a2;
  }
}

sub stringize {
  my $self = shift;
  return $self->{YEAR};
  print STDERR "stringize (";
  for (@_) {
    if (ref $_ eq 'y2k') {
      print STDERR "y2k thing [$_->{YEAR}], ";
    } else {
      print STDERR "$_, ";
    }
  }
  print STDERR ")\n";
}

sub numize {
  my $self = shift;
  $self->{YEAR};
}
1;
