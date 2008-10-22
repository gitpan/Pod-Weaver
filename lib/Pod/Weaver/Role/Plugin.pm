package Pod::Weaver::Role::Plugin;
our $VERSION = '2.000';


use Moose::Role;

has plugin_name => (
  is  => 'ro',
  isa => 'Str',
  required => 1,
  init_arg => '=name',
);

has weaver => (
  is  => 'ro',
  isa => 'Pod::Weaver',
  required => 1,
  weak_ref => 1,
  handles  => [ qw(log) ],
);

no Moose::Role;
1;

__END__
=head1 NAME

Pod::Weaver::Role::Plugin

=head1 VERSION

version 2.000

=head1 AUTHOR

  Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2008 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as perl itself.

