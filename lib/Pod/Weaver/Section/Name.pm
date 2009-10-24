package Pod::Weaver::Section::Name;
our $VERSION = '3.092970';


use Moose;
with 'Pod::Weaver::Role::Section';
# ABSTRACT: add a NAME section with abstract (for your Perl module)

use Moose::Autobox;


use Pod::Elemental::Element::Pod5::Command;
use Pod::Elemental::Element::Pod5::Ordinary;
use Pod::Elemental::Element::Nested;

sub weave_section {
  my ($self, $document, $input) = @_;

# my $pkg_node = $self->weaver->ppi_doc->find_first('PPI::Statement::Package');
#
# Carp::croak
#   sprintf "couldn't find package declaration in %s", $arg->{filename}
#   unless $pkg_node;
#
# my $package = $pkg_node->namespace;
#
# $self->log([ "couldn't find abstract in %s", $arg->{filename} ])
#    unless my ($abstract) = $self->weaver->ppi_doc->serialize =~ /^\s*#+\s*ABSTRACT:\s*(.+)$/m;
#
# my $name = $package;
# $name .= " - $abstract" if $abstract;

  my $name_para = Pod::Elemental::Element::Nested->new({
    command  => 'head1',
    content  => 'NAME',
    children => [
      Pod::Elemental::Element::Pod5::Ordinary->new({
        content => "Module::Name - abstract text"
      }),
    ],
  });
  
  $document->children->push($name_para);
}

1;

__END__
=pod

=head1 NAME

Pod::Weaver::Section::Name - add a NAME section with abstract (for your Perl module)

=head1 VERSION

version 3.092970

=head1 OVERVIEW

This section plugin will produce a hunk of Pod giving the name of the document
as well as an abstract, like this:

  =head1 NAME
  Some::Document - a document for some

It will determine the name and abstract by inspecting the C<ppi_document> which
must be given.  It will look for the first package declaration, and for a
comment in this form:

  # ABSTRACT: a document for some

=head1 AUTHOR

Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

