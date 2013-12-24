#!/usr/bin/perl

use Test::More tests => 3;

use_ok 'Test::MonkeyMethod';

can_ok 'Test::MonkeyMethod', qw(monkey unmonkey);

subtest 'simple patch and unpatch' => sub {
	plan tests => 4;
	is My::TestPackage::a_method(), 'abc', 'unpatched method correct';
	Test::MonkeyMethod::monkey( 'My::TestPackage::a_method', sub { '123' });
	is My::TestPackage::a_method(), '123', 'patched method correct';
	Test::MonkeyMethod::monkey( 'My::TestPackage::a_method', sub { 'xyz' });
	is My::TestPackage::a_method(), 'xyz', 're-patched method correct';
	Test::MonkeyMethod::unmonkey('My::TestPackage::a_method');
	is My::TestPackage::a_method(), 'abc', 'unpatched method correct again';
};

done_testing();


package My::TestPackage;

sub a_method { return 'abc' }

1;
