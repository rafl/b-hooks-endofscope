use strict;
use warnings;
use Test::More;

use B::Hooks::EndOfScope;

our $called;

sub foo {
    BEGIN { on_scope_end { $called = 1 } }

    # uncomment this to make the test pass
    eval '42';
}

BEGIN {
    ok($called, 'callback invoked');
}

done_testing;
