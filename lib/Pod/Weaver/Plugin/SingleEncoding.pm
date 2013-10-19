package Pod::Weaver::Plugin::SingleEncoding;
{
  $Pod::Weaver::Plugin::SingleEncoding::VERSION = '4.000'; # TRIAL
}
use Moose;
with(
  'Pod::Weaver::Role::Dialect',
  'Pod::Weaver::Role::Finalizer',
);
# ABSTRACT: ensure that there is exactly one =encoding of known value

use namespace::autoclean;
use Moose::Autobox;

use Pod::Elemental::Selectors -all;


has encoding => (
  is  => 'ro',
  isa => 'Str',
  default => 'UTF-8',
);

sub translate_dialect {
  my ($self, $document) = @_;

  my $childs = $document->children;
  my $is_enc = s_command([ qw(encoding) ]);
  my $want   = $self->encoding;

  for (reverse 0 .. $#$childs) {
    next unless $is_enc->( $childs->[ $_ ] );
    my $have = $childs->[$_]->content;
    $have =~ s/\s+\z//;
    my $ok = lc $have eq lc $want
          || lc $have eq 'utf8' && lc $want eq 'utf-8';

    confess "expected only $want encoding but found $have" unless $ok;

    splice @$childs, $_, 1;
  }

  return;
}

sub finalize_document {
  my ($self, $document, $input) = @_;

  my $encoding = Pod::Elemental::Element::Pod5::Command->new({
    command => 'encoding',
    content => $self->encoding,
  });

  my $childs = $document->children;
  my $is_pod = s_command([ qw(pod) ]); # ??
  for (0 .. $#$childs) {
    next if $is_pod->( $childs->[ $_ ] );
    splice @$childs, $_, 0, $encoding;
    last;
  }

  return;
}

no Moose;
1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Pod::Weaver::Plugin::SingleEncoding - ensure that there is exactly one =encoding of known value

=head1 VERSION

version 4.000

=head1 OVERVIEW

I dunno, man, I just wrote this thing.

=head1 AUTHOR

Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
