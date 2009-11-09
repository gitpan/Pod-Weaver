package Pod::Weaver::Role::Transformer;
our $VERSION = '3.093130';


use Moose::Role;
with 'Pod::Weaver::Role::Plugin';
# ABSTRACT: something that restructures a Pod5 document


requires 'transform_document';

no Moose::Role;
1;

__END__
=pod

=head1 NAME

Pod::Weaver::Role::Transformer - something that restructures a Pod5 document

=head1 VERSION

version 3.093130

=head1 IMPLEMENTING

The Preparer role indicates that a plugin will be used to pre-process the input
hashref's Pod document before weaving begins.  The plugin must provide a
C<transform_document> method which will be called with the input Pod document.
It is expected to modify the input in place.

=head1 AUTHOR

  Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
