use strict;
use warnings;
use Test::More tests => 2;

use B::Hooks::EndOfScope;

eval q[
    sub foo {
        BEGIN {
            on_scope_end { die 'bar' };
        }
    }
];

TODO: {
    local $TODO = 'exceptions in on_scope_end not working yet';
    # that's probably a Variable::Magic issue
    is($@, 'bar'); 
}

pass('no segfault');
