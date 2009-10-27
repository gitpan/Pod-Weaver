package Pod::Weaver;
our $VERSION = '3.093000';


use Moose;
# ABSTRACT: weave together a Pod document from an outline

use namespace::autoclean;


use Moose::Autobox 0.10;
use Pod::Elemental;
use Pod::Elemental::Document;
use Pod::Weaver::Config::Finder;
use Pod::Weaver::Role::Plugin;
use String::Flogger;


{
  package
    Pod::Weaver::_Logger;
  sub log { printf "%s\n", String::Flogger->flog($_[1]) }
  sub new { bless {} => $_[0] }
}

has logger => (
  lazy    => 1,
  default => sub { Pod::Weaver::_Logger->new },
  handles => [ qw(log) ]
);


has plugins => (
  is  => 'ro',
  isa => 'ArrayRef[Pod::Weaver::Role::Plugin]',
  required => 1,
  lazy     => 1,
  init_arg => undef,
  default  => sub { [] },
);


sub plugins_with {
  my ($self, $role) = @_;

  $role =~ s/^-/Pod::Weaver::Role::/;
  my $plugins = $self->plugins->grep(sub { $_->does($role) });

  return $plugins;
}


sub weave_document {
  my ($self, $input) = @_;

  my $document = Pod::Elemental::Document->new;

  $self->plugins_with(-Preparer)->each_value(sub {
    $_->prepare_input($input);
  });

  $self->plugins_with(-Dialect)->each_value(sub {
    $_->translate_dialect($input->{pod_document});
  });

  $self->plugins_with(-Transformer)->each_value(sub {
    $_->transform_document($input->{pod_document});
  });

  $self->plugins_with(-Section)->each_value(sub {
    $_->weave_section($document, $input);
  });

  $self->plugins_with(-Finalizer)->each_value(sub {
    $_->finalize_document($document, $input);
  });

  return $document;
}


sub new_with_default_config {
  my ($class) = @_;
  my $weaver = $class->new;

  {
    require Pod::Weaver::PluginBundle::CorePrep;
    my @plugins = Pod::Weaver::PluginBundle::CorePrep->mvp_bundle_config({});

    for my $plugin (@plugins) {
      eval "require $plugin->[1]; 1" or die;
      $weaver->plugins->push($plugin->[1]->new({
        %{ $plugin->[2] },
        plugin_name => $plugin->[0],
        weaver      => $weaver,
      }));
    }
  }

  {
    require Pod::Weaver::Section::Name;
    my $name = Pod::Weaver::Section::Name->new({
      weaver      => $weaver,
      plugin_name => 'Name',
    });

    $weaver->plugins->push($name);
  }

  {
    require Pod::Weaver::Section::Version;
    my $version = Pod::Weaver::Section::Version->new({
      weaver      => $weaver,
      plugin_name => 'Version',
    });

    $weaver->plugins->push($version);
  }

  {
    require Pod::Weaver::Section::Region;
    my $prelude = Pod::Weaver::Section::Region->new({
      weaver      => $weaver,
      plugin_name => 'prelude',
    });

    $weaver->plugins->push($prelude);
  }

  {
    require Pod::Weaver::Section::Generic;
    for my $section (qw(SYNOPSIS DESCRIPTION OVERVIEW)) {
      my $generic = Pod::Weaver::Section::Generic->new({
        weaver      => $weaver,
        plugin_name => $section,
      });

      $weaver->plugins->push($generic);
    }
  }

  {
    require Pod::Weaver::Section::Collect;
    for my $pair (
      [ qw(attr   ATTRIBUTES) ],
      [ qw(method METHODS   ) ],
    ) {
      my $collect = Pod::Weaver::Section::Collect->new({
        weaver      => $weaver,
        plugin_name => $pair->[1],
        command     => $pair->[0],
      });

      $weaver->plugins->push($collect);
    }
  }

  {
    require Pod::Weaver::Section::Leftovers;
    my $leftovers = Pod::Weaver::Section::Leftovers->new({
      weaver      => $weaver,
      plugin_name => 'Leftovers',
    });

    $weaver->plugins->push($leftovers);
  }

  {
    require Pod::Weaver::Section::Region;
    my $postlude = Pod::Weaver::Section::Region->new({
      weaver      => $weaver,
      plugin_name => 'postlude',
    });

    $weaver->plugins->push($postlude);
  }

  {
    require Pod::Weaver::Section::Authors;
    my $authors = Pod::Weaver::Section::Authors->new({
      weaver      => $weaver,
      plugin_name => 'Authors',
    });

    $weaver->plugins->push($authors);
  }

  {
    require Pod::Weaver::Section::Legal;
    my $legal = Pod::Weaver::Section::Legal->new({
      weaver      => $weaver,
      plugin_name => 'Legal',
    });

    $weaver->plugins->push($legal);
  }

  return $weaver;
}

sub new_from_config {
  my ($class, $arg) = @_;
  
  my ($sequence) = Pod::Weaver::Config::Finder->new->read_config({
    root     => $arg->{root}     || '.',
    basename => $arg->{basename} || 'weaver',
  });

  return $class->new_from_config_sequence($sequence);
}

sub new_from_config_sequence {
  my ($class, $seq) = @_;

  confess("config must be a Config::MVP::Sequence")
    unless $seq and $seq->isa('Config::MVP::Sequence');

  my $core_config = $seq->section_named('_')->payload;

  my $self = $class->new($core_config);

  for my $section ($seq->sections) {
    next if $section->name eq '_';

    my ($name, $plugin_class, $arg) = (
      $section->name,
      $section->package,
      $section->payload,
    );

    # $self->log("initializing plugin $name ($plugin_class)");

    confess "arguments attempted to override 'plugin_name'"
      if defined $arg->{plugin_name};

    confess "arguments attempted to override 'weaver'"
      if defined $arg->{weaver};

    $self->plugins->push(
      $plugin_class->new({
        %$arg,
        plugin_name => $name,
        weaver      => $self,
      })
    );
  }

  return $self;
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;

__END__
=pod

=head1 NAME

Pod::Weaver - weave together a Pod document from an outline

=head1 VERSION

version 3.093000

=head1 SYNOPSIS

  my $weaver = Pod::Weaver->new_with_default_config;

  my $document = $weaver->weave_document({
    pod_document => $pod_elemental_document,
    ppi_document => $ppi_document,

    license  => $software_license,
    version  => $version_string,
    authors  => \@author_names,
  })

=head1 DESCRIPTION

Pod::Weaver is a system for building Pod documents from templates.  It doesn't
perform simple text substitution, but instead builds a
Pod::Elemental::Document.  Its plugins sketch out a series of sections
that will be produced based on an existing Pod document or other provided
information.

=head1 ATTRIBUTES

=head2 logger

This attribute stores the logger, which must provide a log method.  The
weaver's log method delegates to the logger's log method.

=head2 plugins

This attribute is an arrayref of objects that can perform the
L<Pod::Weaver::Role::Plugin> role.  In general, its contents are found through
the C<L</plugins_with>> method.

=head1 METHODS

=head2 plugins_with

  my $plugins_array_ref = $weaver->plugins_with('-Section');

This method will return an arrayref of plugins that perform the given role, in
the order of their registration.  If the role name begins with a hyphen, the
method will prepend C<Pod::Weaver::Role::>.

=head2 weave_document

  my $document = $weaver->weave_document(\%input);

This is the most important method in Pod::Weaver.  Given a set of input
parameters, it will weave a new document.  Different section plugins will
expect different input parameters to be present, but some common ones include:

  pod_document - a Pod::Elemental::Document for the original Pod document
  ppi_document - a PPI document for the source of the module being documented
  license      - a Software::License object for the source module's license
  version      - a version (string) to use in produced documentation

The C<pod_document> should have gone through a L<Pod5
transformer|Pod::Elemental::Transformer::Pod5>, and should probably have had
its C<=head1> elements L<nested|Pod::Elemental::Transformer::Nester>.

The method will return a new Pod::Elemental::Document.  The input documents may
be destructively altered during the weaving process.  If they should be
untouched, pass in copies.

=head2 new_with_default_config

This method returns a new Pod::Weaver with a stock configuration, equivalent to
this:

  [@CorePrep]

  [Name]
  [Version]

  [Region  / prelude]

  [Generic / SYNOPSIS]
  [Generic / DESCRIPTION]
  [Generic / OVERVIEW]

  [Collect / ATTRIBUTES]
  command = attr

  [Collect / METHODS]
  command = method

  [Leftovers]

  [Region  / postlude]

  [Authors]
  [Legal]

=head1 AUTHOR

  Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

