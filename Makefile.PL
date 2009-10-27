
use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  DISTNAME  => 'Pod-Weaver',
  NAME      => 'Pod::Weaver',
  AUTHOR    => "Ricardo\ SIGNES\ \<rjbs\@cpan\.org\>",
  ABSTRACT  => "weave\ together\ a\ Pod\ document\ from\ an\ outline",
  VERSION   => '3.093000',
  EXE_FILES => [ qw() ],
  (eval { ExtUtils::MakeMaker->VERSION(6.31) } ? (LICENSE => 'perl') : ()),
  PREREQ_PM    => {
    "PPI" => '0',
    "Pod::Elemental" => '0.092941',
    "namespace::autoclean" => '0',
    "String::RewritePrefix" => '0',
    "Moose::Autobox" => '0.10',
    "Pod::Eventual::Simple" => '0.004',
    "Config::MVP" => '0.092990',
    "Test::Differences" => '0',
    "Software::License" => '0',
    "List::MoreUtils" => '0',
    "String::Flogger" => '1',
    "Moose" => '0',
  },
  test => {TESTS => 't/*.t'}
);

