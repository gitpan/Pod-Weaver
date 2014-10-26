package Pod::Weaver;
our $VERSION = '2.000';

use Moose;
# ABSTRACT: do horrible things to POD, producing better docs

use List::MoreUtils qw(any);
use Moose::Autobox;
use PPI;
use Pod::Elemental;
use Pod::Eventual::Simple;
use Pod::Weaver::Parser::Nesting;
use Pod::Weaver::Role::Plugin;
use String::Flogger;
use String::RewritePrefix;


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

sub _h1 {
  my $name = shift;
  any { $_->{type} eq 'command' and $_->{content} =~ /^\Q$name$/m } @_;
}

has input_pod => (
  is   => 'rw',
  isa  => 'ArrayRef[Pod::Elemental::Element]',
);

has output_pod => (
  is   => 'ro',
  isa  => 'ArrayRef[Pod::Elemental::Element]',
  lazy => 1,
  required => 1,
  init_arg => undef,
  default  => sub { [] },
);

has ppi_doc => (
  is   => 'rw',
  isa  => 'PPI::Document',
);

has eventual => (
  is   => 'ro',
  isa  => 'Str|Object',
  required => 1,
  default  => 'Pod::Eventual::Simple',
);

has elemental => (
  is   => 'ro',
  isa  => 'Str|Object',
  required => 1,
  default  => 'Pod::Elemental',
);


has plugins => (
  is  => 'ro',
  isa => 'ArrayRef[Pod::Weaver::Role::Plugin]',
  required => 1,
  lazy     => 1,
  init_arg => undef,
  default  => sub { [] },
);

has _config => (
  is  => 'ro',
  isa => 'ArrayRef',
  default => sub {
    my @plugins = String::RewritePrefix->rewrite(
      {
        '=' => '',
        ''  => 'Pod::Weaver::Plugin::',
        '~' => 'Pod::Weaver::Weaver::',
      },
      qw(~Abstract ~Version ~Authors ~License),
    );
    my $return = [ map {; [ $_ => { '=name' => $_ } ] } @plugins ];
    splice @$return, 2, 0, [
      'Pod::Weaver::Weaver::Maybe' => {
        '=name' => 'Maybe',
        section => [ qw(SYNOPSIS DESCRIPTION) ],
      },
    ],
    [
      'Pod::Weaver::Weaver::Thingers' => {
        '=name' => 'Attributes',
        command => 'attr',
        header  => 'ATTRIBUTES',
      },
    ],
    [
      'Pod::Weaver::Weaver::Thingers' => {
        '=name' => 'Methods',
        command => 'method',
        header  => 'METHODS',
      },
    ];
    return $return;
  },
);

sub BUILD {
  my ($self) = @_;

  for my $entry ($self->_config->flatten) {
    my ($plugin_class, $config) = @$entry;
    eval "require $plugin_class; 1" or die;
    $self->plugins->push(
      $plugin_class->new( $config->merge({ weaver  => $self }) )
    );
  }
}

sub plugins_with {
  my ($self, $role) = @_;

  $role =~ s/^-/Pod::Weaver::Role::/;
  my $plugins = $self->plugins->grep(sub { $_->does($role) });

  return $plugins;
}

sub munge_pod_string {
  my ($self, $content, $arg) = @_;

  # This won't last. It's just here transitionally. -- rjbs, 2008-10-22
  $self = $self->new unless ref $self;

  $arg = { filename => 'document' }->merge($arg || {});

  $self->ppi_doc( PPI::Document->new(\$content) );

  unless ($self->ppi_doc) {
    $self->log("can't produce PPI::Document from $arg->{filename}; giving up");
    return $content;
  }

  my @pod_tokens = map {"$_"} @{ $self->ppi_doc->find('PPI::Token::Pod') || [] };
  $self->ppi_doc->prune('PPI::Token::Pod');

  my $podless_doc_str = $self->ppi_doc->serialize;

  if (
    $self->eventual->read_string($podless_doc_str)->grep(sub {
      $_->{type} ne 'nonpod'
    })->length
  ) {
    $self->log(
      sprintf "can't invoke %s on %s: there is POD inside string literals",
        'Pod::Weaver', $arg->{filename}
    );
    return;
  }

  my $elements = $self->elemental->read_string(join "\n", @pod_tokens);

  $self->input_pod( $elements );

  for my $plugin ($self->plugins_with(-Weaver)->flatten) {
    $self->log([ 'invoking plugin %s', $plugin->plugin_name ]);
    $plugin->weave($arg);
  }

  $self->output_pod->push($self->input_pod->flatten);

  my $newpod = $self->output_pod->map(sub { $_->as_string })->join("\n");

  my $end = do {
    my $end_elem = $self->ppi_doc->find('PPI::Statement::Data')
                || $self->ppi_doc->find('PPI::Statement::End');
    join q{}, @{ $end_elem || [] };
  };

  $self->ppi_doc->prune('PPI::Statement::End');
  $self->ppi_doc->prune('PPI::Statement::Data');

  $content = $end ? "$podless_doc_str\n\n$newpod\n\n$end"
                  : "$podless_doc_str\n__END__\n$newpod\n";

  return $content;
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;

__END__
=head1 NAME

Pod::Weaver - do horrible things to POD, producing better docs

=head1 VERSION

version 2.000

=head1 DESCRIPTION

Pod::Weaver is a work in progress, which rips apart your kinda-POD and
reconstructs it as boring old real POD.

=head1 METHODS

=head2 munge_pod_string

  my $new_content = Pod::Weaver->munge_pod_string($string, \%arg);

Right now, this is the only method.  You feed it a string containing a
POD-riddled document and it returns a woven form.  Right now, you can't really
do much configuration of the loom.

Valid arguments are:

  filename - the name of the document file being rewritten (for errors)
  version  - the version of the document
  authors  - an arrayref of document authors (provided as strings)
  license  - the license of the document (a Software::License object)

=head1 AUTHOR

  Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2008 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as perl itself.

=head1 WARNING

This code is really, really sketchy.  It's crude and brutal and will probably
break whatever it is you were trying to do.

Eventually, this code will be really awesome.  I hope.  It will probably
provide an interface to something more cool and sophisticated.  Until then,
don't expect it to do anything but bring sorrow to you and your people.

