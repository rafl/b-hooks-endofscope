use strict;
use warnings;
use inc::Module::Install;

name 'B-Hooks-EndOfScope';
all_from 'lib/B/Hooks/EndOfScope.pm';

requires 'Scope::Guard';
requires 'Sub::Exporter';
test_requires 'Test::More';

extra_tests;

makemaker_args(dist => { PREOP => 'pod2text lib/B/Hooks/EndOfScope.pm > README' });

WriteAll;
