use strict;
use warnings;
package Pod::Weaver::PluginBundle::CorePrep;
our $VERSION = '3.100650';
# ABSTRACT: a bundle for the most commonly-needed prep work for a pod document

use Pod::Weaver::Plugin::H1Nester;

sub mvp_bundle_config {
  return (
    [ '@CorePrep/EnsurePod5', 'Pod::Weaver::Plugin::EnsurePod5', {} ],
    # dialects should run here
    [ '@CorePrep/H1Nester',   'Pod::Weaver::Plugin::H1Nester',   {} ],
  );
}

1;

__END__
=pod

=head1 NAME

Pod::Weaver::PluginBundle::CorePrep - a bundle for the most commonly-needed prep work for a pod document

=head1 VERSION

version 3.100650

=head1 AUTHOR

  Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

