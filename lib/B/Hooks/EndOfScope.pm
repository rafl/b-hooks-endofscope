use strict;
use warnings;

package B::Hooks::EndOfScope;
# ABSTRACT: Execute code after a scope finished compilation

use 5.008000;
use Variable::Magic 0.34;

use Sub::Exporter -setup => {
    exports => ['on_scope_end'],
    groups  => { default => ['on_scope_end'] },
};


=head1 SYNOPSIS

    on_scope_end { ... };

=head1 DESCRIPTION

This module allows you to execute code when perl finished compiling the
surrounding scope.

=func on_scope_end

    on_scope_end { ... };

    on_scope_end $code;

Registers C<$code> to be executed after the surrounding scope has been
compiled.

This is exported by default. See L<Sub::Exporter> on how to customize it.

=cut

{
    my $wiz = Variable::Magic::wizard
        data => sub { [$_[1]] },
        free => sub { $_->() for @{ $_[1] }; () };

    sub on_scope_end (&) {
        my $cb = shift;

        $^H |= 0x020000;

        if (my $stack = Variable::Magic::getdata %^H, $wiz) {
            push @{ $stack }, $cb;
        }
        else {
            Variable::Magic::cast %^H, $wiz, $cb;
        }
    }
}

=head1 SEE ALSO

L<Sub::Exporter>

L<Variable::Magic>

=cut

1;
