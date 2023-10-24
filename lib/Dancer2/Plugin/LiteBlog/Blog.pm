package Dancer2::Plugin::LiteBlog::Blog;
use Moo;
use Carp 'croak';
use YAML::XS;
use File::Spec;
use Dancer2::Plugin::LiteBlog::Article;

has root => (
    is => 'ro',
    required => 1,
    isa => sub {
        my $val = shift;
        croak "Not a valid directory ($val)" if ! -d $val;
    },
);

has meta => (
    is => 'ro',
    lazy => 1,
    default => sub {
        my ($self) = @_;
        my $meta = File::Spec->catfile($self->root, 'blog-meta.yml');
        if (! -e $meta) {
            croak "No meta file found for the blog : $meta";
        }
        return YAML::XS::LoadFile($meta);
    },
);

has featured_posts => (
    is => 'ro',
    lazy => 1,
    default => sub {
        my ($self) = @_;
        
        my @posts;
        foreach my $path (@{ $self->meta->{featured_posts} }) {
            my $post;
            eval { $post = Dancer2::Plugin::LiteBlog::Article->new(
                    basedir => File::Spec->catfile( $self->root, $path)
                )
            };
            push @posts, $post if ! $@;
        }
        
        return \@posts;
    },
);

1;
