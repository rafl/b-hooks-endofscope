use strict;
use warnings;

use ExtUtils::MakeMaker;

my $mymeta_works = eval { ExtUtils::MakeMaker->VERSION('6.5707'); 1 };
my $mymeta = $mymeta_works || eval { ExtUtils::MakeMaker->VERSION('6.5702'); 1 };

my %BUILD_DEPS = (
# this is liquid horror!!! (but so seems the entire MakeMaker::Custom)
##{ ($plugin->get_default('BUILD_REQUIRES') =~ /^[^\n]*\n(.+)\n[^\n]+$/s)[0] ##}
);

my %RUN_DEPS = (
# this is liquid horror!!! (but so seems the entire MakeMaker::Custom)
##{ ($plugin->get_default('PREREQ_PM') =~ /^[^\n]*\n(.+)\n[^\n]+$/s)[0] ##}
);

my %WriteMakefileArgs = (
  "NAME" => "B::Hooks::EndOfScope",
  "ABSTRACT" => "Execute code after a scope finished compilation",
  "AUTHOR" => "Florian Ragwitz <rafl\@debian.org>",
  "DISTNAME" => "B-Hooks-EndOfScope",
  "LICENSE" => "perl",
  "VERSION_FROM" => 'lib/B/Hooks/EndOfScope.pm',
  "test" => {
    "TESTS" => "t/*.t"
  },

##{ $plugin->get_default('CONFIGURE_REQUIRES') ##}

  "PREREQ_PM" => {
    %RUN_DEPS,
    $mymeta_works ? () : (%BUILD_DEPS),
  },

  $mymeta_works
    ? ( # BUILD_REQUIRES makes MYMETA right, requires stops META being wrong
      "BUILD_REQUIRES" => \%BUILD_DEPS,
      "META_ADD" => {
        requires => \%RUN_DEPS,
      },
    )
    : ( # META_ADD both to get META right - only Makefile written
      "META_ADD" => {
        requires => \%RUN_DEPS,
        build_requires => \%BUILD_DEPS,
      },
    )
  ,

  ($mymeta and !$mymeta_works) ? ( 'NO_MYMETA' => 1 ) : (),
);


unless ( eval { ExtUtils::MakeMaker->VERSION('6.56') } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION('6.52') };

WriteMakefile(%WriteMakefileArgs);
