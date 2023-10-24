use Test::More;
use strict;
use warnings;

use Dancer2::Plugin::LiteBlog::Scaffolder;

my $d = Dancer2::Plugin::LiteBlog::Scaffolder->load;
like $d->{'views/layouts/main.tt'}, qr{<title>\[% title %\]}, 
    "Found views/layouts/main.tt, looks good";

done_testing;
