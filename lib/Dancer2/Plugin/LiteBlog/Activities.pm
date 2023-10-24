package Dancer2::Plugin::LiteBlog::Activities;
use Moo;
use Carp 'croak';
use YAML::XS;
use File::Spec;

# TODO : make a parent class to inherit that (same as Blog)
has rootdir => (
    is => 'ro',
    required => 1,
    isa => sub {
        my $val = shift;
        croak "Not a valid directory ($val)" if ! -d $val;
    },
);

has file => (
    is => 'ro',
    required => 1,
);

# TODO: again, should be refactored with a common logic of loading a YML file
# (same as 'meta') in Blog.pm
has content => (
    is => 'ro',
    lazy => 1,
    default => sub {
        my ($self) = @_;
        my $activities = File::Spec->catfile($self->rootdir, $self->file);
        if (! -e $activities) {
            croak "Missing file: $activities";
        }
        return YAML::XS::LoadFile($activities);
    },
);

1;
