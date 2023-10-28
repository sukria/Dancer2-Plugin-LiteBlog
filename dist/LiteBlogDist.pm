package LiteBlogDist;

use strict;
use warnings;
use Carp 'croak';
use File::Slurp 'read_file';
use File::Temp 'tempfile';
use File::Copy 'move';
use MIME::Base64;

my @files_to_embed = qw(
    public/images/liteblog.jpg
    public/css/liteblog.css
    public/css/liteblog/blog.css
    views/layouts/liteblog.tt
    views/liteblog/index.tt
    views/liteblog/single-page.tt
    views/liteblog/widgets/blog.tt
    views/liteblog/widgets/activities.tt
    articles/blog-meta.yml
    articles/tech/first-article/content.md
    articles/tech/first-article/meta.yml
    activities.yml
);

sub image_to_base64 {
    my ($image_path) = @_;
	croak "Not a valid file : $image_path" if (! -e $image_path) ;

    # Read the binary content of the file
    my $binary_data = read_file($image_path, binmode => ':raw');
    
	return encode_base64($binary_data);
}

sub slurp_files {
    my ($base_dir) = @_;

    my $files = {};
    foreach my $f (@files_to_embed) {
        $files->{$f} = {
            path => File::Spec->catfile($base_dir, split('/', $f))
        };
    }

    foreach my $file_name (keys %$files) {
        my $f = $files->{$file_name}->{path};
        croak "not a readable file : $f" if ! -r $f;
        if ($file_name =~ /\.(jpg|png)$/) {
            $files->{$file_name}->{content} = image_to_base64($f);
        }
        else {
            $files->{$file_name}->{content} = 
                read_file($f, { binmode => ':encoding(UTF-8)' });
        }
    }

    return $files;
}

sub write_file {
    my ($basedir, $files) = @_;
    my ($fh, $filename) = tempfile();

    require 'Dancer2/Plugin/LiteBlog.pm';
    print $fh "package Dancer2::Plugin::LiteBlog::Scaffolder::Data;
sub build { ${Dancer2::Plugin::LiteBlog::VERSION} }
1;
__DATA__
";

    my $libdir = File::Spec->catfile($basedir, qw(Dancer2 Plugin LiteBlog Scaffolder) );
    if (! -d $libdir) {
        mkdir $libdir or croak "Unable to create dir $libdir";
        print "+ $libdir\n";
    }

    my $path = File::Spec->catfile($libdir, 'Data.pm');
    foreach my $file_name (keys %{$files}) {
        print $fh "--- $file_name\n";
        print $fh $files->{$file_name}->{content}."\n";
        print "+ .. $file_name content\n";
    }
    close $fh;


    move($filename, $path) or croak "Unable to create $path ($filename)";
    print "+ $path\n";
}


1;
