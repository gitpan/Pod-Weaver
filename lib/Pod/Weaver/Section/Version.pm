package Pod::Weaver::Section::Version;
{
  $Pod::Weaver::Section::Version::VERSION = '3.101633';
}
use Moose;
with 'Pod::Weaver::Role::Section';
# ABSTRACT: add a VERSION pod section

use namespace::autoclean;


use DateTime;
use Moose::Autobox;

use String::Formatter 0.100680 stringf => {
  -as => '_format_version',

  input_processor => 'require_single_input',
  string_replacer => 'method_replace',
  codes => {
    v => sub { $_[0]->{version} },
    d => sub {
      Class::MOP::load_class( 'DateTime', { -version => '0.44' } ); # CLDR fixes
      DateTime->from_epoch(epoch => $^T, time_zone => $_[0]->{self}->time_zone)
              ->format_cldr($_[1]),
    },
    r => sub { $_[0]->{zilla}->name },
    m => sub { $_[0]->{module} },
    t => sub { "\t" },
    n => sub { "\n" },
  },
};


has format => (
  is  => 'ro',
  isa => 'Str',
  default => 'version %v',
);


has is_verbatim => (
  is  => 'ro',
  isa => 'Bool',
  default => 0,
);


has time_zone => (
  is  => 'ro',
  isa => 'Str', # should be more validated later -- apocal
  default => 'local',
);

sub weave_section {
  my ($self, $document, $input) = @_;
  return unless $input->{version};

  my %args = (
    self => $self,
    version => $input->{version},
  );
  $args{zilla} = $input->{zilla} if exists $input->{zilla};

  if ( exists $input->{ppi_document} ) {
    my $pkg_node = $input->{ppi_document}->find_first('PPI::Statement::Package');
    $args{module} = $pkg_node->namespace if $pkg_node;
  }

  my $content = _format_version($self->format, \%args);
  if ( $self->is_verbatim ) {
    $content = Pod::Elemental::Element::Pod5::Verbatim->new({
      content => "  $content",
    });
  } else {
    $content = Pod::Elemental::Element::Pod5::Ordinary->new({
      content => $content,
    });
  }

  $document->children->push(
    Pod::Elemental::Element::Nested->new({
      command  => 'head1',
      content  => 'VERSION',
      children => [ $content ],
    }),
  );
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;

__END__
=pod

=head1 NAME

Pod::Weaver::Section::Version - add a VERSION pod section

=head1 VERSION

version 3.101633

=head1 OVERVIEW

This section plugin will produce a hunk of Pod meant to indicate the version of
the document being viewed, like this:

  =head1 VERSION

  version 1.234

It will do nothing if there is no C<version> entry in the input.

=head1 ATTRIBUTES

=head2 format

The string to use when generating the version string.

Default: version %v

The following variables are available:

=over 4

=item * v - the version

=item * d - the CLDR format for L<DateTime>

=item * n - a newline

=item * t - a tab

=item * r - the name of the dist, present only if you use L<Dist::Zilla> to generate the POD!

=item * m - the name of the module, present only if L<PPI> parsed the document and it contained a package declaration!

=back

=head2 is_verbatim

A boolean value specifying whether the version paragraph should be verbatim or not.

Default: false

=head2 time_zone

The timezone to use when using L<DateTime> for the format.

Default: local

=head1 AUTHOR

Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
