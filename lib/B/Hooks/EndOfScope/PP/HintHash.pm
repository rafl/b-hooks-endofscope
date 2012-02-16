# Implementtion of a pure-perl on_scope_end for perl 5.8.X
# (relies on Hash::Util:FieldHash)

package # hide from the pauses
  B::Hooks::EndOfScope::PP::HintHash;

use strict;
use warnings;

# This is the original implementation, which sadly is broken
# on perl 5.10+ within string evals
sub on_scope_end (&) {
  $^H |= 0x020000;

  push @{
    $^H{'__B_H_EOS__guardstack__'}
      ||= bless ([], 'B::Hooks::EndOfScope::PP::_SG_STACK')
  }, shift;
}

package # hide from the pauses
  B::Hooks::EndOfScope::PP::_SG_STACK;

use warnings;
use strict;

sub DESTROY {
  B::Hooks::EndOfScope::PP::__invoke_callback($_) for @{$_[0]};
}

1;
