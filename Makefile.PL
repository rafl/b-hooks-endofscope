use strict;
use warnings;
use inc::Module::Install;

name 'B-Hooks-EndOfScope';
all_from 'lib/B/Hooks/EndOfScope.pm';

extra_tests;

WriteAll;
