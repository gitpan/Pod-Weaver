
use strict;
use warnings;



use ExtUtils::MakeMaker 6.11;



my %WriteMakefileArgs = (
                       'test' => {
                                   'TESTS' => 't/*.t'
                                 },
                       'NAME' => 'Pod::Weaver',
                       'DISTNAME' => 'Pod-Weaver',
                       'CONFIGURE_REQUIRES' => {
                                                 'ExtUtils::MakeMaker' => '6.11'
                                               },
                       'AUTHOR' => 'Ricardo SIGNES <rjbs@cpan.org>',
                       'BUILD_REQUIRES' => {},
                       'ABSTRACT' => 'weave together a Pod document from an outline',
                       'EXE_FILES' => [],
                       'VERSION' => '3.100680',
                       'PREREQ_PM' => {
                                        'PPI' => '0',
                                        'Pod::Elemental' => '0.100220',
                                        'Config::MVP' => '0.093120',
                                        'Config::MVP::Assembler::WithBundles' => '0',
                                        'Software::License' => '0',
                                        'List::MoreUtils' => '0',
                                        'String::Flogger' => '1',
                                        'Moose::Role' => '0',
                                        'Config::MVP::Reader::INI' => '0',
                                        'Pod::Elemental::Types' => '0',
                                        'Config::MVP::Reader' => '0',
                                        'Moose::Autobox' => '0.10',
                                        'Test::More' => '0',
                                        'Pod::Elemental::Element::Pod5::Ordinary' => '0',
                                        'Test::Differences' => '0',
                                        'Config::MVP::Reader::Finder' => '0',
                                        'Pod::Elemental::Transformer::Nester' => '0',
                                        'Config::MVP::Assembler' => '0',
                                        'String::RewritePrefix' => '0',
                                        'Pod::Elemental::Element::Pod5::Region' => '0',
                                        'Pod::Eventual::Simple' => '0.004',
                                        'Pod::Elemental::Element::Pod5::Verbatim' => '0',
                                        'Pod::Elemental::Element::Pod5::Command' => '0',
                                        'Params::Util' => '0',
                                        'Moose' => '0',
                                        'namespace::autoclean' => '0',
                                        'Pod::Elemental::Transformer::Gatherer' => '0',
                                        'Pod::Elemental::Document' => '0',
                                        'Pod::Elemental::Transformer::Pod5' => '0',
                                        'Pod::Elemental::Selectors' => '0',
                                        'Pod::Elemental::Element::Nested' => '0',
                                        'Software::License::Artistic_1_0' => '0'
                                      },
                       'LICENSE' => 'perl'
                     );


delete $WriteMakefileArgs{LICENSE}
  unless eval { ExtUtils::MakeMaker->VERSION(6.31) };

WriteMakefile(%WriteMakefileArgs);



