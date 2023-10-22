use Test::More;
use strict;
use warnings;

use File::Basename;
use File::Spec;

use Dancer2::Plugin::LiteBlog::Blog;

my $localdir = File::Spec->catfile(dirname(__FILE__), 'articles');
my $blog = new Dancer2::Plugin::LiteBlog::Blog( rootdir => $localdir );

is (scalar(@{$blog->featured_posts}), 2, "only 2 posts successfully found");
is ($blog->featured_posts->[0]->slug, 'myhomepage', "first post is ok");
is ($blog->featured_posts->[0]->category, 'tech', "first post category is ok");
is ($blog->featured_posts->[1]->category, 'tech', "2nd post category is ok");
is ($blog->featured_posts->[1]->title, 'A title', "2nd post title is ok");

eval { $blog = Dancer2::Plugin::LiteBlog::Blog->new( rootdir => File::Spec->catfile($localdir, 'tech')) };

my $list;
eval { $list = $blog->featured_posts };
like ($@, qr/No meta file/, "Exception triggered when no blog-meta is found");

done_testing;
