
use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  DISTNAME  => 'Pod-Weaver',
  NAME      => 'Pod::Weaver',
  AUTHOR    => 'Ricardo\ SIGNES\ \<rjbs\@cpan\.org\>',
  ABSTRACT  => 'do horrible things to POD, producing better docs',
  VERSION   => '1.002',
  EXE_FILES => [ qw() ],
  (eval { ExtUtils::MakeMaker->VERSION(6.21) } ? (LICENSE => 'perl') : ()),
  PREREQ_PM    => {
    "PPI" => '0',
    "Test::Differences" => '0',
    "Pod::Eventual" => '0.003',
    "Moose::Autobox" => '0',
    "List::MoreUtils" => '0',
  },
);
