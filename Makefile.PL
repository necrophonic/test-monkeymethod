use 5.010001;

use strict;
use warnings;

use Config;
use ExtUtils::MakeMaker;

WriteMakefile(
	NAME		=> 'Test_MonkeyMethod',
	VERSION_FROM=> 'lib/Test/MonkeyMethod.pm',
	ABSTRACT	=> 'Simple method monkey patching',
	AUTHOR		=> 'J Gregory <john@johngregory.me.uk>',
	LICENSE		=> 'artistic_2',
	PREREQ_PM	=> {
		
	},
	BUILD_REQUIRES => {
		"Test::More" 	  => '0.99',
		"Test::Exception" => '0.32'
	},
	test 			=> {
		TESTS	=> 't/*.t'
	},
	'dist'          => { COMPRESS => "gzip -9", SUFFIX => "gz" },
);
