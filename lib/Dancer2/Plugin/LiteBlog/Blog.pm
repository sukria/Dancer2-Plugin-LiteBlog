package Dancer2::Plugin::LiteBlog::Blog;
use Moo;
use Carp 'croak';
use YAML::XS;
use File::Spec;
use File::Stat;
use Path::Tiny;
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
            next if $@; # invalid path for a LiteBlog::Article object
            
            eval { $post->content && $post->title };
            next if $@; # invalid LiteBlog::Article object: no content & meta

            # At this point, we're sure the post is OK to be rendered.
            push @posts, $post;
        }
        
        return \@posts;
    },
);

=head2 select_articles (%params)

Lookup the article repository of the object (C<root>) for articles that 
match the criteria.

Articles are always returned in descending chronological order (using their 
published_date attibute).

  params:
    limit: (default: 1), number of article to retreive (max: 20).
    category: if specified, limit the lookup to articles of that category

=cut

sub select_articles {
    my ($self, %params) = @_;

    my $limit = $params{limit} || 1;
    $limit = 20 if $limit > 20;

    # We'll look in the Blog's repository
    my $root = $self->root;

    # If a category is given, the root is the category's repo.
    if (defined $params{category}) {
        my $cat = $params{category};
        $root = File::Spec->catdir($root, $cat);
        croak "Not a valid category: '$cat'" if ! -d $root;
    }

    # Get the list of all directories in the root
    opendir my $dh, $root or croak "Cannot open directory: $!";
    my @dirs = grep { 
        -d File::Spec->catdir($root, $_) && !/^\.{1,2}$/ 
    } readdir $dh;
    closedir $dh;

    # Sort directories by creation date in descending order
    @dirs = sort {
        my $time_a = $self->created_time(File::Spec->catdir($root, $a));
        my $time_b = $self->created_time(File::Spec->catdir($root, $b));
        $time_b <=> $time_a;
    } @dirs;

    my @records;
    my $count = 0;
    # Load Article objects up to the limit
    foreach my $dir (@dirs) {
        my $article;
        $article = Dancer2::Plugin::LiteBlog::Article->new( 
            basedir => File::Spec->catdir($root, $dir) );

        # make sur this is a valid article 
        eval { $article->content };
        next if $@;

        push @records, $article;
        last if ++$count == $limit;
    }
    return \@records;
}

sub created_time {
    my ($self, $file_path) = @_;
    my $path = path($file_path);

    # Hopefully the underlying FS supports birthtime
    my $time;
    if ( $path->can('birthtime') ) {
        $time = $path->birthtime;
    }
    else {
        my @stat = stat($file_path);
        $time = $stat[9]; # mtime
    }
    return $time;
}


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

# Dancer Section - TODO: split this class in two?

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
                        { 
                            label => "In: ".$article->category, 
                            link => "$prefix/$cat" 
                        },
                        { 
                            label => "Last update: ".$article->published_date 
                        }
                    ],
                },
                {
                    layout => 'liteblog'
                });
        }
    );

    # the /category landing page
    $plugin->app->add_route(
        method => 'get',
        regexp => "${prefix}/:category/?",
        code   => sub {
            my $category = $plugin->dsl->param('category');
            if (! -d File::Spec->catdir($self->root, $category)) {
                $plugin->dsl->info("Invalid category requested: '$category'");
                return $plugin->dsl->status('not_found');
            }
            my $articles = $self->select_articles(category => $category, limit => 6);
            return $plugin->dsl->template(
                'liteblog/single-page', {
                    page_title => ucfirst($category)." Stories",
                    content => $plugin->dsl->template('liteblog/widgets/blog-cards', {
                    widget => {
                        title =>  "Title",
                        elements  => $articles,
                        #TODO: readmore_button => 'Load more articles', 
                        }})
                }, 
                {layout => 'liteblog'}
            );
        }
    );
}

1;
