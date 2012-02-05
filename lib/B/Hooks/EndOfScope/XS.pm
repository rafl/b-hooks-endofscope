package B::Hooks::EndOfScope::XS;
# ABSTRACT: Execute code after a scope finished compilation - XS implementation

use strict;
use warnings;

BEGIN {
  require Module::Runtime;
  # Adjust the Makefile.PL if changing this minimum version
  Module::Runtime::use_module('Variable::Magic', '0.34');
}

use Sub::Exporter -setup => {
  exports => ['on_scope_end'],
  groups  => { default => ['on_scope_end'] },
};

my $wiz = Variable::Magic::wizard
  data => sub { [$_[1]] },
  free => sub { $_->() for @{ $_[1] }; () }
;

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

=head1 DESCRIPTION

This is the implementation of L<B::Hooks::EndOfScope> based on
L<Variable::Magic>, which is an XS module dependent on a compiler. It will
always be automatically preferred if L<Variable::Magic> is available.

=func on_scope_end

    on_scope_end { ... };

    on_scope_end $code;

Registers C<$code> to be executed after the surrounding scope has been
compiled.

This is exported by default. See L<Sub::Exporter> on how to customize it.

=cut

1;
