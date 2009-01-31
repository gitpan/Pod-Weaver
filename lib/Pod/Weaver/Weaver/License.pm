package Pod::Weaver::Weaver::License;
our $VERSION = '2.001';

use Moose;
with 'Pod::Weaver::Role::Weaver';
# ABSTRACT: add a license notice

use Moose::Autobox;

sub weave {
  my ($self, $arg) = @_;

  return unless $arg->{license};

  my $notice = $arg->{license}->notice;
  chomp $notice;

  $self->weaver->output_pod->children->push(
    Pod::Elemental::Element::Command->new({
      type     => 'command',
      command  => 'head1',
      content  => 'COPYRIGHT AND LICENSE',
      children => [
        Pod::Elemental::Element::Text->new({
          type    => 'text',
          content => $notice,
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

Pod::Weaver::Weaver::License - add a license notice

=head1 VERSION

version 2.001

=head1 AUTHOR

  Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as perl itself.

=cut 


