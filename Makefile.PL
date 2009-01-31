
use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  DISTNAME  => 'Pod-Weaver',
  NAME      => 'Pod::Weaver',
  AUTHOR    => 'Ricardo\ SIGNES\ \<rjbs\@cpan\.org\>',
  ABSTRACT  => 'do horrible things to POD, producing better docs',
  VERSION   => '2.001',
  EXE_FILES => [ qw() ],
  (eval { ExtUtils::MakeMaker->VERSION(6.21) } ? (LICENSE => 'perl') : ()),
  PREREQ_PM    => {
    "PPI" => '0',
    "Pod::Elemental" => '0',
    "String::RewritePrefix" => '0',
    "Pod::Eventual::Simple" => '0.004',
    "Moose::Autobox" => '0.08',
    "Test::Differences" => '0',
    "Software::License" => '0',
    "List::MoreUtils" => '0',
    "Moose" => '0',
    "String::Flogger" => '1',
  },
);
