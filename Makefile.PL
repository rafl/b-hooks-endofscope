use strict;
use warnings;
use inc::Module::Install;

name 'B-Hooks-EndOfScope';
all_from 'lib/B/Hooks/EndOfScope.pm';

extra_tests;

makemaker_args(dist => { PREOP => 'pod2text lib/B/Hooks/EndOfScope.pm > README' });

WriteAll;
