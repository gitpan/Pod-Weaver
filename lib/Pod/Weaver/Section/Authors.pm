package Pod::Weaver::Section::Authors;
BEGIN {
  $Pod::Weaver::Section::Authors::VERSION = '3.101270';
}
use Moose;
with 'Pod::Weaver::Role::Section';
# ABSTRACT: a section listing authors

use Moose::Autobox;

use Pod::Elemental::Element::Nested;
use Pod::Elemental::Element::Pod5::Verbatim;


sub weave_section {
  my ($self, $document, $input) = @_;

  return unless $input->{authors};

  my $name = $input->{authors}->length > 1 ? 'AUTHORS' : 'AUTHOR';
  my $str  = $input->{authors}->join("\n");

  $str =~ s{^}{  }mg;

  $document->children->push(
    Pod::Elemental::Element::Nested->new({
      type     => 'command',
      command  => 'head1',
      content  => $name,
      children => [
        Pod::Elemental::Element::Pod5::Verbatim->new({ content => $str }),
      ],
    }),
  );
}

no Moose;
1;

__END__
=pod

=head1 NAME

Pod::Weaver::Section::Authors - a section listing authors

=head1 VERSION

version 3.101270

=head1 OVERVIEW

This section adds a listing of the documents authors.  It expects a C<authors>
input parameter to be an arrayref of strings.  If no C<authors> parameter is
given, it will do nothing.  Otherwise, it produces a hunk like this:

  =head1 AUTHORS

    Author One <a1@example.com>
    Author Two <a2@example.com>

=head1 AUTHOR

  Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

