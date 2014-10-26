package Pod::Weaver::Section::Name;
BEGIN {
  $Pod::Weaver::Section::Name::VERSION = '3.101631';
}
use Moose;
with 'Pod::Weaver::Role::Section';
# ABSTRACT: add a NAME section with abstract (for your Perl module)

use Moose::Autobox;


use Pod::Elemental::Element::Pod5::Command;
use Pod::Elemental::Element::Pod5::Ordinary;
use Pod::Elemental::Element::Nested;

sub _get_docname_via_statement {
  my ($self, $ppi_document) = @_;

  my $pkg_node = $ppi_document->find_first('PPI::Statement::Package');
  return unless $pkg_node;
  return $pkg_node->namespace;
}

sub _get_docname_via_comment {
  my ($self, $ppi_document) = @_;

  my ($docname) = $ppi_document->serialize =~ /^\s*#+\s*PODNAME:\s*(.+)$/m;
  return $docname;
}

sub _get_docname {
  my ($self, $input) = @_;

  my $ppi_document = $input->{ppi_document};

  my $docname = $self->_get_docname_via_comment($ppi_document)
             || $self->_get_docname_via_statement($ppi_document);

  return $docname;
}

sub _get_abstract {
  my ($self, $input) = @_;

  my $ppi_document = $input->{ppi_document};

  my ($abstract) = $ppi_document->serialize =~ /^\s*#+\s*ABSTRACT:\s*(.+)$/m;

  return $abstract;
}

sub weave_section {
  my ($self, $document, $input) = @_;

  my $filename = $input->{filename} || 'file';

  my $docname  = $self->_get_docname($input);
  my $abstract = $self->_get_abstract($input);

  Carp::croak sprintf "couldn't determine document name for %s", $filename
    unless $docname;

  $self->log([ "couldn't find abstract in %s", $filename ]) unless $abstract;
 
  my $name = $docname;
  $name .= " - $abstract" if $abstract;

  my $name_para = Pod::Elemental::Element::Nested->new({
    command  => 'head1',
    content  => 'NAME',
    children => [
      Pod::Elemental::Element::Pod5::Ordinary->new({ content => $name }),
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

version 3.101631

=head1 OVERVIEW

This section plugin will produce a hunk of Pod giving the name of the document
as well as an abstract, like this:

  =head1 NAME

  Some::Document - a document for some

It will determine the name and abstract by inspecting the C<ppi_document> which
must be given.  It looks for comments in the form:

  # ABSTRACT: a document for some
  # PODNAME: Some::Package::Name

If no C<PODNAME> comment is present, but a package declaration can be found,
the package name will be used as the document name.

=head1 AUTHOR

Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

