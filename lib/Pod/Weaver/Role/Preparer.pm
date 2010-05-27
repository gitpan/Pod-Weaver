package Pod::Weaver::Role::Preparer;
BEGIN {
  $Pod::Weaver::Role::Preparer::VERSION = '3.101460';
}
use Moose::Role;
with 'Pod::Weaver::Role::Plugin';
# ABSTRACT: something that mucks about with the input before weaving begins


requires 'prepare_input';

no Moose::Role;
1;

__END__
=pod

=head1 NAME

Pod::Weaver::Role::Preparer - something that mucks about with the input before weaving begins

=head1 VERSION

version 3.101460

=head1 IMPLEMENTING

The Preparer role indicates that a plugin will be used to pre-process the input
hashref before weaving begins.  The plugin must provide a C<prepare_input>
method which will be called with the input hashref.  It is expected to modify
the input in place.

=head1 AUTHOR

  Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

