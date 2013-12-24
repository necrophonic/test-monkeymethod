#!/usr/bin/perl

use strict;

use Test::More;
use Test::Exception;

use Test::MonkeyMethod qw(:all);

lives_ok { monkey   'Test::More::ok', sub($;$) {'not ok :-p'} } "Method 'monkey' exported";
lives_ok { unmonkey 'Test::More::ok' } "Method 'unmonkey' exported";
lives_ok { unmonkey } "Method 'unmonkey' exported (null args)";

# Try a quick monkey...
is TestPackage::a_method(), 'blah', 'unmonkied';
monkey 'TestPackage::a_method', sub { 'foo' };
is TestPackage::a_method(), 'foo', 'monkied';
unmonkey;
is TestPackage::a_method(), 'blah', 'back to unmonkied';

done_testing;

package TestPackage;
sub a_method { 'blah' };
1;