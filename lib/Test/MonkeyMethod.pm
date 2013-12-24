package Test::MonkeyMethod;

use v5.10;
use strict;

our $VERSION = 0.01;

use base qw(Exporter);
our @EXPORT_OK = qw|monkey unmonkey|;
our %EXPORT_TAGS = ('all'=>[qw|monkey unmonkey|]);

my %monkey_map = (); # All currently monkied methods

# ------------------------------------------------------------------------------

sub monkey($&) {
	my $class = shift;
	unshift @_, $class if $class ne __PACKAGE__;

	my $method_to_monkey = shift;
	my $code			 = shift;

	unless (exists $monkey_map{$method_to_monkey}) {
		# Not already been monkied, so we need to store the original
		# away so we can unmokey it later. Only do this if we haven't
		# already done so, so that we don't blitz the original if
		# we double-monkey.
		$monkey_map{$method_to_monkey} = \&{$method_to_monkey};
	}

	eval("*".$method_to_monkey.' = \&$code');
	return;
}

# ------------------------------------------------------------------------------

sub unmonkey(;$) {
	my $class = shift;
	unshift @_, $class if $class ne __PACKAGE__;
	
	my $method_to_unmonkey = shift;

	if (!$method_to_unmonkey) {
		# No specific method to unmonkey so unmonkey all the
		# currently monkied methods.
		_unmonkey_all();
	}
	else {
		unless ( exists $monkey_map{$method_to_unmonkey} ) {
			# Oops, can't unmonkey it if it ain't bin' monkied
			die "Method '$method_to_unmonkey' not monkied";
		}
		my $original = $monkey_map{$method_to_unmonkey};
		eval('*'.$method_to_unmonkey.' = \&{$monkey_map{$method_to_unmonkey}}');
	}
	return;
}

# ------------------------------------------------------------------------------

sub DESTROY {
	_unmonkey_all();
}

# ------------------------------------------------------------------------------

sub _unmonkey_all {
	while( my($method,$code) = each %monkey_map ) {
		eval('*'.$method.' = \&$code');
	}
}

1;

=head1 Test::MonkeyMethod

Simple method monkey patching for easy unit tests

=head1 Synopsis

  use Test::MonkeyMethod qw(:all);

  use DuckPackage;
  my $duck = DuckPackage->new;

  $duck->speak; # prints 'quack'

  monkey 'DuckPackage::speak', sub { print 'woof' };

  $duck->speak; # now prints 'woof'!

  unmonkey 'DuckPackage::speak'; # Reset the monkied method
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

=head1 Caveats

=over 1

=item * Not scoped

This is designed as a simple monkey method patcher and as such does not attempt
to be scope safe or observe such niceties - it is up to the user to ensure
they C<unmonkey> that which they hast called C<monkey>.

=back


=head1 Methods

=head2 monkey

  monkey 'My::Package::method', sub { 'do something new' };

Monkey patch a given method with a new code block.


=head2 unmonkey

  unmonkey 'My::Package::method'; # Unmonkey a specific method
  unmonkey; # Unmonkey all currently monkied methods

Restore a monkied method (or all of them) with their original incarnation.

=cut 
