package Test::MonkeyMethod;

use v5.10;
use strict;


=head1 Test::MonkeyMethod

Simple method monkey patching for easy unit tests

=head1 Synopsis

  use Test::MonkeyMethod qw(:export);

  use DuckPackage;
  my $duck = DuckPackage->new;

  $duck->speak; # prints 'quack'

  monkey DuckPackage::speak, sub { print 'woof' };

  $duck->speak; # now prints 'woof'!

  unmonkey DuckPackage::speak; # Reset the monkied method
  # or
  unmonkey; # Reset all currently monkied methods

  $duck->speak; # quacking again!

  # ----
  # Can also use without polluting your namespace...

  Test::MonkeyMethod::monkey( 'DuckPackage::speak', sub { print 'woof' });


=head1 Description

There are a few monkey patching modules around but none of them seem to
just do a nice basic stub/unstub of methods without a lot of associated stuff.

C<Test::MonkeyMethod> aims to provide a simple switch-in, switch-out
monkey patching interface stubbing methods.

=head1 Exports


