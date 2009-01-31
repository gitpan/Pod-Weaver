package Pod::Weaver::Weaver::Thingers;
our $VERSION = '2.001';

use Moose;
with 'Pod::Weaver::Role::Weaver';
# ABSTRACT: group together a bunch of =thingers

use Moose::Autobox;

has command => (is => 'ro', isa => 'Str', required => 1);
has header  => (is => 'ro', isa => 'Str', required => 1);

sub weave {
  my ($self) = @_;

  my @thingers;

  my $input = $self->weaver->input_pod->children;
  for my $i (reverse (0 .. $input->length - 1)) {
    my $element = $input->[ $i ];
    next unless $element->type eq 'command'
            and $element->command eq $self->command;

    splice @$input, $i, 1;
    unshift @thingers, $element;
  }

  return unless @thingers;

  $self->weaver->output_pod->children->push(
    Pod::Elemental::Element::Command->new({
      type     => 'command',
      command  => 'head1',
      content  => $self->header,
      children => @thingers->map(sub {
        Pod::Elemental::Element::Command->new({
          type     => 'command',
          command  => 'head2',
          content  => $_->content,
          children => scalar $_->children,
        })
      }),
    }),
  );
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;

__END__

=pod

=head1 NAME

Pod::Weaver::Weaver::Thingers - group together a bunch of =thingers

=head1 VERSION

version 2.001

=head1 AUTHOR

  Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as perl itself.

=cut 


