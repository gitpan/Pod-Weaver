package Pod::Weaver::Role::Plugin;
our $VERSION = '3.093120';


use Moose::Role;
# ABSTRACT: a Pod::Weaver plugin

use namespace::autoclean;


has plugin_name => (
  is  => 'ro',
  isa => 'Str',
  required => 1,
);


has weaver => (
  is  => 'ro',
  isa => 'Pod::Weaver',
  required => 1,
  weak_ref => 1,
  handles  => [ qw(log) ],
);

1;

__END__
=pod

=head1 NAME

Pod::Weaver::Role::Plugin - a Pod::Weaver plugin

=head1 VERSION

version 3.093120

=head1 ATTRIBUTES

=head2 plugin_name

This name must be unique among all other plugins loaded into a weaver.  In
general, this will be set up by the configuration reader.

=head2 weaver

This is the Pod::Weaver object into which the plugin was loaded.  In general,
this will be set up when the weaver is instantiated from config.

=head1 IMPLEMENTING

This is the most basic role that all plugins must perform.

=head1 AUTHOR

  Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

