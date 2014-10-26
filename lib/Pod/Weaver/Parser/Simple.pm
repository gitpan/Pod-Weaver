use strict;
use warnings;
package Pod::Weaver::Parser::Simple;
our $VERSION = '2.000';

use Pod::Eventual::Simple;
BEGIN { our @ISA = 'Pod::Eventual::Simple'; }

use Moose::Autobox;
use Pod::Weaver::PodChunk;

sub read_handle {
  my ($self, @args) = @_;

  # XXX: Argh, hate! -- rjbs, 2008-10-19
  $self = $self->new unless ref $self;
  
  my $events = $self->SUPER::read_handle(@args);
  my $chunks = $self->chunkify_pod($events);

  return $chunks;
}

sub handle_nonpod {}

sub chunkify_pod {
  my ($self, $entries) = @_;
  return $entries->map(sub { Pod::Weaver::PodChunk->new($_) });
}

1;

__END__
=head1 NAME

Pod::Weaver::Parser::Simple

=head1 VERSION

version 2.000

=head1 AUTHOR

  Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2008 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as perl itself.

