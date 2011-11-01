
use strict;
use warnings;



use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "weave together a Pod document from an outline",
  "AUTHOR" => "Ricardo SIGNES <rjbs\@cpan.org>",
  "BUILD_REQUIRES" => {
    "PPI" => 0,
    "Software::License::Artistic_1_0" => 0,
    "Software::License::Perl_5" => 0,
    "Test::Differences" => 0,
    "Test::More" => "0.96"
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "Pod-Weaver",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "NAME" => "Pod::Weaver",
  "PREREQ_PM" => {
    "Config::MVP" => 2,
    "Config::MVP::Assembler" => 0,
    "Config::MVP::Assembler::WithBundles" => 0,
    "Config::MVP::Reader::Finder" => 0,
    "Config::MVP::Reader::INI" => 0,
    "DateTime" => 0,
    "File::Spec" => 0,
    "List::MoreUtils" => 0,
    "Log::Dispatchouli" => "1.100710",
    "Moose" => 0,
    "Moose::Autobox" => "0.10",
    "Moose::Role" => 0,
    "Params::Util" => 0,
    "Pod::Elemental" => "0.100220",
    "Pod::Elemental::Document" => 0,
    "Pod::Elemental::Element::Nested" => 0,
    "Pod::Elemental::Element::Pod5::Command" => 0,
    "Pod::Elemental::Element::Pod5::Ordinary" => 0,
    "Pod::Elemental::Element::Pod5::Region" => 0,
    "Pod::Elemental::Element::Pod5::Verbatim" => 0,
    "Pod::Elemental::Selectors" => 0,
    "Pod::Elemental::Transformer::Gatherer" => 0,
    "Pod::Elemental::Transformer::Nester" => 0,
    "Pod::Elemental::Transformer::Pod5" => 0,
    "Pod::Elemental::Types" => 0,
    "String::Flogger" => 1,
    "String::Formatter" => "0.100680",
    "String::RewritePrefix" => 0,
    "Text::Wrap" => 0,
    "namespace::autoclean" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "VERSION" => "3.101634",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
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
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



