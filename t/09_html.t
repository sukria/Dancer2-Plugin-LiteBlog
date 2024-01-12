use Test::More;
use strict;
use warnings;

use File::Basename;
use File::Spec;

use Dancer2::Plugin::LiteBlog::Custom;

my $html;

my $localdir = File::Spec->catfile(dirname(__FILE__), 'doesnotexist');
eval { $html = Dancer2::Plugin::LiteBlog::Custom->new( 
    root => $localdir, source => 'content.html') };
like ($@, qr/Not a valid dir/, "Unable to create without a valid root");

$localdir = File::Spec->catfile(dirname(__FILE__), 'public');
eval { $html = Dancer2::Plugin::LiteBlog::Custom->new( 
    root => $localdir, source => 'doesnotexist.html') };
is ($@, '', "Custom created with a valid root");

eval { $html->elements};
like $@, qr/Missing file:/, "The html file must be present";

$html = Dancer2::Plugin::LiteBlog::Custom->new( 
    root => dirname($localdir), source => 'content.html');
eval { $html->elements };
is $@, '', "With a valid file, it works";

is (scalar(@{ $html->elements }), 1, "html has 1 element");
like $html->elements->[0], qr{This is some title}m, "Content looks good";

done_testing;

