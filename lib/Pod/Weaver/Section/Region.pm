package Pod::Weaver::Section::Region;
our $VERSION = '3.093530';
use Moose;
with 'Pod::Weaver::Role::Section';
# ABSTRACT: find a region and put its contents in place where desired

use Moose::Autobox;

use Pod::Elemental::Element::Pod5::Region;
use Pod::Elemental::Selectors -all;
use Pod::Elemental::Types qw(FormatName);

has required => (
  is  => 'ro',
  isa => 'Bool',
  default => 0,
);

has region_name => (
  is   => 'ro',
  isa  => FormatName,
  lazy => 1,
  required => 1,
  default  => sub { $_[0]->plugin_name },
);

sub weave_section {
  my ($self, $document, $input) = @_;

  my @to_insert;

  my $idc = $input->{pod_document}->children;
  IDX: for (my $i = 0; $i < $idc->length; $i++) {
    next unless my $para = $idc->[ $i ];
    next unless $para->isa('Pod::Elemental::Element::Pod5::Region')
         and    $para->is_pod
         and    $para->format_name eq $self->region_name;

    push @to_insert, $para->children->flatten;
    splice @$idc, $i, 1;

    redo IDX;
  }

  $document->children->push(@to_insert);
}

no Moose;
1;

__END__
=pod

=head1 NAME

Pod::Weaver::Section::Region - find a region and put its contents in place where desired

=head1 VERSION

version 3.093530

=head1 AUTHOR

  Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

