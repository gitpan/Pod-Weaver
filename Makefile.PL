
use strict;
use warnings;



use ExtUtils::MakeMaker 6.11;



my %WriteMakefileArgs = (
                       'test' => {
                                   'TESTS' => 't/*.t'
                                 },
                       'NAME' => 'Pod::Weaver',
                       'DISTNAME' => 'Pod-Weaver',
                       'AUTHOR' => 'Ricardo SIGNES <rjbs@cpan.org>',
                       'ABSTRACT' => 'weave together a Pod document from an outline',
                       'EXE_FILES' => [],
                       'VERSION' => '3.100310',
                       'LICENSE' => 'perl',
                       'PREREQ_PM' => {
                                        'PPI' => '0',
                                        'Config::MVP::Reader::INI' => '0',
                                        'Pod::Elemental' => '0.100220',
                                        'namespace::autoclean' => '0',
                                        'ExtUtils::MakeMaker' => '6.11',
                                        'String::RewritePrefix' => '0',
                                        'Moose::Autobox' => '0.10',
                                        'Pod::Eventual::Simple' => '0.004',
                                        'Config::MVP' => '0.093120',
                                        'Test::Differences' => '0',
                                        'Software::License' => '0',
                                        'List::MoreUtils' => '0',
                                        'String::Flogger' => '1',
                                        'Moose' => '0'
                                      }
                     );


delete $WriteMakefileArgs{LICENSE}
  unless eval { ExtUtils::MakeMaker->VERSION(6.31) };

WriteMakefile(%WriteMakefileArgs);



