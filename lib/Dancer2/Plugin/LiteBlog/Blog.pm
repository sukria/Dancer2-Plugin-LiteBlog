package Dancer2::Plugin::LiteBlog::Blog;
use Moo;
use Carp 'croak';
use YAML::XS;
use File::Spec;
use Dancer2::Plugin::LiteBlog::Article;

extends 'Dancer2::Plugin::LiteBlog::Widget';

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

has mount => (
    is => 'ro',
    default => sub {
        "/blog"
    },
);

# The widget returns the featured posts.
# TODO : option to return the last N posts instead.
has elements => (
    is => 'ro',
    lazy => 1,
    default => sub {
        my ($self) = @_;
        
        my @posts;
        foreach my $path (@{ $self->meta->{featured_posts} }) {
            my $post;
            eval { $post = Dancer2::Plugin::LiteBlog::Article->new(
                    base_path => $self->mount,
                    basedir => File::Spec->catfile( $self->root, $path)
                )
            };
            push @posts, $post if ! $@;
        }
        
        return \@posts;
    },
);

sub find_article {
    my ($self, %params) = @_;
    my $path = $params{path};
    croak "Required param 'path' missing" if !defined $path;

    # remove starting '/' and trailing '/'
    $path =~ s/^\///;
    $path =~ s/\/$//;
    
    my $category = $params{category};
    if (defined $category) {
        croak "Invalid category '$category'" if $category =~ /\//;
        $path = "${category}/${path}";
    };

    my $article;
    eval { 
        $article = Dancer2::Plugin::LiteBlog::Article->new(
            base_path => $self->mount,
            basedir => File::Spec->catfile( $self->root, $path));
    };
    return $article;
}

sub has_routes { 1 }

sub declare_routes {
    my ($self, $plugin, $config) = @_;

    my $prefix = $config->{mount} || '/blog';
    $plugin->dsl->info("LiteBlog::Blog - declaring route ${prefix}/:cat/:slug");

    # /blog/:category/:permalink
    $plugin->app->add_route(
        method  => 'get',
        regexp  => "${prefix}/:cat/:slug",
        code    => sub {
            my $cat  = $plugin->dsl->param('cat');
            my $slug = $plugin->dsl->param('slug');

            $plugin->dsl->info("Looking for article: $cat/$slug");
            my $article = $self->find_article(category => $cat, path => $slug );

            if (! defined $article) {
                $plugin->dsl->info("Article not found : $cat/$slug");
                return $plugin->dsl->status('not_found');
            }
            # TODO hanlde invalid/missing $article->content as a 404

            return $plugin->dsl->template(
                'liteblog/single-page',
                {
                    page_title => $article->title,
                    content    => $article->content, 
                    meta       => [
                        { label => $article->category, link => "$prefix/$cat" },
                        { label => $article->published_date }
                    ],
                },
                {
                    layout => 'liteblog'
                });
        }
    );
}

1;
