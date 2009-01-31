package Pod::Weaver::Role::Weaver;
our $VERSION = '2.001';

use Moose::Role;
with 'Pod::Weaver::Role::Plugin';
# ABSTRACT: a weaver plugin

requires 'weave';

no Moose::Role;
1;

__END__

=pod

=head1 NAME

Pod::Weaver::Role::Weaver - a weaver plugin

=head1 VERSION

version 2.001

=head1 AUTHOR

  Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as perl itself.

=cut 


