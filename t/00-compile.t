use strict;
use warnings;

# This test was generated via Dist::Zilla::Plugin::Test::Compile 2.018

use Test::More 0.88;



use Capture::Tiny qw{ capture };

my @module_files = qw(
Pod/Weaver.pm
Pod/Weaver/Config.pm
Pod/Weaver/Config/Assembler.pm
Pod/Weaver/Config/Finder.pm
Pod/Weaver/Plugin/EnsurePod5.pm
Pod/Weaver/Plugin/H1Nester.pm
Pod/Weaver/Plugin/Transformer.pm
Pod/Weaver/PluginBundle/CorePrep.pm
Pod/Weaver/PluginBundle/Default.pm
Pod/Weaver/Role/Dialect.pm
Pod/Weaver/Role/Finalizer.pm
Pod/Weaver/Role/Plugin.pm
Pod/Weaver/Role/Preparer.pm
Pod/Weaver/Role/Section.pm
Pod/Weaver/Role/Transformer.pm
Pod/Weaver/Section/Authors.pm
Pod/Weaver/Section/Bugs.pm
Pod/Weaver/Section/Collect.pm
Pod/Weaver/Section/Generic.pm
Pod/Weaver/Section/Leftovers.pm
Pod/Weaver/Section/Legal.pm
Pod/Weaver/Section/Name.pm
Pod/Weaver/Section/Region.pm
Pod/Weaver/Section/Version.pm
);

my @scripts = qw(

);

# no fake home requested

my @warnings;
for my $lib (@module_files)
{
    my ($stdout, $stderr, $exit) = capture {
        system($^X, '-Mblib', '-e', qq{require q[$lib]});
    };
    is($?, 0, "$lib loaded ok");
    warn $stderr if $stderr;
    push @warnings, $stderr if $stderr;
}



is(scalar(@warnings), 0, 'no warnings found') if $ENV{AUTHOR_TESTING};



done_testing;
