package Pod::Weaver::Plugin::Transformer;
{
  $Pod::Weaver::Plugin::Transformer::VERSION = '3.101639';
}
use Moose;
with 'Pod::Weaver::Role::Dialect';
# ABSTRACT: apply arbitrary transformers

use namespace::autoclean;
use Moose::Autobox;

use Module::Runtime qw(use_module);
use List::MoreUtils qw(part);
use String::RewritePrefix;


has transformer => (is => 'ro', required => 1);

sub BUILDARGS {
  my ($class, @arg) = @_;
  my %copy = ref $arg[0] ? %{$arg[0]} : @arg;

  my @part = part { /\A\./ ? 0 : 1 } keys %copy;

  my %class_args = map { s/\A\.//; $_ => $copy{ ".$_" } } @{ $part[0] };
  my %xform_args = map {           $_ => $copy{ $_ }    } @{ $part[1] };

  my $xform_class = String::RewritePrefix->rewrite(
    { '' => 'Pod::Elemental::Transformer::', '=' => '' },
    delete $xform_args{transformer},
  );

  use_module($xform_class);

  my $plugin_name = delete $xform_args{plugin_name};
  my $weaver      = delete $xform_args{weaver};

  my $xform = $xform_class->new(\%xform_args);

  return {
    %class_args,
    plugin_name => $plugin_name,
    weaver      => $weaver,
    transformer => $xform,
  }
}

sub translate_dialect {
  my ($self, $pod_document) = @_;

  $self->transformer->transform_node( $pod_document );
}

1;

__END__

=pod

=head1 NAME

Pod::Weaver::Plugin::Transformer - apply arbitrary transformers

=head1 VERSION

version 3.101639

=head1 OVERVIEW

This plugin acts as a L<Pod::Weaver::Role::Dialect> that applies an arbitrary
L<Pod::Elemental::Transformer> to your input document.  It is configured like
this:

  [-Transformer / Lists]
  transformer = List
  format_name = outline

This will end up creating a transformer like this:

  my $xform = Pod::Elemental::Transformer::List->new({
    format_name => 'outline',
  });

and that transformer will then be handed the entire input Pod document.

=head1 AUTHOR

Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
