use strict;
use warnings;

package B::Hooks::EndOfScope;

use Scope::Guard;

our $VERSION = '0.01';

our $SCOPE_HOOK_KEY = 'SCOPE_END_HOOK';

use Sub::Exporter -setup => {
    exports => ['on_scope_end'],
    groups  => { default => ['on_scope_end'] },
};

sub on_scope_end (&) {
    my $cb = shift;

    $^H |= 0x120000;
    $^H{ $SCOPE_HOOK_KEY } = [Scope::Guard->new($cb), @{ $^H{ $SCOPE_HOOK_KEY } || [] }];
}

1;
