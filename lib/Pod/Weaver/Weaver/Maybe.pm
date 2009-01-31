package Pod::Weaver::Weaver::Maybe;
our $VERSION = '2.001';

use Moose;
with 'Pod::Weaver::Role::Weaver';
# ABSTRACT: expect a top-level section to appear, maybe

use Moose::Autobox;

has sections => (
  is  => 'ro',
  isa => 'ArrayRef[Str]',
  auto_deref => 1,
  required   => 1,
  init_arg   => 'section',
);

sub weave {
  my ($self) = @_;

  for my $section ($self->sections) {
    # XXX Is this right? -- rjbs, 2008-11-21
    my $input = $self->weaver->input_pod->children;
    my @to_add;

    for my $i (reverse (0 .. $#$input)) {
      my $elem = $input->[$i];

      next unless $elem->type eq 'command';
      next unless lc $elem->command eq lc $section
        or ($elem->command eq 'head1' and lc $elem->content eq lc $section);

      if ($elem->command eq $section) {
        my $new_elem = Pod::Elemental::Element::Commmand->new({
          type     => 'command',
          command  => 'head1',
          content  => $section,
          children => $elem->children,
        });

        $elem = $new_elem;
      }

      splice @$input, $i, 1;
      unshift @to_add, $elem;
    }

    $self->weaver->output_pod->children->push(@to_add);
  }
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;

__END__

=pod

=head1 NAME

Pod::Weaver::Weaver::Maybe - expect a top-level section to appear, maybe

=head1 VERSION

version 2.001

=head1 AUTHOR

  Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as perl itself.

=cut 


