package Pod::Weaver::Role::Dialect;
our $VERSION = '3.093130';


use Moose::Role;
with 'Pod::Weaver::Role::Plugin';
# ABSTRACT: something that translates Pod subdialects to standard Pod5


requires 'translate_dialect';

no Moose::Role;
1;

__END__
=pod

=head1 NAME

Pod::Weaver::Role::Dialect - something that translates Pod subdialects to standard Pod5

=head1 VERSION

version 3.093130

=head1 IMPLEMENTING

The Dialect role indicates that a plugin will be used to pre-process the input
Pod document before weaving begins.  The plugin must provide a
C<translate_dialect> method which will be called with the input hashref's
C<pod_document> entry.  It is expected to modify the document in place.

=head1 AUTHOR

  Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
