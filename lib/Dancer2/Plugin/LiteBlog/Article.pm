package Dancer2::Plugin::LiteBlog::Article;
use Moo;
use Carp 'croak';
use File::Spec;
use File::Basename;
use Path::Tiny;
use YAML::XS;
use Text::Markdown 'markdown';
use File::Slurp;
use DateTime;

has basedir => (
    is => 'ro',
    required => 1,
    isa => sub {
        my $val = shift;
        croak "Not a valid directory ($val)" if ! -d $val;
    },
);

has base_path => (
    is => 'ro',
    default => sub { '/blog' },
);

has slug => (
    is => 'ro',
    lazy => 1,
    default => sub {
        my ($self) = @_;
        return basename($self->basedir);
    },
);

has category => (
    is => 'ro',
    lazy => 1,
    default => sub {
        my ($self) = @_;
        my $parentdir = basename(dirname($self->basedir));
        return ($parentdir eq 'articles') ? 'page' : $parentdir;
    },
);

has published_time => (
    is => 'ro',
    lazy => 1,
    default => sub {
        my ($self) = @_;
        my $content_file = File::Spec->catfile($self->basedir, 'content.md');
        my $path = path($content_file);

        # Hopefully the underlying FS supports birthtime
        my $time;
        if ( $path->can('birthtime') ) {
            $time = $path->birthtime;
        }
        else {
            my @stat = stat($content_file);
            $time = $stat[9]; # mtime
        }
        return $time;
    }
);

has published_date => (
    is => 'ro',
    lazy => 1,
    default => sub {
        my ($self) = @_;
        my $time = $self->published_time;
        my $dt = DateTime->from_epoch( epoch => $self->published_time );
        return $dt->strftime('%d %B, %Y');  # e.g., "25 October, 2023"
    },
);
has is_page => (
    is => 'ro',
    lazy => 1,
    default => sub {
        my ($self) = @_;
        return $self->category eq 'page';
    },
);

has meta => (
    is => 'ro',
    lazy => 1,
    default => sub {
        my ($self) = @_;
        my $meta_file = File::Spec->catfile($self->basedir, 'meta.yml');
        if (! -e $meta_file) {
            croak "No meta file, unable to initialize this article";
        }
        return YAML::XS::LoadFile($meta_file);
    },
);

has title => (
    is => 'ro',
    lazy => 1,
    default => sub {
        my ($self) = @_;
        return $self->meta->{'title'};
    },
);

has image => (
    is => 'ro',
    lazy => 1,
    default => sub {
        my ($self) = @_;
        return $self->meta->{'image'};
    },
);

has tags => (
    is => 'ro',
    lazy => 1,
    default => sub {
        my ($self) = @_;
        return $self->meta->{'tags'};
    },
);

has excerpt => (
    is => 'ro',
    lazy => 1,
    default => sub {
        my ($self) = @_;
        return $self->meta->{'excerpt'};
    },
);

has permalink => (
    is => 'ro',
    lazy => 1,
    default => sub {
        my ($self) = @_;
        if ($self->is_page) {
            return '/' . $self->slug;
        }
        return join('/', ($self->base_path, $self->category, $self->slug ));
    },
);

has content => (
    is => 'ro',
    lazy => 1,
    default => sub {
        my ($self) = @_;
        my $content_file = File::Spec->catfile($self->basedir, 'content.md');
        if (! -e $content_file) {
            croak "content.md file not found in ".$self->basedir;
        };
    
        my $markdown = read_file($content_file, { binmode => ':encoding(UTF-8)' });
        return markdown($markdown);
    },
);

1;
