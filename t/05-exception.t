use strict;
use warnings;
use Test::More;

use B::Hooks::EndOfScope;

eval q[
    sub foo {
        BEGIN {
            on_scope_end { die 'bar' };
        }
    }
];

like($@, qr/^bar/);
pass('no segfault');

done_testing;
