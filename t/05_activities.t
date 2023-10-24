use Test::More;
use strict;
use warnings;

use File::Basename;
use File::Spec;

use Dancer2::Plugin::LiteBlog::Activities;

my $activities;

my $localdir = File::Spec->catfile(dirname(__FILE__), 'doesnotexist');
eval { $activities = Dancer2::Plugin::LiteBlog::Activities->new( 
    rootdir => $localdir, file => 'activities.yml') };
like ($@, qr/Not a valid dir/, "Unable to create without a valid rootdir");

$localdir = File::Spec->catfile(dirname(__FILE__), 'liteblog');
eval { $activities = Dancer2::Plugin::LiteBlog::Activities->new( 
    rootdir => $localdir, file => 'doesnotexist.yml') };
is ($@, '', "Activities created with a valid rootdir");

eval { $activities->content };
like $@, qr/Missing file:/, "The activities file must be present";

$activities = Dancer2::Plugin::LiteBlog::Activities->new( 
    rootdir => $localdir, file => 'activities.yml');
eval { $activities->content };
is $@, '', "With a valid activities.yml file, it works";

is (scalar(@{ $activities->content }), 2, "activities has 2 elements");
is $activities->content->[1]->{'name'}, 'GitHub', "Second activity is GitHub";

done_testing;

