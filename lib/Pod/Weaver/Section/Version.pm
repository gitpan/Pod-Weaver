package Pod::Weaver::Section::Version;
our $VERSION = '3.093000';


use Moose;
with 'Pod::Weaver::Role::Section';
# ABSTRACT: add a VERSION pod section

use namespace::autoclean;


use Moose::Autobox;

sub weave_section {
  my ($self, $document, $input) = @_;
  return unless $input->{version};

  $document->children->push(
    Pod::Elemental::Element::Nested->new({
      command  => 'head1',
      content  => 'VERSION',
      children => [
        Pod::Elemental::Element::Pod5::Ordinary->new({
          content => sprintf('version %s', $input->{version}),
        }),
      ],
    }),
  );
}

1;

__END__
=pod

=head1 NAME

Pod::Weaver::Section::Version - add a VERSION pod section

=head1 VERSION

version 3.093000

=head1 OVERVIEW

This section plugin will produce a hunk of Pod meant to indicate the version of
the document being viewed, like this:

  =head1 VERSION

  version 1.234

It will do nothing if there is no C<version> entry in the input.

=head1 AUTHOR

  Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

