use strict;
use warnings;
use Test::More tests => 5;

BEGIN { use_ok('B::Hooks::EndOfScope') }

BEGIN {
    ok(exists &on_scope_end, 'on_scope_end imported');
    is(prototype('on_scope_end'), '&', '.. and has the right prototype');
}

our $i;

BEGIN { $i = 0 }

sub foo {
    BEGIN {
        on_scope_end { $i = 42 };
        on_scope_end { $i = 1 };
    };

    is($i, 1);
}

BEGIN { is($i, 1) }
foo();
