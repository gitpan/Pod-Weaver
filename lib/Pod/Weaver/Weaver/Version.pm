package Pod::Weaver::Weaver::Version;
our $VERSION = '2.001';

use Moose;
with 'Pod::Weaver::Role::Weaver';
# ABSTRACT: add a VERSION pod section to your Perl module

use Moose::Autobox;

sub weave {
  my ($self, $arg) = @_;
  return unless $arg->{version};

  $self->weaver->output_pod->children->push(
    Pod::Elemental::Element::Command->new({
      type     => 'command',
      command  => 'head1',
      content  => 'VERSION',
      children => [
        Pod::Elemental::Element::Text->new({
          type    => 'text',
          content => sprintf('version %s', $arg->{version}),
        }),
      ],
    }),
  );
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;

__END__

=pod

=head1 NAME

Pod::Weaver::Weaver::Version - add a VERSION pod section to your Perl module

=head1 VERSION

version 2.001

=head1 AUTHOR

  Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as perl itself.

=cut 


