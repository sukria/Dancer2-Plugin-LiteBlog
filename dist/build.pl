#!/usr/bin/env perl
use strict;
use warnings;

=head1 Scaffolder to generate views

$ ./dist/build.pl 

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

use LiteBlogdist;
my $files = LiteBlogDist::slurp_files($ARGV[0]);
LiteBlogDist::write_file($ARGV[1], $files);

