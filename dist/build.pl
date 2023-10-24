#!/usr/bin/env perl
use strict;
use warnings;
use LiteBlogdist;

=head1 Scaffolder to generate views

$ ./dist/build.pl <sourcedir> <destdir>

Will read the t/views hierarchy and build the lib/Dancer2/Plugin/LiteBlog/ScaffolderData.pm file
This file will contain a __DATA__ section with all of those files, and will provide a method
to get their content for easy scaffolding.

=head1 Usage Example

In a new Dancer2 app intended to be coded with Dancer2::Plugin::LiteBlog :

 [~/Devel/myapp] $ liteblog-scaffold .
 ./views/layouts/main.tt created
 ./views/index.tt created
 ./views/article.tt created

=cut

my $source = $ARGV[0] || 't';
my $dest = $ARGV[1] || 'lib';

my $usage = "$0 <sourcedir> <destdir>
sourcedir: the directory where to find files to scaffold (default: 't')
destidr  : the directory where to write Dancer2/Plugin/LiteBlog/Scaffolder/Data.pm (default 'lib')\n";
if ($source eq '--help' || $source eq '-h') {
    print "$usage\n";
    exit 0;
}
if (! -d $source) {
    print "$usage\n<source> is Not a valid directory\n";
    exit 1;
}
if (! -d $dest) {
    print "$usage\n<dest> is Not a valid directory\n";
    exit 1;
}

my $files = LiteBlogDist::slurp_files($source);
LiteBlogDist::write_file($dest, $files);

