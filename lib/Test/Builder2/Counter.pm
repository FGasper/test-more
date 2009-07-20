package Test::Builder2::Counter;

use Carp;
use Mouse;

with 'Test::Builder2::Singleton';


=head1 NAME

Test::Builder2::Counter - Counts the number of tests run

=head1 SYNOPSIS

  use Test::Builder2::Counter;

  my $counter = Test::Builder2::Counter->singleton;

  $counter->increment;
  $counter->set($count);
  $counter->get;

=head1 DESCRIPTION

This object simply contains the count of the number of tests run as a
simple positive integer.

Most testing systems don't care how many tests run, but this is very
important for TAP output.

Test::Builder2::Counter is normally used through
Test::Builder2::History, but you can get it separately if you want to
be really slim.

=head1 METHODS

=head2 Constructors

=head3 singleton

    my $counter = Test::Builder2::Counter->singleton;

Gets the single shared counter.

=head3 create

    my $counter = Test::Builder2::Counter->create;

Creates a brand new counter starting at 0.

=head2 The Count

=head3 increment

    my $count = $counter->increment;
    my $count = $counter->increment($amount);

Increments the counter by $amount or 1 if $amount is not given.

Returns the new $count.

Like C<<++$count>>.

=cut

use Mouse::Util::TypeConstraints;
subtype Positive_Int => (
    as 'Int',
    where { $_ >= 0 },
);

has _count => (
    is          => 'rw',
    isa         => 'Positive_Int',
    default     => 0,
);

sub increment {
    my $self = shift;
    my $amount = @_ ? shift : 1;

    my $new_amount = $self->_count + $amount;
    $self->set( $new_amount );

    return $new_amount;
}

=head3 set

    my $count_was = $counter->set($count);

Sets the counter to $count.

Return what the $count_was.

=cut

sub set {
    my $self = shift;

    my $was = $self->_count;
    $self->_count(shift);

    return $was;
}

=head3 get

    my $count = $counter->get;

Gets the $count.

=cut

sub get {
    my $self = shift;

    return $self->_count;
}

1;
