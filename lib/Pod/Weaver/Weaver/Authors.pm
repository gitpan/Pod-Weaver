package Pod::Weaver::Weaver::Authors;
our $VERSION = '2.000';

use Moose;
with 'Pod::Weaver::Role::Weaver';
# ABSTRACT: add an AUTHORS section

use Moose::Autobox;

sub weave {
  my ($self, $arg) = @_;

  unless ($arg->{authors}) {
    return $self->log([
      'not adding authors section to %s: no authors',
      $arg->{filename},
    ]);
  }
  
  my $name = $arg->{authors}->length > 1 ? 'AUTHORS' : 'AUTHOR';
  my $str  = $arg->{authors}->join("\n");

  $str =~ s{^}{  }mg;

  $self->weaver->output_pod->push(
    Pod::Elemental::Element::Command->new({
      type     => 'command',
      command  => 'head1',
      content  => $name,
      children => [
        Pod::Elemental::Element::Text->new({
          type    => 'verbatim',
          content => $str,
        }),
      ],
    }),
  );
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;

__END__
=head1 NAME

Pod::Weaver::Weaver::Authors - add an AUTHORS section

=head1 VERSION

version 2.000

=head1 AUTHOR

  Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2008 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as perl itself.

