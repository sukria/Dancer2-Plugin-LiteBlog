package Dancer2::Plugin::LiteBlog::Activities;
use Moo;
use Carp 'croak';
use YAML::XS;
use File::Spec;

extends 'Dancer2::Plugin::LiteBlog::Widget';

has source => (
    is => 'ro',
    required => 1,
);

# TODO: again, should be refactored with a common logic of loading a YML file
# (same as 'meta') in Blog.pm
has elements => (
    is => 'ro',
    lazy => 1,
    default => sub {
        my ($self) = @_;
        my $activities = File::Spec->catfile($self->root, $self->source);
        if (! -e $activities) {
            croak "Missing file: $activities";
        }
        return YAML::XS::LoadFile($activities);
    },
);

1;
