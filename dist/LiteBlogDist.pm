package LiteBlogDist;

use strict;
use warnings;
use Carp 'croak';
use File::Slurp 'read_file';
use File::Temp 'tempfile';
use File::Copy 'move';

sub slurp_files {
    my ($base_dir) = @_;

    my $files = {};
    $files->{'views/layouts/main.tt'} = {
        path => File::Spec->catfile($base_dir, 'views', 'layouts', 'main.tt')
    };
    $files->{'views/index.tt'} = {
        path => File::Spec->catfile($base_dir, 'views', 'index.tt')
    };

    foreach my $file_name (keys %$files) {
        my $f = $files->{$file_name}->{path};
        croak "not a readable file : $f" if ! -r $f;
        $files->{$file_name}->{content}= read_file($f, { binmode => ':encoding(UTF-8)' });
    }

    return $files;
}

sub write_file {
    my ($basedir, $files) = @_;
    my ($fh, $filename) = tempfile();

    print $fh 'package Dancer2::Plugin::LiteBlog::Scaffolder::Data;
sub get { <DATA> }
1;
__DATA__
';

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
